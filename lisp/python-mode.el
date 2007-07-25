(defun python (&optional shell-num buffer)
  "like shell, but calls the windows command interpreter.
puts buffer into a mode derived from `shell-mode'.
see `cmd-mode' `shell2'
"
  (interactive
   (list (and current-prefix-arg (read-buffer "buffer: " "*python*"))))
  (shell2 shell-num nil "python" 'python-shell-mode)
  )

(define-derived-mode python-shell-mode shell-mode "Python" "a mode derived from `shell-mode'")

(define-derived-mode python-mode fundamental-mode  "Python" "a mode"
  (setq font-lock-syntactic-face-function
	(lambda (state)
	  (if (nth 3 state) nil font-lock-comment-face))
	)
  (setq indent-tabs-mode nil)
  (setq my-c-style
	'((c-tab-always-indent . t)
	  (c-offsets-alist . ((arglist-close . c-lineup-arglist)
			      (statement-block-intro . 4)
			      (statement-cont . 0)
			      (inline-open . 0)
			      (block-open . 0)
			      (block-close . 0)
			      (comment-intro . 0)
			      (topmost-intro . 0)
			      (knr-argdecl-intro . -)))
	  (c-echo-syntactic-information-p . t))
	)
  ;
  (define-key python-mode-map "," 'self-insert-command)
  (define-key python-mode-map ";" 'self-insert-command)
  )
; (loop for x in (symbols-like "python-mode") do (makunbound x))
(add-to-list 'auto-mode-alist '("\\.py" . python-mode))
(add-to-list 'font-lock-defaults-alist
	     '(python-mode
	       (perl-font-lock-keywords perl-font-lock-keywords-1 perl-font-lock-keywords-2)
	       nil nil
	       ((95 . "w") (36 . "w"))
	       nil
	      (font-lock-mark-block-function . mark-defun))
	     )

(require 'ctl-backslash)
(define-key ctl-\-map "p" 'python)


(defun collect-buffers-mode-1 (mode)
  "collect buffers in MODE and all derived modes
"
  (apply 'nconc (loop for x in (collect-derived-modes 'shell-mode) collect (collect-buffers-mode x)))
  )
; (collect-buffers-mode-1 'shell-mode)

(defun collect-derived-modes (mode)
  "collect a list of MODE and all derived modes
"
  (nconc (list mode) (loop for x in *derived-mode-map* when (eq (cadr x) mode) collect (car x)))
  )

(defvar *derived-mode-map*
  (loop for x in (symbols-like "-mode$")
	when
	(setq y (get x 'derived-mode-parent))
	collect (list x y)
	)
  "alist mapping all derived modes to their respective parents"
  )

(require 'gud)

(defun pydbg (module)
  (interactive "smodule: ")
  (gud-common-init "python" `("-m" "pdb" ,module)
		   'gud-gdb-marker-filter 'gud-gdb-find-file)
  (set (make-local-variable 'gud-minor-mode) 'pydbg)
  )
