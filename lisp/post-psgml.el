(put 'post-psgml 'rcsid
 "$Id: post-psgml.el,v 1.3 2003-01-22 15:40:01 cvs Exp $")

(define-key xml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key xml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key xml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key xml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" xml-mode-syntax-table)
(modify-syntax-entry ?> ")" xml-mode-syntax-table)


(define-key sgml-mode-map "\C-c\C-f\C-f" 'find-file-force-refresh)