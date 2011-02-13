(defvar share (expand-file-name (or (getenv "SHARE") "/usr/share/emacs")))
(defvar *configdirlist* (list (expand-file-name (format "%d" emacs-major-version)  ".") 
			      (expand-file-name (system-name) "./hosts")
  ; will not be defined in batch mode
  ; (symbol-name window-system)
			      (expand-file-name "W32" "./os")
			      (expand-file-name "x" "./os")))

(mapc '(lambda (x) (add-to-list 'load-path x))
      (nconc
       (list
	(expand-file-name "~/emacs/lisp")
	(concat share "/site-lisp")
	)
       (directory-files (concat share "/site-lisp") t "^[a-zA-Z]")
       *configdirlist*
       )
      )

(setq byte-compile-warnings '(not cl-functions free-vars unresolved))

; (message (pp load-path))

(mapc
 '(lambda (d) (mapc 'byte-compile-file (directory-files d t ".el$")))
 *configdirlist*
 )

