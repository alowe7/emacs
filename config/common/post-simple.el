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


(defun roll-mark ()
  (interactive)
  (setq mark-ring (remove-duplicates mark-ring :test (lambda (a b) (= (marker-position a) (marker-position b)))))
  (let ((marker (roll mark-ring)))
  ;  (lambda (x) (format "%d" (marker-position x))))))
    (goto-char (car marker)))
  )

(require 'alt-spc)
(define-key alt-SPC-map "\M-." 'roll-mark)


