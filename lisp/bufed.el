(put 'bufed 'rcsid "$Id: bufed.el,v 1.4 2000-10-03 16:44:06 cvs Exp $")
;;; bufed stuff

(defvar bufed-mode-syntax-table (let ((s (copy-syntax-table))) 
				  (modify-syntax-entry ?- "w" s)  
				  (modify-syntax-entry ?/ "w" s)  
				  (modify-syntax-entry ?. "w" s)  
				  s)
  "Syntax table in use in bufed-mode buffers.")
