(put 'post-psgml 'rcsid
 "$Id: post-psgml.el,v 1.2 2002-06-06 17:17:44 cvs Exp $")

(define-key xml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key xml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key xml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key xml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" xml-mode-syntax-table)
(modify-syntax-entry ?> ")" xml-mode-syntax-table)


