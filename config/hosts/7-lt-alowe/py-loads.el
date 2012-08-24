(put 'py-loads 'rcsid
 "$Id$")

(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(autoload 'python-mode "python-mode" "Python editing mode." t)
(autoload 'py-shell "python-mode" "Python editing mode." t)
; (setq py-shell-name "/Python27/pythonw")
; (setq py-shell-name "/Python27/python")
(setq py-shell-name "python")

; (add-to-list 'load-path "~/.emacs.d/vendor/pymacs-0.24-beta2")
; (add-to-list 'load-path "~/.emacs.d/vendor/auto-complete-1.2")

(setenv "PYMACS_PYTHON"  py-shell-name)
(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete-1.2/dict")


(defun my-python ()
  (interactive)
  (let* ((p (get-process "python"))
	 (b (and (processp p) (eq (process-status p) 'run) (process-buffer p)))
	 (w (and b (buffer-live-p b) (get-buffer-window b))))
    (cond
     (w (select-window w))
     (b (switch-to-buffer b))
     (t  (py-shell "python"))
     )
    )
  )

(require 'ctl-ret)
(define-key ctl-RET-map "p" 'my-python)


(provide 'py-loads)

