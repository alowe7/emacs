(put 'config 'rcsid 
 "$Id: config.el,v 1.40 2004-10-01 23:07:54 cvs Exp $")
(require 'advice)
(require 'cl)

(defvar *file-name-member*  'member "function to apply to determine filename equivalence")

(if (file-exists-p "~/emacs/.autoloads")
    (load-file  "~/emacs/.autoloads")
  )

(defvar *hostname* (or (getenv "COMPUTERNAME") (getenv "HOSTNAME")))

; XXX this is redundant with "~/config/.fns"
(defvar *config-load-path*
  (mapcar 'expand-file-name (list (format "~/config/hosts/%s" *hostname*) 
				  (format "~/config/os/%s" (symbol-name window-system)) "~"))
  )

(defvar *debug-config-error* nil)

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
    (if (and (atom file) (funcall *file-name-member* file *debug-config-list*))
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


(defun add-to-load-path (x &optional append subdirs)
  "add ELEMENT to `load-path` if it exists, and isn't already there.
by default add to the head of the list.  with optional arg APPEND add at the end of the list
with optional second arg SUBDIRS, add all subdirectories as well.

if successful, runs the value of `add-to-load-path-hook` and returns the new value of load-path.
returns nil otherwise.
"
  (if (and
       (file-directory-p x)
       (not (funcall *file-name-member* x load-path))
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
		(tail (funcall *file-name-member* f l))
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

(defun find-config-file (fn)
  (interactive "sconfig file: ")
  (let ((afn (loop for a in load-path
		   thereis (let ((afn (format "%s/%s.el" a fn)))
			     (and (-f afn) afn)
			     )
		   )))
    (if afn (find-file afn) 
      (message "%s not found along load-path" fn)
      )
    )
  )
(defun host-init () (interactive) (find-config-file "host-init"))

; these go at the head of the list
(mapcar 
 'add-to-load-path
 (list 
  (expand-file-name "~/emacs/config/os")
  (expand-file-name (concat "~/emacs/config/os/" (symbol-name window-system)))
  (expand-file-name (concat "~/emacs/config/hosts/"  *hostname*))
  (expand-file-name (concat "~/emacs/config/" (format "%d.%d" emacs-major-version emacs-minor-version)))
  (expand-file-name (concat "~/emacs/config/" (format "%d" emacs-major-version)))
  )
 )

; these go at the end of the list
(condition-case err
    (mapcar 
     '(lambda (x) (add-to-load-path x t))
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
	  (or (funcall *file-name-member*
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

(menu-bar-mode -1)
(scroll-bar-mode -1)

(or 
 (and (boundp 'window-system) (load (symbol-name window-system) t t))	; window system specific
 (and (getenv "TERM") (load (getenv "TERM") t t))		;terminal specific
)

;; optional emacs-version-specific overrides
(load (format "Emacs%d" emacs-major-version) t t)
;; optional emacs-version-specific overrides
(load (format "Emacs%d.%d" emacs-major-version emacs-minor-version) t t)

(load "os-init" t t)		; load os-specific info

;; optional host-specific overrides
(load "host-init" t t)

(provide 'config)

