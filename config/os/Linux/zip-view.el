(put 'zip-view 'rcsid
 "$Id: zip-view.el,v 1.1 2006-06-14 00:41:57 tombstone Exp $")

(defun zip-view (f) 
  (let ((b (zap-buffer (format "%s *zip*" f))))
    (call-process "unzip" nil b nil "-l" f)
    (display-buffer b)
    )
  )

(add-file-association "zip" 'zip-view)

(provide 'zip-view)
