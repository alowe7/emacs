(put 'byte-compile-directory 'rcsid "$Id: byte-compile-directory.el,v 1.3 2000-10-03 16:44:06 cvs Exp $")
(mapcar 'byte-compile-file (directory-files "." nil "\.el$"))