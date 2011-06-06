(require 'roll)

(defun docs-like (pat)
  (interactive "spat: ")
  (loop for x being the symbols
	when (and (functionp x) 
		  (stringp (documentation x)) 
		  (string-match pat (documentation x)))
	collect x))


(defvar *last-docs-like* nil)
; (setq  *last-docs-like* (mapcar 'symbol-name '(with-temp-message c-version momentary-string-display shell-command read-key-sequence describe-current-coding-system-briefly display-time message-or-box current-message message-box send-invisible calendar-goto-julian-date comint-send-input comint-watch-for-password-prompt octave-mode battery comint-read-noecho quail-define-package shell-mode map-y-or-n-p read-passwd reset-this-command-lengths read-key-sequence-vector shell-command-on-region locate-library)))

(defun roll-docs-like (&optional arg) (interactive "P")
  (if (or (not *last-docs-like*) arg)
      (setq *last-docs-like* (call-interactively 'docs-like)))
  (let ((pick (roll-list  *last-docs-like*)))
    (if pick (describe-function (intern pick))))
  )

(define-key help-map " " 'roll-docs-like)

; (roll-docs-like)
