
(defun other-locate (search-string &optional filter arg)

  (let ((locate-make-command-line (function (lambda (arg)  (debug) (list "grep" "-i" arg locate-fcodes-file)))))

    (funcall 'locate search-string filter arg)
    )
  )

; (other-locate "fubar")
