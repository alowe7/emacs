(defconst rcs-id "$Id: hcl.el,v 1.3 2000-07-30 21:07:45 andy Exp $")

(defun hcl (pat) (interactive "spat: ")
(egrep (format "-i %s f:/support/hcl.txt" pat)))