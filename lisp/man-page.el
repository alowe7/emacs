
;; like browse mode, but format man page first
(defvar man-page-mode-map nil "")
(if man-page-mode-map
    ()
  (setq man-page-mode-map (make-sparse-keymap))
  (define-key man-page-mode-map "\t" 'tab-to-tab-stop)
  (define-key man-page-mode-map "\es" 'center-line)
  (define-key man-page-mode-map "\eS" 'center-paragraph)
  (define-key man-page-mode-map "\eS" 'center-paragraph)
  (define-key man-page-mode-map "" 'scroll-down)
  (define-key man-page-mode-map " " 'scroll-up)
  (define-key man-page-mode-map "q" '(lambda () (interactive) (kill-buffer nil)))
  )

(defun man-page-mode (&optional arg)
	"viewing mode specialized for man pages.
 with optional ARG no formatting is done.

 space to scroll down
 backspace to scroll up
 q to quit
"
  (interactive)
  (let ((read-only-p buffer-read-only))
    (setq buffer-read-only nil)
    (kill-all-local-variables)
    (use-local-map man-page-mode-map)
    (setq mode-name "Manpage")
    (setq major-mode 'man-page-mode)
    (auto-save-mode -1)
    (or arg (progn
	      (shell-command-on-region (point-min) (point-max) "nroff -man"  t)
	      (beginning-of-buffer)
	      (fix-man-page)))
;;; pretend this never happened
    (set-buffer-modified-p nil)
    (setq buffer-read-only read-only-p)
    )
  (run-hooks 'man-page-mode-hook)
  )
