(defun highlight-previous-line (arg)
  (interactive "p")

  (apply 'hilit-unhighlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   t))
	 )


  (previous-line arg)

  (apply 'hilit-highlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   '(("." nil highlight))
	   t))
	 )

  )

(defun highlight-next-line (arg)
  (interactive "p")

  (apply 'hilit-unhighlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   t))
	 )


  (next-line arg)

  (apply 'hilit-highlight-region
	 (nconc 
	  (line-as-region)
	  (list
	   '(("." nil highlight))
	   t))
	 )

  )
