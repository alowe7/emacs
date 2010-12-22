(put 'os-init 'rcsid 
 "$Id$")

(chain-parent-file t)

(require 'cat-utils)
(require 'file-association)
(require 'long-comment)

(load "frames" t t)

(defvar semicolon (read "?;"))
(defvar w32 'w32)

; definitions specific to the win32 window system

(defvar *systemroot*	(getenv "SYSTEMROOT"))
(defvar *systemdrive*	(getenv "SYSTEMDRIVE"))
(defvar *username*	(getenv "USERNAME"))

(autoload 'reg-query "reg" nil t)
(autoload 'reg-dump "reg" nil t)

;(setq frame-title-format '(buffer-file-name "%f" "%b"))
;(make-variable-buffer-local 'frame-title-format)

(setq dired-chmod-program "chmod")

;; (menu-bar-enable-clipboard)
;; (menu-bar-mode -1)
;(menu-bar-mode -1)

;; this makes autocompletion work better with bash
(setq comint-completion-addsuffix t)


;; (global-set-key "\C-:" (quote indent-for-comment))
(global-set-key (vector 'C-backspace) 'iconify-frame)

(defun w32-canonify (f &optional sysdrive)
  " expands FILENAME, using backslashes
optional DRIVE says which drive to use. "

  (cond
   ((string= f "/") "\\")
   ((string-match "\\(file:\\)?///\\(.\\)\|\\(.*\\)$" f)
    (concat (match-string 2 f) ":" (match-string 3 f)))
   (t
    (replace-regexp-in-string  "/" "\\\\" 
			       (replace-regexp-in-string  "//" "\\\\\\\\" 
							  (if sysdrive (expand-file-name 
									(substitute-in-file-name
									 (chomp f ?/))
									(and (string* sysdrive) (concat sysdrive "/")))
							    (substitute-in-file-name
							     (chomp f ?/))
							    )
							  )
			       )
    )
   )
  )
; (w32-canonify "file:///C|/home/a/.private/proxy.pac")
;(w32-canonify "/a/b/c")
;(w32-canonify "/")
(fset 'unc-canonify 'w32-canonify)

(defun unix-canonify (f &optional mixed)
  " expands FILENAME, using forward slashes.
if FILENAME is a list, return the list of canonified members
optional second arg MIXED says do not translate 
letter drive names.
if MIXED is 0, then ignore letter drive names.
"
  (if (listp f)
      (loop for x in f collect (unix-canonify x mixed))
    (let* 
	((default-directory "/")
	 (f (expand-file-name (substitute-in-file-name f))))
      (if (null mixed)
	  f
	(let
	    ((m (string-match "^[a-zA-Z]:" f)))
	  (if (eq mixed 0)
	      (substring f (match-end 0))
	    (concat "//" (upcase (substring f 0 1)) (substring f (match-end 0)))
	    )
	  )))
    )
  )

(defun unix-canonify-0 (f) (unix-canonify f 0))

(defalias 'canonify 'unix-canonify)

(defun unix-canonify-region (beg end)
  (interactive "r")
  (kill-region beg end)
  (insert (unix-canonify (expand-file-name (car kill-ring))))
  )

(defun split-path (&optional path)
  (let ((path (or path (getenv "PATH"))))
    (split (unix-canonify-path path) ":")
    )
  )

(defun unix-canonify-env (name)
  "`unix-canonify-path' on value of environment variable NAME and push result onto `process-environment'"
  (push 
   (concat name "="
	   (unix-canonify-path
	    (cadr (split (loop for x in process-environment when (string-match (concat "^" name "=") x) return x) "="))
	    )
	   )
   process-environment 
   )
  )

(defun unix-canonify-path (path)
  " `unix-canonify' elements of w32 style PATH"
  (join (mapcar '(lambda (x) (unix-canonify x 0)) (split  path ";")) ":")
  )


(defun w32-canonify-region (beg end)
  (interactive "r")
  (kill-region beg end)
  (insert (w32-canonify (expand-file-name (car kill-ring))))
  )

(defun w32-canonify-env (name)
  "`w32-canonify-path' on value of environment variable NAME and push result onto `process-environment'"
  (push (concat name "="
		(w32-canonify-path
		 (cadr (split (loop for x in process-environment when (string-match (concat "^" name "=") x) return x) "="))
		 )
		)
	process-environment
	)
  )

(defun w32-canonify-path (path)
  " `w32-canonify' elements of w32 style PATH"
  (join (mapcar '(lambda (x) (w32-canonify x)) (split  path ":")) ";")
  )

(global-set-key "" 'unix-canonify-region)
(global-set-key "" 'w32-canonify-region)

(defun gsn (f) 
  "get short name for f"
  (clean-string (eval-process "gsn" f))
  )

(defvar explore-hooks nil "hooks to run after exploring a directory")

; (add-hook 'explore-hooks 'lower-frame)

(defun explore (&optional f)  
  "w32 explore file
" 
  (interactive   
   (list (read-file-name* "explore (%s): " (thing-at-point (quote filename)))))

  (let ((d   (replace-regexp-in-string "\\\\" "\\\\\\\\" (w32-canonify (or f default-directory)))))
    (shell-command (format "explorer %s" d))
    (run-hooks 'explore-hooks)
    )
  )


(defun arun (f) (interactive "sCommand: "))
(fset 'run 'arun)

; (aexec-handler "jar")

(defun aexec-handler (ext)
  "helper function to find a handler for ext, if any"
  (and ext 
       (assoc (downcase ext) file-assoc-list)
       )
  )

(defvar *aexec-process-abnormal-exit-debug* nil "when set, invoke debugger if aexec process exits abnormally")

(defun aexec-sentinel (p s)
  "sentinel called from when processes created by `aexec-start-process' change state
if the new state is 'finished', deletes the associated buffer
"

  (cond ((or (string= (chomp s) "finished") (not  *aexec-process-abnormal-exit-debug*))
	 (let ((b (process-buffer p)))
	   (if (buffer-live-p b)
	       (kill-buffer b))
	   ))
	((string-match "^exited abnormally" (chomp s))
	 (let ((aexec-process-parameters (get 'aexec-process-sentinel 'parameters)))
	 (debug)))
	(t  (debug))
	)
  )

(defun aexec-start-process (cmd f)
  "create process running COMMAND on input FILE
name is generated from basename of command
process is given an output buffer matching its name and a sentinel `aexec-sentinel'
"

  (unless (and (string* (trim cmd)) (string* (trim f)))
    (debug)
    )

  (let* ((name (symbol-name (gensym (downcase (basename cmd)))))
	 (buffer-name (generate-new-buffer-name name))
	 p)
    (setq p (start-process name buffer-name cmd (w32-canonify f)))
    (put 'aexec-process-sentinel 'parameters (list name buffer-name cmd f))
    (set-process-sentinel p 'aexec-sentinel)		 
    )
  )

(defun aexec (f &optional visit)
  "apply command associated with filetype to specified FILE
filename may have spaces in it, so double-quote it.
handlers may be found from the variable `file-assoc-list' or 
failing that, via `file-association' 
if optional VISIT is non-nil and no file association can be found just visit file, otherwise
 display a message  "
  (interactive "sFile: ")
  (let* ((ext (file-name-extension f))
	 (default-directory (or (file-name-directory f) default-directory))
	 (handler 
	  (or     
	   (aexec-handler ext)
	   (progn
	     (condition-case x
		 (require (intern (format "%s-view" ext)))
	       (file-error nil))
	     (aexec-handler ext)
	     ))))
    (if handler (funcall (cdr handler) f)
      (let ((cmd (file-association f)))
	(cond
	 (cmd
	  (aexec-start-process cmd f))
	 (visit (find-file f))
	 (t (progn
	      (message
	       "no handler for type %s ... " 
	       (file-name-extension f))
	      (sit-for 0 500)

	      (let ((doit (y-or-n-q-p "explore %s [ynqv ]? " " v" f)))
		(cond
		 ((or (eq doit ?y) (eq doit ? ))
		  (explore f))
		 ((eq doit ?v)
		  (message "visiting file %s ..." f)
		  (sit-for 0 800)
		  (find-file f)))
		)
	      (message ""))
	    )
	 )
	)
      )
    )
  )

(defvar last-dosexec "")
(defun dosexec (cmd) 
  "run as a dos parented program"
  (interactive (list (read-string (format "scommand (%s): " last-dosexec))))
  (let ((f (if (eq major-mode (quote dired-mode))
	       (dired-get-filename)
	     (read-file-name "input file: ")))
	(cmd (if 
		 (and (<= (length cmd) 0)
		      (> (length last-dosexec) 0))
		 last-dosexec cmd)))
    (setq last-dosexec cmd)
    (start-process (format "dosexec %s" cmd) nil "cmd" "/c" cmd f))
  )

(defvar *pf* "/program files" "location of windows style program files")
(defvar *ulb* "/usr/local/lib" "location of unix style installed programs")

(defun find-file-in-dir (dir)
  (expand-file-name
   (concat dir "/"
	   (completing-read "dir: " (mapcar 'list (get-directory-files dir)) nil t)
	   ))
  )

(defun pf  (dir)
  "dired in `*pf*'"
  (interactive (list 
		(find-file-in-dir *pf*)))
  (dired dir)
  )

(defun ulb  (dir)
  "dired in `*ulb*'"
  (interactive (list 
		(find-file-in-dir *ulb*)))
  (dired dir)
  )

(defun md-get-arg (&optional arg)
  "."
  )

(defun md (&optional arg) 
  (interactive "P") 
  (explore (md-get-arg arg))
  )


(defun set-cmd-prompt-regexp () (interactive)
  (setq comint-prompt-regexp "^[a-zA-Z]:.*>")
  )

(define-derived-mode cmd-mode shell-mode "Cmd"
  "trivial derivation of shell-mode"
  (make-variable-buffer-local 'comint-prompt-regexp)
  (setq comint-prompt-regexp "^[a-zA-Z]:[^>]*>")
  )

(unless (fboundp 'read-directory-name)
  (defun read-directory-name (&optional prompt)
    (let ((f (read-file-name prompt)))
      (or (-d f) (file-name-directory f) default-directory)
      )
    )
  )
; (read-directory-name (format "run cmd in dir (%s): " default-directory))

(defun distinct-shell-buffers ()
  "return a list of the number associated with existing shell buffers"
  (loop for x in 
	(nconc (collect-buffers-mode  'cmd-mode) (collect-buffers-mode  'shell-mode))
	collect (save-excursion (set-buffer x)
				(or (let ((thing (caddr (split (buffer-name) "[-\*]"))))
				      (and (string* thing) (car (read-from-string thing)))) 0)))
  )
; (1+ (apply 'max (or (distinct-shell-buffers) 0)))

(defvar *cmd* (expand-file-name (substitute-in-file-name "$SYSTEMROOT/system32/cmd.exe")))

(defun cmd (&optional num)
  (interactive "p")
  ; (= num 4) is magic, becuase its the prefix
  ; read a dir name and pick a guaranteed unused buffer number
  (let ((default-directory (string* 
			    (cond ((= num 4) 
				   (setq num (1+ (apply 'max (or (distinct-shell-buffers) 0))))
				   (read-directory-name (format "run cmd in dir (%s): " default-directory))
				   )
				  )
			    default-directory)
	  ))
    (shell2 (or num -1) nil *cmd* 'cmd-mode)
    )
  )

(global-set-key (vector -8388595) 'cmd)

(global-set-key (vector 'f9) 'undo)

(global-set-key (vector 'f12) 'md)
(global-set-key (vector 'f11) 'explore)
(global-set-key (vector 'f4) 'arun)
(global-set-key (vector 'f5) 'aexec)
(global-set-key (vector 'f6) 'dosexec)


;; XXX this fixes the bug in dired
;; protect against bad args.  this seems to be preloaded, so...
;; maybe advice would work better
(defun ls-lisp-time-lessp (TIME0 TIME1)
  (condition-case badarg
      (cond ((= (car TIME0) (car TIME1)) (< (cadr TIME0) (cadr TIME1)))
	    ((< (car TIME0) (car TIME1)) t)
	    (t nil))
    ('wrong-type-argument nil)
    )
  )

(defun w32-canonify-environment-variable (f)
  "convert unix style env var to dos style."
  (while (string-match "\$[a-zA-Z0-9_]+" f)
      (format "%%%s%%" (substring f (1+ (match-beginning 0)) (match-end 0)))
    )
  )

(defun yank-dos-environment-variable (begin &optional end)
  "this function translates the region between BEGIN and END using `w32-canonify-environment-variable' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region
"
  (interactive "r")

  (let ((txt (w32-canonify-environment-variable (string* begin (buffer-substring begin end)))))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(global-set-key "e" 'yank-dos-environment-variable)

(defun cut-dos-filename (begin &optional end)
  "this function translates the region between BEGIN and END using `w32-canonify' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region
"
  (interactive "r")

  (let ((txt (w32-canonify (string* begin (buffer-substring begin end)))))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(defun cut-unix-filename (begin &optional end)
  "this function translates the region between BEGIN and END using `unix-canonify' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region"
  (interactive "r")
  (let* ((txt
	  (unix-canonify (string* begin (buffer-substring begin end)) 0)))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(global-set-key "w" 'cut-dos-filename) ; mnemonic: Windows
(global-set-key "u" 'cut-unix-filename) ; mnemonic: Unix

(defun yank-unix-filename ()
  "unix canonify the `current-kill' and paste it"
  (interactive)
  (insert (unix-canonify (current-kill 0) 0))
  )
(global-set-key "y" 'yank-unix-filename) ; mnemonic: Unix

(defun yank-unix-filename (begin &optional end)
  "this function translates the region between BEGIN and END using `unix-canonify' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region"
  (interactive "r")
  (let* ((txt
	  (unix-canonify (string* begin (buffer-substring begin end)) 0)))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(defun yank-pwd (arg)
  ""
  (interactive "P")

  (let* ((txt (if arg default-directory (w32-canonify default-directory))))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(global-set-key "p" 'yank-pwd)

(defun dired-kill-filename ()
  "yank expanded filename under point"
  (interactive)
  (kill-new (canonify (dired-get-filename) 0))
  )

(add-hook 'dired-mode-hook '(lambda () 
			      (define-key dired-mode-map "" 'dired-kill-filename)
			      (define-key dired-mode-map "S" 'dired-w32-shortcut)))
(add-hook 'buffer-menu-mode-hook '(lambda () 
				    (define-key Buffer-menu-mode-map "" 'dired-kill-filename)))



(setq w3-load-hooks '(lambda () 
		       (load-library "w3-helpers") 
		       (load-library "url-helpers")
		       ))

(defvar catalogs '("c:/tmp/f")) ;  "d:/f"

(add-hook 'dired-load-hook
	  '(lambda () 
	     (define-key dired-mode-map "R" 'dired-move-marked-files)
	     (define-key dired-mode-map "C" 'dired-copy-marked-files))
	  )

(defun mktemp (pat)
  "make a temporary filename based on tmpdir"
  (expand-file-name (format "%s/%s" (getenv "TMP") pat))
  )

; really only want this for shell programs.
(setq null-device "/dev/null")

(defvar grep-null-device "nul")

(add-hook 
 'people-load-hook 
 '(lambda ()
    (require 'advice)
  ; some goofy advice to handle lists of filenames that may have spaces in them
    (defadvice contact-cachep (after hanger activate)
      (setq ad-return-value 
	    (loop for x in ad-return-value collect 
		  (if (string-match " " x) (concat "\"" x "\"") x))))
    )
 )

(add-hook 'make-frame-hook 
	  '(lambda () 
	     (modify-frame-parameters
	      nil
	      '((left . 140) (top . 80) (height . 30) (width . 72)))))
; (pop make-frame-hook)

; may want to check out file-name-buffer-file-type-alist

(setq file-name-buffer-file-type-alist nil)
(standard-display-8bit 129 255)
; (setq-default buffer-file-coding-system 'undecided-unix)
(setq-default buffer-file-coding-system nil)
; (setq coding-system-for-write 'no-conversion)
(setq coding-system-for-write nil)

; todo: (alldrives) returns enumeration of drives in use

(defun vp (&optional user)
  "visit profile directory for USER.  default is current user"
  (interactive)
  (dired  (expand-file-name
	   (concat *systemroot* "/profiles/" (or user *username*) "/Personal/" nil)))

  )

(/*
 (defun browse-path (arg) 
   "pringle path in a browser buffer"
   (interactive "P")
   (let ((temp-buffer-show-function '(lambda (buf)
				       (switch-to-buffer buf)
				       (fb-mode)))
	 (l (if arg 
		(eval (read-variable "path var: "))
	      (catpath "PATH" (if (eq window-system 'win32) semicolon)))))

     (with-output-to-temp-buffer "*Path*"
       (mapcar '(lambda (x) (princ (expand-file-name x)) (princ "\n")) l)
       )
     )
   )
 )

(defun control-panel (c) 
  "run control panel applets"
  (interactive
   (list
    (completing-read
     "?" 
     (mapcar
      '(lambda (x)
	 (list
	  (file-name-sans-extension x)))
      (directory-files (expand-file-name (concat *systemroot* "/system32")) nil "cpl$")
      )
     )))

  (let ((p (get-process "cpl")))
    (and p (kill-process p))
    (start-process "cpl" nil "control" (concat c ".cpl")
		   )
    )
  )


(defun w32-mangle-filename (f)
  "enquote spaces in string filename"
  (enquote-string f)
  )

; (w32-mangle-filename "d:/Program Files/Microsoft Visual Studio/VC98/Bin")

(defun swf (fn)
  "find files relative to systemroot"
  (interactive "sFilename: ")
  (let ((f (car (split (perl-command "swf" fn) "
"))))
    (if f 
	(find-file f)
      (message "%s not found" f))
    )
  )

(defun net (cmd) 
  "implement net command"
  (interactive "scmd: ")

  (let ((b (zap-buffer "*net*")))
    (set-buffer b)
    (insert-eval-process
     (cond
      ((string-equal cmd "use")
       (let* ((host (read-string "host: " )))
	 (cond ((string* host)
		(let* ((user (read-string (format "username for %s: " host)))
		       (sword (comint-read-noecho "password: " )))
		  (format "net use \\\\%s %s /user:%s"
			  host sword user)))
	       (t "net use"))))
      (t
       (format "net %s" cmd))
      )
     )
    (pop-to-buffer b)
    (view-mode)
    (beginning-of-buffer)
    )
  )

(defun host (n) 
  "report host/ip windows style"
  (interactive "sname: ")

  (message (clean-string (perl-command "host" n)))
  )

(defvar *mesagebox-default-flags* "MB_OK|MB_ICONINFORMATION|MB_SETFOREGROUND")

(defun messagebox (msg &optional title flags)
  "put up a messagebox"
  (interactive "smessage: ")
  (let ((l (list msg)))
    (if (string* title)
	(setq l (nconc (list "-t" title) l)))
    (setq l (nconc (list "-f" (string* flags *mesagebox-default-flags*)) l))
    (setq l (cons "messagebox" l))

    (message (clean-string (apply 'perl-command l)))
    )
  )

; (messagebox "every good boy does fine" "r u there?" "MB_OKCANCEL|MB_ICONINFORMATION|MB_SETFOREGROUND")

(defun msvc-setting ()
  (interactive)
  (let ((p (point)))
    (goto-char (point-min))
    (replace-string "," "
")
    (goto-char (point-min))
    (local-set-key "" '(lambda () (interactive) (throw 'exit nil)))
    (recursive-edit)
    (goto-char (point-min))
    (replace-string "
" ",")
    (goto-char p)
    )
  )

(require 'long-comment)
(/*
(mapcar 'makunbound '(
		      *systemroot*
		      *systemdrive*
		      *username*
		      default-fontspec-format
		      default-family-table
		      default-font-family
		      default-point-size
		      default-style
		      default-weight
		      default-fontspec
		      explore-hooks
		      last-dosexec
		      catalogs
		      print-processes
		      grep-null-device
		      w32-documents
		      my-documents
		      start-menu
		      w32
		      *mesagebox-default-flags*
		      ))
)

;; from os-init

(setq doc-directory data-directory)

;; config file for gnuwin-1.0
(autoload 'shell2 "shell2" t)

(make-variable-buffer-local 'explicit-shell-file-name)
(make-variable-buffer-local 'shell-command-switch)
(make-variable-buffer-local 'binary-process-input)
(set-default 'shell-command-switch "-c")
(set-default 'binary-process-input t)
(set-default 'explicit-shell-file-name "bash")

; this treats all files on z:\\foo as binary
;(add-untranslated-filesystem "Z:")

;this undoes that
; remove-untranslated-filesystem

; work-around annoyingly long timeouts

(defvar *short-timeout* 200 "time to wait for network drive to respond, in ms")

(defun host-exists (host &optional timeout)
  "returns t if HOST responds to a ping within optional TIMEOUT.
TIMEOUT may be an integer or a string representation of an integer.
 (default is `*short-timeout*`)"

  (let* ((stimeout (string* timeout
			    (format "%s" 
				    (if (integerp timeout) timeout
				      *short-timeout*))))
	 (ps
	  (eval-process 
	   (expand-file-name
	    (format "%s/system32/ping.exe" 
		    (getenv "systemroot")))
	   "-w" stimeout "-n" "1" host)))

    (not (or (loop for x in 
		   '(
		     "Ping request could not find host"
		     "Request timed out"
		     "Destination host unreachable" 
		     "Unknown host")
		   thereis (string-match x ps))))
    )
  )

; e.g.
; (host-exists "simon") ; t if deadite is up
; (host-exists "10.132.10.1") ; nil
; (host-exists "deadite" 2)

(defvar host-ok-hook nil "list of functions to run before checking `host-ok'  
 file is bound to variable `filename'
 if any hookfn returns non-nil host-ok checking passes immediately")

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"

  (unless (run-hooks 'host-ok-hook)

    (let ((host (and (> (length filename) 1)
		     (string-match "//\\([a-zA-Z0-9\.]+\\)" filename)
		     (= (match-beginning 0) 0)
		     (substring filename (match-beginning 1) (match-end 1) ))))
      (or (not host)
	  (host-exists host timeout)
	  (and (not noerror)
	       (signal 'file-error (list "host not found" host))))
      )
    )
  )

;; (host-ok "//simon/e")
;; (host-ok "//fields/Volume_1/backup" 1)
;; (host-ok "//deadite/C" t)
;; (host-ok "c:/")

;; build a list of ((<regexp> <mountpoint>) ...)
;; later used for autosubstitution


(defmacro expand-pseudo-mount-p (n)
  " given a file or directory at arg position n, expand contained pseudo-mounts, if any"
  
  )

(setq mount-hook-file-commands '(cd dired find-file-noselect file-exists-p w32-canonify read-file))

(defun mount-unhook-file-commands ()
  (loop for x in mount-hook-file-commands do
	(eval `(if (ad-is-advised (quote ,x)) (ad-unadvise (quote ,x))))))
; (mount-unhook-file-commands)

(defvar *absolute-filepath-pattern* "^\\([/]+\\|~\\|[a-zA-`]:\\)" 
  "pattern matching an absolute file path")
(defun absolute-path (f) (and (string-match *absolute-filepath-pattern* f) f))

; if expand-file-name is advised, be sure to use original definition
(fset 'mount-orig-expand-file-name
      (if (ad-is-advised 'expand-file-name) (symbol-function 'ad-Orig-expand-file-name)
	(symbol-function 'expand-file-name)))

(defun check-unc-path (f)
  " dwim with short timeout if caller set a unc path unintentionally "
  ; assert absolute-path was just called
  ; (string= (substring f (match-beginning 0) (match-end 0)) "//")
  (let* ((top (and
	       (string-match "^//\\([^/]+\\)\\(.*\\)" f)
	       (substring f (match-beginning 1) (match-end 1))
	       ))
	 )
    (cond ((and top (or
		     (not (host-exists top 65))
  ; warn if local dir also exists
		     (and (file-directory-p (concat "/" top))  
			  (progn 
  ; (debug)
			    (y-or-n-p (format "did you mean local directory %s? " (concat "/" top)))))))
  ; trim off extra leading slash
	   (substring f 1))
	  (t f))
    )
  )



; xxx todo: catch shell command w <world> for shell-cd

;; (defadvice abbreviate-file-name (around 
;; 				 hook-abbreviate-file-name
;; 				 first activate)
;;   "is a noop on this platform"
;; 
;;   (let ((ad-return-value (ad-get-arg 0))) ad-return-value)
;;   )
;; 
;; ; (ad-is-advised 'abbreviate-file-name)
;; ; (ad-unadvise 'abbreviate-file-name)
;; 

(require 'perl-command)
(provide 'unicode) ; adds a hook to hammer unicode files

; make sure post-man gets loaded the first time man is called.
(global-set-key "\C-h\C-m" '(lambda () (interactive) (load-library "post-man") (global-set-key "\C-h\C-m" 'man) (call-interactively 'man)))

;; this works, but breaks host-ok...


(defadvice w32-drag-n-drop (around 
			    hook-w32-drag-n-drop
			    first activate)
  ""

  ; apply file association, if exist
  (let* ((ev (ad-get-arg 0))
	 (f (caar (cddr ev))))
    (if (file-association-1 f)
	(progn 
	  (aexec f)
	  (raise-frame))

  ; otherwise, just do it.
      ad-do-it
      )
    )
  )
; (if (ad-is-advised 'w32-drag-n-drop) (ad-unadvise 'w32-drag-n-drop))

(defun whence-p (f)
  (and (file-exists-p f) (expand-file-name f))
  )


;; probably redundant with lnk-view

(defun w32-shortcut (f)
  "returns an alist of the attributes of the w32 shortcut f
keys for the alist include:
    \"LinkName\"
    \"Arguments\"
    \"Target\"
    \"Working Directory\"
    \"Icon File\"
    \"Icon Index\"
"
  (loop for x in 
	(split
	 (eval-process "shortcut" "-u" "all" f) "
")
	collect (split x ": "))
  )

(defun dired-w32-shortcut ()
  (interactive)
  (let* ((l (w32-shortcut (dired-get-filename)))
	 (f (cadr (assoc "Target" l))))
    (cond
     ((not (file-exists-p f)) (message (format "target %s not found" f)))
     ((file-directory-p f) (dired f))
     (t (find-file f))
     )
    )
  )

;; this be broken:
;; (assoc* "Icon File"
;;	 (w32-shortcut
;;	  (w32-canonify (concat  user-profile "/Desktop" "/"  "rainier.lnk")))
;;	 :test 'string=
;;	 )
;;

; is windows standard for undo...

(global-set-key "\C-z" 'undo)

(defun member-ignore-case (cl-item cl-list)
  (member* cl-item cl-list :test '(lambda (x y) (string= (downcase x) (downcase y))))
  ) 

;; ignore case when determining whether a filename is a member of a list
(setq *file-name-member* 'member-ignore-case)

(defun toggle-coding-system () (interactive)
  (cond ((eq buffer-file-coding-system 'undecided-unix)
	 (set-buffer-file-coding-system 'undecided-dos))
	((eq buffer-file-coding-system 'undecided-dos)
	 (set-buffer-file-coding-system 'undecided-unix))
	)
  ;       (t (or (read-coding-system (format "(%s): " buffer-file-coding-system)) buffer-file-coding-system))
  (find-file-force-refresh)
  )

(provide 'w32)

(add-file-association "key" '(lambda (f) (interactive) (let ((key (comint-read-noecho "key: " t))) (decrypt-find-file f key))))
(add-file-association "htm" 'html-view)
(add-file-association "html" 'html-view)
