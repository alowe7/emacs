(put 'post-psgml 'rcsid
 "$Id: post-psgml.el,v 1.4 2003-03-03 14:55:55 cvs Exp $")

(define-key xml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key xml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key xml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key xml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" xml-mode-syntax-table)
(modify-syntax-entry ?> ")" xml-mode-syntax-table)


(define-key sgml-mode-map "\C-c\C-f\C-f" 'find-file-force-refresh)


(setq-default sgml-set-face t)
  ;;
  ;; Faces.
  ;;
  (make-face 'sgml-comment-face)
  (make-face 'sgml-doctype-face)
  (make-face 'sgml-end-tag-face)
  (make-face 'sgml-entity-face)
  (make-face 'sgml-ignored-face)
  (make-face 'sgml-ms-end-face)
  (make-face 'sgml-ms-start-face)
  (make-face 'sgml-pi-face)
  (make-face 'sgml-sgml-face)
  (make-face 'sgml-short-ref-face)
  (make-face 'sgml-start-tag-face)

  (set-face-foreground 'sgml-comment-face "dark green")
  (set-face-foreground 'sgml-doctype-face "maroon")
  (set-face-foreground 'sgml-end-tag-face "blue2")
  (set-face-foreground 'sgml-entity-face "red2")
  (set-face-foreground 'sgml-ignored-face "maroon")
  (set-face-background 'sgml-ignored-face "gray90")
  (set-face-foreground 'sgml-ms-end-face "maroon")
  (set-face-foreground 'sgml-ms-start-face "maroon")
  (set-face-foreground 'sgml-pi-face "maroon")
  (set-face-foreground 'sgml-sgml-face "maroon")
  (set-face-foreground 'sgml-short-ref-face "goldenrod")
  (set-face-foreground 'sgml-start-tag-face "blue2")

  (setq-default sgml-markup-faces
   '((comment . sgml-comment-face)
     (doctype . sgml-doctype-face)
     (end-tag . sgml-end-tag-face)
     (entity . sgml-entity-face)
     (ignored . sgml-ignored-face)
     (ms-end . sgml-ms-end-face)
     (ms-start . sgml-ms-start-face)
     (pi . sgml-pi-face)
     (sgml . sgml-sgml-face)
     (short-ref . sgml-short-ref-face)
     (start-tag . sgml-start-tag-face)))

