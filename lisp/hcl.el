(put 'hcl 'rcsid 
 "$Id: hcl.el,v 1.5 2000-10-03 16:50:28 cvs Exp $")

(defun hcl (pat) (interactive "spat: ")
(egrep (format "-i %s f:/support/hcl.txt" pat)))