;;multi-mode
(autoload 'multi-mode
  "multi-mode"
  "Allowing multiple major modes in a buffer."
  t)

(defun jsp-mode () (interactive)
  (java-mode) ; hack to get lazy-lock-mode to initialize
  (multi-mode 1
	      'html-mode
	      ;;your choice of modes for java and html
	      '("<%" java-mode)
	      ;;'("<%" jde-mode)
	      '("%>" html-mode)))

(add-to-list 'auto-mode-alist
	     '("\\.jsp$" . jsp-mode))
