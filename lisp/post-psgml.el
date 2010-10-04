(put 'post-psgml 'rcsid
 "$Id$")

;; override sgml-list-implications to not popup the stupid error buffer

(defvar bang nil "this is a hack to avoid popping up the all too frequent error buffer")

(define-key sgml-mode-map (vector '\C-right) 'sgml-forward-element)
(define-key sgml-mode-map (vector '\C-left) 'sgml-backward-element)
(define-key sgml-mode-map (vector '\C-down) 'sgml-fold-element)
(define-key sgml-mode-map (vector '\C-up) 'sgml-unfold-element)
(modify-syntax-entry ?< "(" sgml-mode-syntax-table)
(modify-syntax-entry ?> ")" sgml-mode-syntax-table)


(define-key sgml-mode-map "\C-c\C-f\C-f" 'find-file-force-refresh)
(define-key sgml-mode-map "\C-c\C-ff" 'font-lock-fontify-buffer)

(defun my-sgml-mode-hook () 
  (set-tabs 2)
  (font-lock-mode)
  (define-key sgml-mode-map "\C-c\C-l" 'goto-line)
  (setq sgml-indent-data t)
  (recenter)
  )
(add-hook 'sgml-mode-hook 'my-sgml-mode-hook)

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


;; override

(defun sgml-list-implications (token type)
  "Return a list of the tags implied by a token TOKEN.
TOKEN is a token, and the list elements are either tokens or `t'.
Where the latter represents end-tags."
  (let ((state sgml-current-state)
	(tree sgml-current-tree)
	(temp nil)
	(imps nil))
    (while				; Until token accepted
	(cond
	 ;; Test if accepted in state
	 ((or (eq state sgml-any)
	      (and (sgml-model-group-p state)
		   (not (memq token (sgml-tree-excludes tree)))
		   (or (memq token (sgml-tree-includes tree))
		       (sgml-get-move state token))))
	  nil)
	 ;; Test if end tag implied
	 ((or (eq state sgml-empty)
	      (and (sgml-final-p state)
		   (not (eq tree sgml-top-tree))))
	  (unless (eq state sgml-empty)	; not really implied
	    (push t imps))
	  (setq state (sgml-tree-pstate tree)
		tree (sgml-fake-close-element tree))
	  t)
	 ;; Test if start-tag can be implied
	 ((and (setq temp (sgml-required-tokens state))
	       (null (cdr temp)))
	  (setq temp (car temp)
		tree (sgml-fake-open-element tree temp
					     (sgml-get-move state temp))
		state (sgml-element-model tree))
	  (push temp imps)
	  t)
	 ;; No implictions and not accepted
	 (t
	  (and bang (debug)) ;;; XXX
	  (sgml-log-warning "Out of context %s" type)
	  (setq imps nil))))
    ;; Return the implications in correct order
    (nreverse imps)))