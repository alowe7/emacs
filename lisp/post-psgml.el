(put 'post-psgml 'rcsid
 "$Id: post-psgml.el,v 1.7 2004-07-21 20:18:21 cvs Exp $")

(define-key sgml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key sgml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key sgml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key sgml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" sgml-mode-syntax-table)
(modify-syntax-entry ?> ")" sgml-mode-syntax-table)


(define-key sgml-mode-map "\C-c\C-f\C-f" 'find-file-force-refresh)

(add-hook 'sgml-mode-hook '(lambda () (define-key sgml-mode-map "\C-c\C-l" 'goto-line)))

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
  (set-face-foreground 'sgml-start-tag-face "blue1")
  (set-face-foreground 'sgml-entity-face "red2")
  (set-face-foreground 'sgml-ignored-face "turquoise4")
  (set-face-background 'sgml-ignored-face "gray90")
  (set-face-foreground 'sgml-ms-end-face "green2")
  (set-face-foreground 'sgml-ms-start-face "tan3")
  (set-face-foreground 'sgml-pi-face "coral1")
  (set-face-foreground 'sgml-sgml-face "cyan4")
  (set-face-foreground 'sgml-short-ref-face "goldenrod")

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

;; 
;; for psgml to work, html files should start with something like:
;; 
;; <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
;;    "http://www.w3.org/TR/html4/loose.dtd">
;; <html xmlns="http://www.w3.org/1999/xhtml" lang="en-US">
;; ...
;; or else maybe
;; <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
;;   "/usr/share/specs/html4.0/loose.dtd">
;;
;; (maybe should try to cache locally using `sgml-public-map', maybe should set `sgml-auto-activate-dtd')
;; 
;; (setq sgml-public-map '("%S" "/usr/share/specs/%o/%c/%d"))
;; "W3C//DTD HTML"
;; (regexp . filename)
;; 