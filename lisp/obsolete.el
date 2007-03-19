
; xxx unfortunately named.  see proof-compat.el

;; (defun replace-in-string (str regexp to &optional ignored)
;;   "replace occurrences of REGEXP with TO in  STRING
;; note: this function is defined somewhat differently in xemacs
;; " 
;;   (if (string= regexp "^")
;;       (concat to (replace-in-string "
;; " (concat "
;; " to) str)) 
;;     (let (new-str
;; 	  (sp 0)
;; 	  )
;;       (while (string-match regexp str sp)
;; 	(setq new-str (concat new-str (substring str sp (match-beginning 0)) to))
;; 	(setq sp (match-end 0)))
;;       (setq new-str (concat new-str (substring str sp)))
;;       new-str))
;;   )

;; xxx what's rong with get-buffer?

;; (defun buffer-exists-p (bname)
;;   " return buffer with specified NAME or nil"
;;   (interactive "Bbuffer name:") 
;;   (let ((bl (buffer-list)))
;;     (while (and bl  (not (string-equal bname  (buffer-name (car bl))))
;; 		(setq bl (cdr bl))))
;;     (and bl (car bl))
;;     ))

