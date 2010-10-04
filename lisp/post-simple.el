(put 'post-simple 'rcsid
 "$Id$")

(require 'advice)
(require 'qsave)

; don't know why *Shell Command Output* gets buried, nor why it has spaces in it
(defvar shell-command-default-output-buffer "*Shell-Command-Output*")
(setq shell-command-default-error-buffer "*Shell-Command-Error*")

;; add qsave capability to shell-command-default-output-buffer
(define-derived-mode shell-command-mode fundamental-mode "shell-command" "")
(define-key  shell-command-mode-map "p" 'roll-qsave)
(define-key  shell-command-mode-map "n" 'roll-qsave-1)

(defvar *last-shell-command* nil)
(defun shell-command-save-search ()
  (qsave-search (current-buffer) *last-shell-command* default-directory)
  )

(add-hook 'post-shell-command-hook 'shell-command-save-search)

(defadvice shell-command (around 
			  hook-shell-command
			  first activate)
  ""

  (let 
      ((output-buffer  (zap-buffer (or (ad-get-arg 1) shell-command-default-output-buffer)))
       (error-buffer (zap-buffer (or (ad-get-arg 2) shell-command-default-error-buffer)))
       output-len)

    ad-do-it

    (let ((err (save-excursion
		 (set-buffer error-buffer)
		 (and (> (point-max) 0) (buffer-string)))))
      (and err (message err))
      )

    (save-excursion
      (set-buffer output-buffer)
      (setq output-len (length (chomp (buffer-string))))
      (shell-command-mode)
      (set-buffer-modified-p nil)
      (run-hooks 'post-shell-command-hook)
      )

    (if (> output-len 0)
	(display-buffer output-buffer))
    )
  )

; (if (ad-is-advised 'shell-command) (ad-unadvise 'shell-command) )

; (if (ad-is-advised 'shell-command-on-region) (ad-unadvise 'shell-command-on-region) )

(defun roll-mark ()
  (interactive)
  (setq mark-ring (remove-duplicates mark-ring :test '(lambda (a b) (= (marker-position a) (marker-position b)))))
  (let ((marker (roll mark-ring)))
  ;  '(lambda (x) (format "%d" (marker-position x))))))
    (goto-char (car marker)))
  )
(define-key alt-SPC-map "\M-." 'roll-mark)


