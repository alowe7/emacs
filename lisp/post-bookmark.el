 
(require 'ctl-slash)
(define-key ctl-/-map (vector (ctl ?.)) 'bookmark-save)
(define-key ctl-/-map (vector (ctl ?,)) 'bookmark-reload)
(define-key ctl-/-map "e" 'edit-bookmarks)

(defun bookmark-reload () (interactive)
  (bookmark-load  bookmark-default-file t)
)

(fset 'bookmark-add 'bookmark-set)

; don't use tags too much anymore
(global-set-key "\M-." 'bookmark-set)
(global-set-key "\M-," 'bookmark-jump)
(global-set-key "\M-," 'bookmark-jump)
