(put 'post-gnuserv 'rcsid 
 "$Id: post-gnuserv.el,v 1.1 2001-03-26 16:25:57 cvs Exp $")

(defadvice server-find-file (after 
			     hook-server-find-file
			     first 
			     nil
			     activate)
  (raise-frame)
  )
