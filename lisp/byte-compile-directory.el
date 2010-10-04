(put 'byte-compile-directory 'rcsid 
 "$Id$")
(mapcar 'byte-compile-file (directory-files "." nil "\.el$"))