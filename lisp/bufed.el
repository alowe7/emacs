(defconst rcs-id "$Id: bufed.el,v 1.3 2000-07-30 21:07:44 andy Exp $")
;;; bufed stuff

(defvar bufed-mode-syntax-table (let ((s (copy-syntax-table))) 
				  (modify-syntax-entry ?- "w" s)  
				  (modify-syntax-entry ?/ "w" s)  
				  (modify-syntax-entry ?. "w" s)  
				  s)
  "Syntax table in use in bufed-mode buffers.")
