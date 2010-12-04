(put 'post-locate 'rcsid
 "$Id$")

(defun locate-explore-directory ()
  (interactive)
  (explore (file-name-directory (locate-get-dirname)))
  )

(define-key locate-mode-map (vector 'f12) 'locate-explore-directory)
