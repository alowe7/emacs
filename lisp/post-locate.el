(put 'post-locate 'rcsid 
 "$Id: post-locate.el,v 1.1 2001-06-25 15:32:39 cvs Exp $")

(require 'fb)

(define-key locate-mode-map "d" 'fb-dired-file) 
(define-key locate-mode-map "o" 'fb-find-file-other-window)
(define-key locate-mode-map "f" 'fb-find-file)
(define-key locate-mode-map "i" 'fb-file-info)


