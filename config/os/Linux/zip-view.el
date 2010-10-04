(put 'zip-view 'rcsid
 "$Id$")

(defun zip-view (f) 
  (let ((b (zap-buffer (format "%s *zip*" f))))
    (call-process "unzip" nil b nil "-l" f)
    (display-buffer b)
    )
  )

(add-file-association "zip" 'zip-view)

(provide 'zip-view)
