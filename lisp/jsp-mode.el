;;multi-mode
(autoload 'multi-mode
  "multi-mode"
  "Allowing multiple major modes in a buffer."
  t)

;; get multi-mode to work someday
;; (defun jsp-mode () (interactive)
;;   (java-mode) ; hack to get lazy-lock-mode to initialize
;;   (save-excursion 
;;     (multi-mode 1
;; 		'html-mode
;; 		;;your choice of modes for java and html
;; 		'("<%" java-mode)
;; 		;;'("<%" jde-mode)
;; 		'("%>" html-mode))
;;     )
;;   )

(fset 'jsp-mode 'html-mode)

(setq it-works nil)
(if it-works
    (add-to-list 'auto-mode-alist
		 '("\\.jsp$" . jsp-mode))
  (add-to-list 'auto-mode-alist
	       '("\\.jsp$" . html-mode))
  )
