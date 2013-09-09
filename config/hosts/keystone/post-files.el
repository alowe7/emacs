(put 'post-files 'rcsid
 "$Id$")

; size default-frame-alist  like current frame 

(defadvice switch-to-buffer-other-frame (around 
					 hook-switch-to-buffer-other-frame
					 first activate)

  (let* ((l default-frame-alist))
    (loop for x in (quote (top left width height)) do (nsubst (cons x (frame-parameter nil x)) x l :test (lambda (y z) (and (listp z) (eq y (car z))))))
    ad-do-it
    )
  )

; (if (ad-is-advised 'switch-to-buffer-other-frame) (ad-unadvise 'switch-to-buffer-other-frame))
