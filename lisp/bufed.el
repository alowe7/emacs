;;; bufed stuff

(defvar bufed-mode-syntax-table (let ((s (copy-syntax-table))) 
				  (modify-syntax-entry ?- "w" s)  
				  (modify-syntax-entry ?/ "w" s)  
				  (modify-syntax-entry ?. "w" s)  
				  s)
  "Syntax table in use in bufed-mode buffers.")
