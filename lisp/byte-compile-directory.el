(defconst rcs-id "$Id: byte-compile-directory.el,v 1.2 2000-07-30 21:07:44 andy Exp $")
(mapcar 'byte-compile-file (directory-files "." nil "\.el$"))