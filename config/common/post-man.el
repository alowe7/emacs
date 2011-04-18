(put 'post-man 'rcsid
 "$Id$")

(require 'buffers)

(defun switch-to-man-buffer ()
  "switch to most recent man buffer
"
  (interactive)
  (let* (
	 (mode  'Man-mode)
	 (l (collect-buffers-mode mode))
	 (b (car l))
	 (w (get-buffer-window b)))

    (if w (select-window w)
      (if b (switch-to-buffer-other-window b)
	(message "no buffers in mode %s" mode)
	)
      )
    )
  )

(defun roll-man-buffers ()
  (interactive)
  (roll-list
   (cdr (collect-buffers-mode 'Man-mode))
   '(lambda (x) (progn (switch-to-buffer x) (buffer-name x))) 'kill-buffer-1 'switch-to-buffer)
  )

(define-key help-map "\C-l" 'switch-to-man-buffer)
(define-key Man-mode-map "\M-n" 'roll-man-buffers)
