(require 'ctl-slash)
(define-key ctl-/-map "x" 'xdb)
; make sure we have a login
(call-interactively 'xdb-login)

(defvar *services*
  (loop for x in (split (read-file (format "%s/system32/drivers/etc/services" *systemroot*)) "
")
	when (and (string* x) (not (string-match "^[ 	#]" x)))
	collect 
	(split x "[ 	]+")))
; (assoc "mysqls" *services*)

(defun *service-port* (service) (car (split (cadr (assoc service *services*)) "/")))
; (*service-port* "mysqls")


(defvar *my-service-list* (list (assoc "mysqls" *services*) (assoc "vncs" *services*) (assoc "cvss" *services*)))

(defun service (service) 
  (interactive (list (completing-read "service: " 
				      *my-service-list*)))
  (loop for x in (split (eval-process "netstat" "-p" "tcp" "-a") "
")
	when (string-match service x)
	collect x))

(if (service "mysqls")
  ; we're tunneling mysql access, so use localhost
    (progn
      (add-txdb-option "-p" (*service-port* "mysqls"))
      (add-txdb-option "-h" "localhost")
      (message (chomp (pp *txdb-options*)))
      (sit-for 2)
      (message "")
      )
  )


