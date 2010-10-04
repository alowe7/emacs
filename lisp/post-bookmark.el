(put 'post-bookmark 'rcsid
 "$Id$")
 
(require 'ctl-ret)
(define-key ctl-RET-map "e" 'edit-bookmarks)
(define-key ctl-RET-map "m" 'bookmark-set)
(define-key ctl-RET-map "" 'bookmark-save)
(define-key ctl-RET-map "" 'bookmark-reload)
(define-key ctl-RET-map (vector (ctl ?.)) 'bookmark-jump) ; [\C-RET \C-.]

(defun bookmark-reload () (interactive)
  (bookmark-load  bookmark-default-file t)
)

(fset 'bookmark-add 'bookmark-set)

; don't use tags too much anymore
