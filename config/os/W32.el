; -*-emacs-lisp-*-

(put 'W32 'rcsid 
 "$Id: W32.el,v 1.23 2003-12-15 22:46:30 cvs Exp $")

(require 'cat-utils)
(require 'file-association)

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


;; (global-set-key "\C-:" (quote indent-for-comment))
(global-set-key (vector 'C-backspace) 'iconify-frame)

;; jean-luc fonty

(defvar default-fontspec-format  "-*-%s-%s-r-*-*-%s-%s-*-*-*-*-*-*-")
(defvar  default-family-table 
	(mapcar 'list (list "Roman" "MS LineDraw" "Lucida Console" "fixed" "courier")))
(defvar default-font-family "lucida console")
(defvar default-point-size 17)
(defvar default-style "normal")
(defvar default-weight "*")
(defvar default-fontspec nil)

(defun default-font (&optional font-family style point-size weight)
  (interactive (list
		(completing-read "Family: " default-family-table)
		(read-string "Style: ")
		(read-string "Point-size: ")
		(read-string "Weight: ")))

  (and (stringp point-size) 
       (> (length point-size) 0)
       (setq point-size (read point-size)))

  (cond ((eq point-size '*)
	 (setq default-point-size nil))
	((integerp point-size) 
	 (setq default-point-size point-size)))

  (and (stringp style)
       (> (length style) 0)
       (setq default-style style))

  (and (stringp weight)
       (> (length weight) 0)
       (setq weight (read weight)))

  (cond ((eq weight '*)
	 (setq default-weight nil))
	((integerp weight)
	 (setq default-weight weight)))

  (and font-family (setq default-font-family font-family))
	
  (set-default-font (setq default-fontspec
			  (format default-fontspec-format   
				  font-family 
				  default-style
				  default-point-size
				  default-weight)))
  default-fontspec
  )

;(default-font nil "*" "100")

(defun font-1 (arg) (interactive "p")
  (default-font default-font-family default-style (- default-point-size (or arg 1)) nil)
  (if (interactive-p) (message default-fontspec))
  )

(defun font+1 (arg) (interactive "p")
  (default-font default-font-family default-style (+ default-point-size (or arg 1)) nil)
  (if (interactive-p) (message default-fontspec))
  )

(global-set-key "]" 'font+1)
(global-set-key "[" 'font-1)


(defun w32-canonify (f &optional sysdrive)
  " expands FILENAME, using backslashes
optional DRIVE says which drive to use. "
  (replace-in-string  "/" "\\" 
		      (if sysdrive (expand-file-name 
				    (substitute-in-file-name
				     (chomp f ?/))
				    (and (string* sysdrive) (concat sysdrive "/")))
			(substitute-in-file-name
			 (chomp f ?/))
			)
		      )
  )

(defun unix-canonify (f &optional mixed)
  " expands FILENAME, using forward slashes.
optional second arg MIXED says do not translate 
letter drive names.
if MIXED is 0, then ignore letter drive names.
"
  (let ((f (expand-file-name f)))
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

(defalias 'canonify 'unix-canonify)

(defun unix-canonify-region (beg end)
  (interactive "r")
  (kill-region beg end)
  (insert (unix-canonify (expand-file-name (car kill-ring))))
  )

(defun split-path (path)
  (split (unix-canonify-path path) ":")
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

(defun explore (&optional f)  
  (interactive "P")
  (shell-command (format "explorer %s" (w32-canonify (or f default-directory))))
  (run-hooks 'explore-hooks)
)


(defun arun (f) (interactive "sCommand: ")
  (start-process f nil f ))
;; this depends on the query.bat being on your path

; (aexec-handler "jar")

(defun aexec-handler (ext)
  "helper function to find a handler for ext, if any"
  (and ext 
       (assoc (downcase ext) file-assoc-list)
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
	(handler (aexec-handler ext)))
    (if handler (funcall (cdr handler) f)
      (let ((cmd (file-association f)))
	(cond (cmd 
	       (start-process f nil "cmd" "/c" cmd (format "\"%s\"" f)))
	      (visit (find-file f))
	      (t (progn
		   (message
		    "no handler for type %s ... " 
		    (file-name-extension f))
		   (sit-for 0 500)
		   (message "visiting file %s ..." f)
		   (sit-for 0 800)
		   (find-file f)
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


(defun md (&optional arg) (interactive "P") 
  (explore  (if arg 
		(read-file-name "Directory to browse: " (pwd) nil t)))
  )

(defun explore-file (f) (interactive "ffile: ")
  (shell-command (format "explorer %s" (file-name-nondirectory f)))
  (lower-frame)
  )

(defun set-cmd-prompt-regexp () (interactive)
  (setq comint-prompt-regexp "^[a-zA-Z]:.*>")
  )

(define-derived-mode cmd-mode shell-mode "Cmd"
  "trivial derivation of shell-mode"
  (make-variable-buffer-local 'comint-prompt-regexp)
  (setq comint-prompt-regexp "^[a-zA-Z]:[^>]*>")
  )

(defun cmd (&optional num)
  (interactive "p")
  (shell2 (or num -1) nil "cmd" 'cmd-mode)
  )

(global-set-key (vector -8388595) 'cmd)

(global-set-key (vector 'f9) '(lambda () (interactive) (switch-to-buffer (symbol-name (gensym "tmp")))))
(global-set-key (vector 'f10) 'ewn)
(global-set-key (vector 'f11) 'ewd)
(global-set-key (vector 'f12) 'md)
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

(defun yank-dos-filename (begin &optional end)
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

(defun dired-yank-dos-filename ()
  "this function translates the region between BEGIN and END using `w32-canonify' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region
"
  (interactive)
  (condition-case x
      (let ((txt (w32-canonify (dired-get-filename))))
	(kill-new txt)
	(if interprogram-cut-function
	    (funcall interprogram-cut-function txt t))
	txt)
    (error (call-interactively 'yank-dos-filename)))
  )
(add-hook 'dired-mode-hook '(lambda () (define-key dired-mode-map "\C-cw" 'dired-yank-dos-filename)))

(defun yank-unix-filename (begin end)
  "this function translates the region between BEGIN and END using `unix-canonify' and copies the result into the kill-ring.
if `interprogram-cut-function' is defined, it is invoked with the canonified result.
when called from a program, if BEGIN is a string, then use it as the kill text instead of the region"
  (interactive "r")
  (let* ((txt
	  (unix-canonify (string* begin (buffer-substring begin end)))))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(global-set-key "w" 'yank-dos-filename)
(global-set-key "y" 'yank-unix-filename)

(defun yank-pwd (arg)
  ""
  (interactive "P")

  (let* ((txt (if arg default-directory (w32-canonify default-directory))))
    (kill-new txt)
    (if interprogram-cut-function
	(funcall interprogram-cut-function txt t))
    txt))

(global-set-key "p" 'yank-pwd)

(defun dired-cut-filename ()
  "yank expanded filename under point"
  (interactive)
  (yank-dos-filename (dired-get-filename))
  )

(add-hook 'dired-mode-hook '(lambda () 
			      (define-key dired-mode-map "" 'dired-cut-filename)))
(add-hook 'buffer-menu-mode-hook '(lambda () 
				    (define-key Buffer-menu-mode-map "" 'dired-cut-filename)))


(defun hard-fill  (from to)
  (interactive "r")
  (goto-char from)
  (while (search-forward  "
" nil t)
    (replace-match  "

" nil t))

  (fill-nonuniform-paragraphs from to nil)
  )

(defun soft-fill-region (from to)
  (interactive (list (region-beginning) (region-end)))
  (call-interactively 'trim-white-space)
  (let ((a (min from to)) (b (max from to)))
    (dolist (x '(
		 ("

" "|")
		 ("
" " ")
		 ("|" "

")))
      (goto-char a)
      (while (search-forward (car x) b t)
	(replace-match (cadr x) t))
      )
    ))

(global-set-key "" 'soft-fill-region)

(setq w3-load-hooks '(lambda () 
		       (load-library "w3-helpers") 
		       (load-library "url-helpers")
		       ))

(defvar catalogs '("c:/tmp/f")) ;  "d:/f"

(defun fastfind (pat) 
  "find files matching PATTERN in catalogs"
  (interactive "spattern to find: ")
  (let ((b (zap-buffer "*fastfind*")))
    (dolist (f catalogs)
      (if (file-exists-p f)
	  (progn
	    (insert "***" f "***\n") 
	    (call-process "egrep" f b t "-i" pat)
	    ))
      )
    (pop-to-buffer b)
    (beginning-of-buffer)
    (set-buffer-modified-p nil)
    ))

; ESC-@ initialize printer
; ESC-l left margin
(defconst dos-print-header-format "@l%c")
(defconst dos-print-trailer "@" "special printing characters")

(defvar print-processes nil)
;(pop print-processes)
;(setq c (caar print-processes))
;(cdr (assq c  print-processes))

(defun print-process-sentinel (process msg)
  ;  (read-string (format "gotcha: %s" msg))
  (if (string-match "finished" msg) 
      (let ((a (assq process print-processes)))
	(setq print-processes (remq process print-processes))
	(and (file-exists-p (cdr a)) (delete-file (cdr a)))
  ;				(pop-to-buffer " *PRN*")
	)
    )
  )

(defconst esc-font-format "k%c")
(defconst esc-fonts '(Roman
		      SansSerif
		      Courier
		      Prestige
		      Script))
(defconst esc-proprotional "!")

(defun relt (sequence val)
  "reverse elt: return n of sequence whose value equals val"
  (let ((len (length sequence)))
    (loop with i = 0
	  when (equal (elt sequence i) val) return i
	  when (> i len) return nil
	  do (setq i (1+ i))))
  )


(defun* dos-print-region (from to &key font fixed)

  "print REGION as text.
 with prefix ARG, use that as left margin.
 see dos-print-header for default parameters."

  (interactive "r")

  (let* ((dos-print-header
	  (format dos-print-header-format
		  (or current-prefix-arg 2)))
	 (esc-font (relt esc-fonts font))
	 (s (buffer-substring from to))
	 (b (generate-new-buffer " *print*"))
	 (fn (concat "c:\\tmp\\" (make-temp-name (format "__%s" (gensym)))))
	 p)
    (set-buffer b)
    (insert dos-print-header)
    (and esc-font (insert (format esc-font-format esc-font)))
    (unless fixed (insert esc-proprotional))
    (insert s)
    (insert dos-print-trailer)
    (write-region (point-min) (point-max) fn)
    (kill-buffer b)
  ; use process-sentinel to catch completion
  ;		(call-process "cmd" nil 0 nil "/c" "print" fn)
    (set-process-sentinel 
     (setq p (start-process "prn" (get-buffer-create " *PRN*") "cmd" "/c" "print" fn))
     'print-process-sentinel)
    (push (cons p fn) print-processes)
    )
  )

(defun dos-print-buffer ()
  (interactive)
  (dos-print-region (point-min) (point-max))
  )
 
(defun dos-print (file) 
  (interactive "fFile: ")
  (let* ((ob (find-buffer-visiting file))
	 (b (or ob (find-file-noselect file))))
    (if b
	(save-excursion
	  (set-buffer b)
	  (dos-print-buffer)))
    (or ob (kill-buffer b))))


(add-hook 'dired-load-hook
	  '(lambda () 
	     (define-key dired-mode-map "R" 'dired-move-marked-files)
	     (define-key dired-mode-map "C" 'dired-copy-marked-files))
	  )

(defun mktemp (pat)
  "make a temporary filename based on tmpdir"
  (expand-file-name (format "%s/%s" (getenv "TMP") pat))
  )

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


(defun domainname () 
  (clean-string (reg-query "machine" 
			   "system/currentcontrolset/services/tcpip/parameters" "domain"))
  )

(defvar all-users-profile
  (expand-file-name (substitute-in-file-name "$ALLUSERSPROFILE"))
  "top level dir for all user documents and settings")

(defvar user-profile
  (expand-file-name (substitute-in-file-name "$USERPROFILE"))
  "top level dir for current users documents and settings")

(defvar my-documents
  (expand-file-name (concat user-profile "/My Documents"))
  "top level dir for current users documents and settings")

(defvar start-menu
  (expand-file-name (substitute-in-file-name "$USERPROFILE/Start Menu"))
  "top level dir for current users documents and settings")

(defvar quicklaunch
  (w32-canonify 
   (concat user-profile
	   "\\Application Data\\Microsoft\\Internet Explorer\\Quick Launch"
	   )))

(mapcar '(lambda (x) 
	   (eval (list 'defun x nil '(interactive) (list 'dired x))))
	'(all-users-profile user-profile my-documents start-menu quicklaunch))

(defun w32-mangle-filename (f)
  "reports default-directory as a win32 8.3 file name"
  (clean-string
   (eval-process "gsn" f))
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

(defvar semicolon (read "?;"))
(defvar w32 'w32)

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
		   '("Request timed out"
		     "Destination host unreachable" 
		     "Unknown host")
		   thereis (string-match x ps))))
    )
  )

; e.g.
; (host-exists "simon") ; t if deadite is up
; (host-exists "10.132.10.1") ; nil
; (host-exists "deadite" 2)

(defun host-ok (filename &optional noerror timeout) 
  "FILENAME is a filename or directory
it is ok if it doesn't contain a host name
or if the host exists.
signal file-error unless optional NOERROR is set.
host must respond within optional TIMEOUT msec"


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

;; (host-ok "//simon/e")
;; (host-ok "//deadite/C" t)
;; (host-ok "c:/")

;; build a list of ((<regexp> <mountpoint>) ...)
;; later used for autosubstitution

;; maybe it would be better to comb the registry.
(cond ((string-match "1.3.2" (eval-process "uname" "-r"))

       ;; mount output format for (beta) release 1.3.2
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (split (eval-process "mount") "
")
		     collect 
		     (let ((l (split x " ")))
		       (list (caddr l) (car l))))
	       )
	 )
       )

      (t 
       ;; mount output format for release 1.0
       (defun cygmounts ()
	 " list of cygwin mounts"
	 (setq cygmounts
	       (loop for x in (cdr (split (eval-process "mount") "
"))
		     collect
		     (let
			 ((l (split (replace-in-string "[ ]+" " " x))))
		       (list (cadr l) (car l))))
	       )
	 )
       )
      )

(defmacro expand-pseudo-mount-p (n)
  " given a file or directory at arg position n, expand contained pseudo-mounts, if any"
  
  )

; initialize mount table
(cygmounts)

(setq mount-hook-file-commands '(cd dired find-file-noselect file-exists-p w32-canonify read-file))

(defun mount-unhook-file-commands ()
  (loop for x in mount-hook-file-commands do
	(eval `(if (ad-is-advised (quote ,x)) (ad-unadvise (quote ,x))))))
; (mount-unhook-file-commands)

(defvar *absolute-filepath-pattern* "^//\\|^~\\|^[a-zA-`]:" 
  "pattern matching an absolute file path")
(defun absolute-path (f) (and (string-match *absolute-filepath-pattern* f) f))

; if expand-file-name is advised, be sure to use original definition
(fset 'mount-orig-expand-file-name
      (if (ad-is-advised 'expand-file-name) (symbol-function 'ad-Orig-expand-file-name)
	(symbol-function 'expand-file-name)))

(defun mount-hook (f)
  "apply mounts to FILE if applicable"
  (or (absolute-path f)
      (let ((e (if (absolute-path default-directory)
		   (concat (cadr (assoc "/" cygmounts)) f)
		 (loop for y in cygmounts
		       if (or
			   (string-match (concat "^" (car y) "/") f)
			   (string-match (concat "^" (car y) "$") f))
		       return (replace-in-string (concat "^" (car y)) (cadr y) f)
		       ))))
	(and e (mount-orig-expand-file-name e))
	)
      f
      )
  )

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

; this is best done in host-init
; (mount-hook-file-commands)


; xxx todo: catch shell command w <world> for shell-cd


(defun delete-all-other-frames ()
	(interactive)
	"delete all frames except the currently focused one."
	(dolist (a (frame-list))
		(if (not (eq a (selected-frame)))
				(delete-frame a))))

;; where does this really belong?
(defun ftime () (interactive)
	"display formatted time string last modification time of file for current buffer"
  (let* ((fn (buffer-file-name))
	(f (and fn (elt (file-attributes fn) 5))))
    (message (if f
	(clean-string (eval-process "mktime" (format "%d" (car f)) (format "%d" (cadr f))))
	"no file")
	)
    )
  )

(defvar do-tickle nil)
(if do-tickle
    (add-hook 'after-init-hook
	      '(lambda () 
		 (let ((s (string* (condition-case x (read-file "~/.tickle") (error nil)))))
		   (and s
			(messagebox s "don't forget")
			)
		   )
		 )
	      )
  )


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

(defun evilnat () (not (string-match "ok" (perl-command "evilnat"))))


(defun cygwin-find-file-hook ()
  "automatically follow symlink unless prefix is given"
  (if (string-match "^!<symlink>" (buffer-string))
      (find-file (substring (buffer-string) (match-end 0))))
  )

(add-hook 'find-file-hooks 'cygwin-find-file-hook)

; make sure post-man gets loaded the first time man is called.
(global-set-key "\C-h\C-m" '(lambda () (interactive) (load-library "post-man") (global-set-key "\C-h\C-m" 'man) (call-interactively 'man)))

;; this works, but breaks host-ok...

;; advise expand-file-name to be aware of cygmounts

;; (defadvice expand-file-name (around expand-file-name-hook activate)
;;   (let* ((d (ad-get-arg 0))
;; 	 (d1 (unless (string-match "^//\\|^~\\|^[a-zA-`]:" d)
;; 	       (loop for y in cygmounts 
;; 		     if (or
;; 			 (string-match (concat "^" (car y) "/") d)
;; 			 (string-match (concat "^" (car y) "$") d))
;; 		     return (replace-in-string (concat "^" (car y)) (cadr y) d)
;; 		     ))))
;;     (if d1 (ad-set-arg 0 d1))
;; 
;;     ad-do-it
;;     )
;; )


; (if (ad-is-advised 'expand-file-name) (ad-unadvise 'expand-file-name))
; (expand-file-name (fw "broadjump"))
; (funcall 'ad-Orig-expand-file-name (fw "broadjump"))


(defadvice w32-drag-n-drop (around 
			    hook-w32-drag-n-drop
			    first activate)
  ""

  ; apply file association, if exist

  (if (file-association-1 (caar (cddr (ad-get-arg 0))))
      (progn 
	(aexec (caar (cddr (ad-get-arg 0))))
	(raise-frame))

  ; otherwise, just do it.
    ad-do-it
    )
  )

; (if (ad-is-advised 'w32-drag-n-drop) (ad-unadvise 'w32-drag-n-drop))

(defun internet-explorer (arg) 
  " run ie on `buffer-file-name', assuming it maps to a uri.
interactively with arg means use the contents of region instead"
  (interactive "P")        

  (let ((url (cond ((stringp arg) arg)
		   (arg (buffer-substring (point) (mark)))
		   (t (concat "localhost" 
			      (unix-canonify (string* (buffer-file-name) "") 0))))))

    (if url
	(start-process "*ie*"
		       (zap-buffer " *ie*")
		       "c:/Program Files/Internet Explorer/IEXPLORE.EXE"
		       url
		       )
      )
    )
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

;; this be broken:
;; (assoc* "Icon File"
;;	 (w32-shortcut
;;	  (w32-canonify (concat  user-profile "/Desktop" "/"  "rainier.lnk")))
;;	 :test 'string=
;;	 )
;;

; is windows standard for undo...

(global-set-key "\C-z" 'undo)
