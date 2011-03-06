(put 'zip-view 'rcsid
 "$Id: zip-view.el 890 2010-10-04 03:34:24Z svn $")

(defun zip-view (f) 
  (let ((b (zap-buffer (format "%s *zip*" f))))
    (call-process "unzip" nil b nil "-l" f)
    (display-buffer b)
    )
  )

(add-file-association "zip" 'zip-view)

(provide 'zip-view)
