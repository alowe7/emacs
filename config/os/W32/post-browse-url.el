(require 'regtool)

; (browse-url "http://www.alowe.com")
; (browse-url default-directory)
; (browse-url "e:/usr/share/doc/groovy-1.7.5/html/groovy-jdk/index-all.html")
; (browse-url "e:/usr/share/doc/groovy-1.7.5/html/groovy-jdk/index.html")

(require 'ctl-slash)
(define-key ctl-/-map "	" 'browse-url)

(defvar preferred-browser
  (let ((cmd (whence "w3m")))
    (or
     (and cmd (file-executable-p cmd) cmd)
     (car (split  (regtool "get" "/HKLM/software/Classes/htmlfile/shell/open/command/") "\"") )
     )
    ))
