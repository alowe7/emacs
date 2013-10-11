(put 'os-init 'rcsid 
 "$Id$")

(chain-parent-file t)

(require 'cat-utils)
(require 'file-association)
(require 'long-comment)
(require 'canonify)
(require 'locations)

(load "frames" t t)

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

  (let* (
	 (d   (replace-regexp-in-string "\\\\" "\\\\\\\\" (w32-canonify (or f default-directory))))
	 (d2   (replace-regexp-in-string "\(" "\\\\("  d))
	 (d3   (replace-regexp-in-string "\)" "\\\\)"  d2)))
    (shell-command (format "explorer %s" d3))
    (run-hooks 'explore-hooks)
    )
  )

(defun md ()
  (interactive)
  (explore default-directory)
  )

(make-variable-buffer-local 'comint-prompt-regexp)

(defun set-cmd-prompt-regexp () (interactive)
  (setq comint-prompt-regexp "^[a-zA-Z]:.*>")
  )

(define-derived-mode cmd-mode shell-mode "Cmd"
  "trivial derivation of shell-mode"
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
	collect (with-current-buffer x
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
	  )
	(process-environment (substitute 
			      (concat "PATH=" (w32-canonify-path (getenv "PATH") (getenv "SYSTEMDRIVE")))
			      "PATH="
			      process-environment
			      :test (lambda (x y)  (equal 0 (string-match x y)))
			      )))
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
    (when (string* txt)
      (kill-new txt)
      (if interprogram-cut-function
	  (funcall interprogram-cut-function txt))
      )
    txt)
  )

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
	(funcall interprogram-cut-function txt))
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

(defun kill-unix-filename (begin &optional end)
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

(add-hook 'dired-mode-hook (lambda () 
			      (define-key dired-mode-map "" 'dired-kill-filename)
			      (define-key dired-mode-map "S" 'dired-w32-shortcut)))
(add-hook 'buffer-menu-mode-hook (lambda () 
				    (define-key Buffer-menu-mode-map "" 'dired-kill-filename)))



(setq w3-load-hooks (lambda () 
		       (load-library "w3-helpers") 
		       (load-library "url-helpers")
		       ))

(add-hook 'dired-load-hook
	  (lambda () 
	     (define-key dired-mode-map "R" 'dired-move-marked-files)
	     (define-key dired-mode-map "C" 'dired-copy-marked-files)
  ; override default dired drag drop behavior to open dropped files, not copy them
	     (setq dired-dnd-protocol-alist dnd-protocol-alist)
	     )
	  )

; really only want this for shell programs.
(setq null-device "/dev/null")

(defvar grep-null-device "nul")

(add-hook 
 'people-load-hook 
 (lambda ()
    (require 'advice)
  ; some goofy advice to handle lists of filenames that may have spaces in them
    (defadvice contact-cachep (after hanger activate)
      (setq ad-return-value 
	    (loop for x in ad-return-value collect 
		  (if (string-match " " x) (concat "\"" x "\"") x))))
    )
 )

(add-hook 'make-frame-hook 
	  (lambda () 
	     (modify-frame-parameters
	      nil
	      '((left . 140) (top . 80) (height . 30) (width . 72)))))
; (pop make-frame-hook)

; may want to check out file-name-buffer-file-type-alist

(setq file-name-buffer-file-type-alist nil)
(standard-display-8bit 129 255)

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
    (goto-char (point-min))
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
  (while (search-forward "," nil t)
    (replace-match "
" nil t))
    (goto-char (point-min))
    (local-set-key "" (lambda () (interactive) (throw 'exit nil)))
    (recursive-edit)
    (goto-char (point-min))
  (while (search-forward "
" nil t)
    (replace-match "," nil t))
    (goto-char p)
    )
  )

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
; t if host notthere responds to a ping in less than 200ms
; (assert (null (host-exists "notthere" 200)))
; (assert (null (host-exists "10.132.10.1"))) ; nil
; (assert (null (host-exists "deadite" 2)))
; (assert (host-exists "localhost"))
; (assert (host-exists (hostname)))


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
;; (host-exists "simon")
;; (host-ok "//fields/Volume_1/backup" 1)
;; (host-ok "//deadite/C" t 100)
;; (host-ok "c:/")

;; build a list of ((<regexp> <mountpoint>) ...)
;; later used for autosubstitution


(defmacro expand-pseudo-mount-p (n)
  " given a file or directory at arg position n, expand contained pseudo-mounts, if any"
  
  )

(setq mount-hook-file-commands '(cd dired find-file-noselect file-exists-p w32-canonify read-file))

(defun mount-hook-file-commands ()
  (mount-unhook-file-commands)
  (loop for x in mount-hook-file-commands do
	(let ((hook-name (intern (concat "hook-" (symbol-name x)))))
	  (eval `(defadvice ,x (around ,hook-name first activate) 
		   (ad-set-arg 0 (mount-hook (ad-get-arg 0)))
		   ad-do-it
		   )
		)
	  )
	)
  )
; (mount-hook-file-commands)

(defun mount-unhook-file-commands ()
  (loop for x in mount-hook-file-commands do
	(eval `(if (ad-is-advised (quote ,x)) (ad-unadvise (quote ,x))))))
; (mount-unhook-file-commands)

(defvar *absolute-filepath-pattern* "^\\([/]+\\|~\\|[a-zA-`]:\\)" 
  "pattern matching an absolute file path")
(defun absolute-path (f) (and (string-match *absolute-filepath-pattern* f) f))

; if expand-file-name is advised, be sure to use original definition
(fset 'mount-orig-expand-file-name
      (eval `(if (ad-is-advised 'expand-file-name) (symbol-function 'ad-Orig-expand-file-name)
	       (symbol-function 'expand-file-name))))

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
(global-set-key "\C-h\C-m" (lambda () (interactive) (load-library "post-man") (global-set-key "\C-h\C-m" 'man) (call-interactively 'man)))

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
  (member* cl-item cl-list :test (lambda (x y) (string= (downcase x) (downcase y))))
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

(add-file-association "key" (lambda (f) (interactive) (let ((key (comint-read-noecho "key: " t))) (decrypt-find-file f key))))
(add-file-association "htm" 'html-view)
(add-file-association "html" 'html-view)

(/*
 (condition-case whatever
     (require 'regtool)
   (let ((key  "/HKCU/SOFTWARE/Microsoft/Internet Explorer/Main/")
	 (val "about:blank")) 
     (dolist (x '("Start Page" "Default_Page_URL") )  (regtool "set" (concat key x) val))
     )
  ;   (regtool "get" "/HKCU/SOFTWARE/Microsoft/Internet Explorer/Main/Start Page")

   (require 'cygwin)
  ;  (add-hook 'find-file-not-found-functions 'cygwin-file-not-found)
  ;  (remove-hook 'find-file-not-found-functions 'cygwin-file-not-found)
   (error (debug))
   )
 */)


