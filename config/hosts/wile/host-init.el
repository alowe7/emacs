(put 'host-init 'rcsid
 "$Id: host-init.el,v 1.4 2004-02-29 02:00:38 cvs Exp $")

(defvar process-environment-list (loop for x in  process-environment collect (split x "=")))

; (assoc "PATH"  process-environment-list)

(defun setenv* (var val)
  "fancy version of setenv that clobbers process-environment as well"
  (interactive "svar: \nsval: ")
  (setenv var val)
  (setq process-environment-list
	(remove-if '(lambda (x) (string= (car x) var )) process-environment-list))
  (nconc process-environment-list
	 (list (list var val)))
  (setq process-environment
	(loop for x in process-environment-list collect 
	      (concat (car x) "=" (cadr x))))
  )

(setenv* "PATH" "/u00/oracle/product/8.1.7/bin:/net/monolith/homes/alowe/bin:/usr/local/ActivePerl-5.6/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:sbin:/usr/openwin/bin")

(setq comint-prompt-regexp "^[0-9]+[>$%] *")

; somethings still wrong with the path.  meanwhile:
(setq locate-command "/usr/local/bin/locate")

(global-set-key "~" 'diff-backup)

(require 'eval-process)

(modify-frame-parameters (selected-frame) (list (cons 'title (format "%s@%s" (eval-process "whoami") (eval-process "uname" "-n")))))

(setq wbase (expand-file-name "~/w"))
(defvar wlog (format "%s/log" wbase))
(defun log (comment)
  (interactive "slog: ")
  (write-region (format "%s\t%s\n" (current-time-string) comment) nil wlog t)
  )
(defun write-file-log ()
  (log (buffer-file-name))
  ; a write-file-hook needs to return nil else the write is aborted
  )
(add-hook 'write-file-hooks 'write-file-log)

;; lazy load xz
(add-to-load-path "~/x/xz/site-lisp")
(load-library "xz-loads")

(setq default-frame-alist
      '((top + -2)
	(left . 1278)
	(width . 115)
	(height . 52)
	(background-mode . light)
	(cursor-type . box)
	(border-color . "black")
	(cursor-color . "Black")
	(mouse-color . "Black")
	(background-color . "White")
	(foreground-color . "Black")
	(vertical-scroll-bars)
	(internal-border-width . 1)
	(border-width . 2)
	(font . "-B&H-LucidaTypewriter-Medium-R-Normal-Sans-18-180-75-75-M-110-ISO8859-1")
	(menu-bar-lines . 0))
      )

(defun duplicate-frame-parameters ()
  (interactive)
  (setq default-frame-alist
	(loop for x in
	      '(top
		left
		width
		height
		background-mode
		cursor-type
		border-color
		cursor-color
		mouse-color
		background-color
		foreground-color
		vertical-scroll-bars
		internal-border-width
		border-width
		font
		menu-bar-lines
		) collect (assoc x (frame-parameters)))
	)
  )