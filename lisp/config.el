(put 'config 'rcsid 
 "$Id: config.el,v 1.51 2007-05-03 16:57:48 tombstone Exp $")
(require 'advice)
(require 'cl)

; would rather avoid this during init...
(require 'uname)

(setq *debug-config-error* t)

(defvar *configdir* "~/emacs/config/")

(defvar *config-file-name-member*
  (if (eq window-system 'w32)
      'member-ignore-case
    'member)
  "function to apply to determine filename equivalence")

(if (file-exists-p "~/emacs/.autoloads")
    (load-file  "~/emacs/.autoloads")
  )

; if a config dir exists for hostname, use it.  else if hostname contains the domain, use just the host part
(defvar *hostname* 
  (let ((*h* (hostname)))
    (cond 
     ((file-exists-p 
       (expand-file-name (concat *configdir* "hosts/"  *h*))) *h*)
     ((string-match "\\." *h*) 
      (setq *h* (substring *h* 0 (match-beginning 0))))
     )
    )
  )

; XXX this is redundant with "~/config/.fns"
(defvar *config-load-path*
  (mapcar 'expand-file-name (list (format "~/config/hosts/%s" *hostname*) 
				  (format "~/config/os/%s" (symbol-name window-system)) "~"))
  )

;; hooks for these preloaded modules need to be run now
(defvar hooked-preloaded-modules
	'("compile" "cl" "dired" "vc" "comint" "cc-mode" "info" "view")
  "list of functions that may be preloaded, invoke `post-wrap' at startup, also push onto `after-load-alist'"
  )

;; this advice allows pre- and post- hooks on all loaded features
;; this way customization can be tailored to the feature instead of all lumped together
;; also see eval-after-load

(defvar *debug-pre-load-hook* nil)
(defvar *debug-post-load-hook* nil)

; (setq *debug-pre-load-hook* t *debug-post-load-hook* t)
; (setq *debug-pre-load-hook* nil *debug-post-load-hook* nil)

(defvar *disable-load-hook* nil)

; (defvar *debug-config-list* '(xdb))
(defvar *debug-config-list* nil
  "list of atoms or strings representing names of functions to trap on pre- or post- load
specify string to trap an explicit load, specify an atom to trap a require") 

(defun loadp (prefix file)
  (let* ((f0 (file-name-nondirectory (format "%s" file)))
	 (f1 (format "%s%s" prefix f0))
	 (f2 (loop for x in load-path thereis (if (file-exists-p (format "%s/%s.el" x f1)) (format "%s/%s.el" x f1)))))
    (if (and (atom file) (funcall *config-file-name-member* file *debug-config-list*))
	(debug)
      )
    (and f2 (load f2 t t)))
  )

(defadvice load (around 
		 hook-load
		 first 
		 activate)

  "hook (load f) to optionally (load pre-f) (load f) (load post-f)
no errors if files don't exist.
 "
  (if (ad-has-enabled-advice 'load 'around)
      (progn
	(ad-disable-advice 
	 'load
	 'around
	 'hook-load)

	(ad-activate 'load))
    )

  (unless *disable-load-hook*
    (and *debug-pre-load-hook* (debug))
    (loadp "pre-" (ad-get-arg 0))
    )

  ad-do-it

  (unless *disable-load-hook*
    (and *debug-post-load-hook* (debug))
    (loadp "post-" (ad-get-arg 0))
    )

  (if (and (ad-has-any-advice 'load)
	   (not (ad-has-enabled-advice 'load 'around)))
      (progn
	(ad-enable-advice 
	 'load
	 'around
	 'hook-load)
	(ad-activate 'load)
	))
  )

(defadvice load-with-code-conversion (around 
		 hook-load-with-code-conversion
		 first 
		 activate)

  "hook (load-with-code-conversion f) to optionally (load pre-f) (load-with-code-conversion f) (load post-f)
no errors if files don't exist.
 "
  (if (ad-has-enabled-advice 'load-with-code-conversion 'around)
      (progn
	(ad-disable-advice 
	 'load-with-code-conversion
	 'around
	 'hook-load-with-code-conversion)

	(ad-activate 'load-with-code-conversion))
    )

  (unless *disable-load-hook*
    (and *debug-pre-load-hook* (debug))
    (loadp "pre-" (ad-get-arg 0))
    )

  ad-do-it

  (unless *disable-load-hook*
    (and *debug-post-load-hook* (debug))
    (loadp "post-" (ad-get-arg 0))
    )

  (if (and (ad-has-any-advice 'load-with-code-conversion)
	   (not (ad-has-enabled-advice 'load-with-code-conversion 'around)))
      (progn
	(ad-enable-advice 
	 'load-with-code-conversion
	 'around
	 'hook-load-with-code-conversion)
	(ad-activate 'load-with-code-conversion)
	))
  )

; (ad-has-enabled-advice 'load 'around)
; (ad-unadvise 'load)
; (ad-is-advised 'load)

; (defvar *debug-require-hook* t)

(defadvice require (around 
		    hook-require
		    first 
		    activate)

  "hook (require f) to optionally (load pre-f) (require f) (load post-f)
only if (not (featurep f))
no errors if files don't exist.
 "
  (if (featurep (ad-get-arg 0)) nil

  (if (ad-is-advised 'require)
      (ad-disable-advice 
       'require
       'around
       'hook-require))

    (ad-activate 'require)

; 		(and *debug-require-hook* (debug))
    (loadp "pre-" (ad-get-arg 0))

    ad-do-it

; 		(and *debug-require-hook* (debug))
    (loadp "post-" (ad-get-arg 0))

    (ad-enable-advice 
     'require
     'around
     'hook-require)
    (ad-activate 'require)
    )
  )

; (ad-unadvise 'require)
; (ad-is-advised 'require)

; warning: this fails for any built in functions, so ...
; we need to get fancy

(defmacro make-hook-name (fname)
  `(intern
    (concat "hook-" ,(symbol-name (eval fname)))
    )
  )
; (make-hook-name 'dired-mode)

(defvar add-to-load-path-hook nil)
(defun load-autoloads (x)
  (if (file-exists-p (concat x "/.autoloads"))
  ; maybe automatically generated 
      (load (concat x "/.autoloads") nil t))
  )

(unless (fboundp 'read-directory-name)
  (fset 'read-directory-name 'read-file-name)
  )

(defun add-to-load-path (x &optional append subdirs)
  "add ELEMENT to `load-path` if it exists, and isn't already there.
by default add to the head of the list.  with optional arg APPEND add at the end of the list
with optional second arg SUBDIRS, add all subdirectories as well.

if successful, runs the value of `add-to-load-path-hook` and returns the new value of load-path.
returns nil otherwise.
"
  (interactive (list (read-directory-name "Add to load-path: ")))
  (if (and
       (file-directory-p x)
       (not (funcall *config-file-name-member* x load-path))
       (not (string-match "/CVS$" x))
       (funcall 
	(if append
	    'append-to-list 'add-to-list)
	'load-path (expand-file-name x)))

      (if subdirs
	  (mapcar '(lambda (y) 
		     (if (and (file-directory-p (concat x "/" y)) (not (string= y ".")) (not (string= y "..")))
			 (add-to-load-path (concat x "/" y))))
		  (directory-files x)))

    (load-autoloads x)

    (run-hooks 'add-to-load-path-hook)
	
    load-path
    )
  )

; we need to apply some here on first invocation, since some functions come preloaded.

(defun post-wrap (f) 
  "load any post-* modules for module F"
  (interactive "smodule: ")
  (load (format "post-%s" f) t t)
  )

(defun load-list (pat)
  (interactive "spat: ")
  (mapconcat 'identity (loop for x in load-history when (string-match pat (car x)) collect (car x)) " ")
  )
; (load-list "post-cc")

(defun which (func)
  "display and return initial load-file for FUNC.
"
  (interactive "afunction: ")
  (and (boundp 'emacs-autoload-alist) 
       (apply 
	'(lambda (func loadfile) (message (format "%s loads from file %s" func loadfile))  loadfile)
	(assoc func emacs-autoload-alist))
       )
  )
; (setq x (which 'rfo))

; this helper function gives init files a weak inheritance capability

(defun this-load-file () (if load-in-progress load-file-name (buffer-file-name)))

(defun chain-parent-file (&optional arg)
  "return the parent of a load file.
this will be the one following it in load-path, if any.
with optional ARG, loads the file if found.

the current load file is determined by testing `load-in-progress'
if this is set, then the load file is given by `load-file-name',
otherwise it is given by `buffer-file-name'

this mechanism allows a sort of inheritance among load files.
a load file sitting in front of its 'parent' on the load-path can extend its settings by pre-chaining
or override them by post-chaining.
"
  (let ((f (this-load-file)))
    (and f
	 (let* (z
		(y (file-name-nondirectory f))
		(l 
		 (loop for x in load-path when (file-exists-p (setq z (concat x "/" y))) collect z))
		(tail (funcall *config-file-name-member* f l))
		(parent (and tail (cadr tail))))

  ; before we load the parent, see if we have a rcsid
	   
	   (let* ((base (intern (file-name-sans-extension y)))
		  (rcsid (get base 'rcsid))
		  (rcsid-chain (get base 'rcsid-chain)))
	     (if rcsid
		 (progn (push rcsid rcsid-chain) 
			(put base 'rcsid-chain rcsid-chain)))
	     )

	   (if (and arg parent)
	       (load parent)
	     parent)
	   )
	 )
    )
  )

(defun find-parent-file ()
  "visit the parent of this file see `chain-parent-file'"

  (interactive)
  (let ((f (chain-parent-file)))
    (if (and f (file-exists-p f))
	(find-file f)
      (message "no parent found"))))

(defun dotfn (fn)
  (loop for a in *config-load-path*
	do (let ((afn (format "%s/%s" a fn)))
	  (if (-f afn) (scan-file afn))
	  )))

(defun locate-config-file (fn)
  "find CONFIG along load-path.
searches first for config unadorned, then with extension .el
returns full path name.
"
  (let ((afn (loop for a in load-path
		   thereis (let ((afn (format "%s/%s" a fn)))
			     (or (and (-f afn) afn)
				 (and (-f (setq afn (concat afn ".el"))) afn))
			     )
		   )))
    afn)
  )
; (locate-config-file "host-init")
; (locate-config-file "os-init")

(defun find-config-file (fn)
  "visit CONFIG along load-path, if it exists.
see `locate-config-file'"

  (interactive "sconfig file: ")
  (let ((afn (locate-config-file fn)))
    (if afn (find-file afn) 
      (message "%s not found along load-path" fn)
      )
    )
  )

; xxx obsolete?
(defun host-config () 
  "find host specific config directory"
  (interactive)
  (let ((d 
	 (loop for x in load-path thereis (and (string-match "/hosts/" x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun ws-config () 
  "find os specific config directory"
  (interactive)
  (let* ((window-system-name (symbol-name window-system))
	(d 
	 (loop for x in load-path thereis (and (string-match (concat "/os/" window-system-name) x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun os-config () 
  "find os specific config directory"
  (interactive)
  (let* ((uname (uname))
	 (d 
	 (loop for x in load-path thereis (and (string-match (concat "/os/" uname) x) x))))
    (if (interactive-p)
	(if (file-name-directory d) (dired d) (message (format "directory %s doesn't exist" d)))
      d)
    )
  )

(defun host-init ()
  "shortcut for `find-config-file' \"host-init\""
  (interactive)

  (let ((fn (locate-config-file "host-init")))
    (if current-prefix-arg (dired (file-name-directory fn))
      (find-config-file "host-init")
      )
    )
  )

(defun os-init ()
  "shortcut for `find-config-file' \"os-init\""
  (interactive)
  (find-config-file "os-init")
  )

; these go at the head of the list
(mapcar 
 'add-to-load-path
 (list 
  (expand-file-name *configdir* "os")
  (expand-file-name (concat *configdir* "os/" (uname)))
  (expand-file-name (concat *configdir* "os/" (symbol-name window-system)))
  (expand-file-name (concat *configdir* "hosts/"  *hostname*))
  (expand-file-name (concat *configdir* (format "%d.%d" emacs-major-version emacs-minor-version)))
  (expand-file-name (concat *configdir* (format "%d" emacs-major-version)))
  )
 )

; these go at the head of the list
(condition-case err
    (mapcar 'add-to-load-path
     (nconc 
      (and emacsdir (directory-files (concat emacsdir "/site-lisp") t "^[a-zA-Z]"))
      (directory-files (concat share "/site-lisp") t "^[a-zA-Z]")
      (list (concat share "/site-lisp"))
      )
     )
  (file-error t)
  )

(condition-case x
    (loop for x in hooked-preloaded-modules
	  do
	  (or 
	   (member
	    `(,x (post-wrap ,x)) after-load-alist)
	      (push 
	       `(,x (post-wrap ,x)) after-load-alist))
	  )
  ; (pop after-load-alist)

  ; make sure load-history is correct
  (unless (loop for x in load-history
		thereis (string-match (concat "fns-" emacs-version) (car x)))
    (load
     (format "%s/fns-%s" 
	     (getenv "EMACSPATH")
	     emacs-version)))

  (error (progn (message "some kind of random error in %s" (if load-in-progress load-file-name (buffer-file-name))) 
		(if *debug-config-error* (debug))))
  )

; XXX these don't belong here
(menu-bar-mode -1)
(scroll-bar-mode -1)

(or 
 (and (boundp 'window-system) (load (symbol-name window-system) t t))	; window system specific
 (and (getenv "TERM") (load (getenv "TERM") t t))		;terminal specific
)

(load (format "Emacs%d" emacs-major-version) t t)	;; optional emacs-version specific overrides

(load (format "Emacs%d.%d" emacs-major-version emacs-minor-version) t t)	;; optional emacs-minor-version specific overrides

(load "os-init" t t)		; optional os specific info

(load "window-system-init" t t)		; optional window-system specific info

(load "host-init" t t)		; optional host specific info

(provide 'config)

