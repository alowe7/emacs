(put 'post-hilit 'rcsid 
 "$Id: post-hilit.el,v 1.4 2000-11-20 01:03:02 cvs Exp $")

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

(defun unhighlight-buffer () (interactive) 
  (hilit-unhighlight-region (point-min) (point-max) t))
