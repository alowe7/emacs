(put 'post-psgml 'rcsid
 "$Id: post-psgml.el,v 1.1 2002-04-14 03:04:57 cvs Exp $")

(define-key xml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key xml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key xml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key xml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" xml-mode-syntax-table)
(modify-syntax-entry ?> ")" xml-mode-syntax-table)

