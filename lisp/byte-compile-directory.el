(put 'byte-compile-directory 'rcsid 
 "$Id: byte-compile-directory.el,v 1.4 2000-10-03 16:50:27 cvs Exp $")
(mapcar 'byte-compile-file (directory-files "." nil "\.el$"))