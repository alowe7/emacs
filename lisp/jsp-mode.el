(put 'jsp-mode 'rcsid
 "$Id$")

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

; it don't work
(setq it-works nil)
(unless it-works
  (fset 'jsp-mode 'html-mode)
  )

(add-to-list 'auto-mode-alist
		 '("\\.jsp$" . jsp-mode))
