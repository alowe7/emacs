(put 'post-xdb 'rcsid
 "$Id: xdb.el,v 1.5 2004-10-01 23:07:54 cvs Exp $")

(chain-parent-file t)

(require 'ctl-slash)

(define-key ctl-/-map "q" 'xq)
(define-key ctl-/-map "t" 'xt)
(define-key ctl-/-map "n" 'xn)
(define-key ctl-/-map "b" 'txdbi)

(define-key ctl-RET-map "l" 'xl)
(define-key ctl-RET-map "=" 'xl=)
(define-key ctl-RET-map "-" 'xl*)
(define-key ctl-RET-map (vector (ctl ?/)) 'xl/)

; make sure we have a login
; (call-interactively 'xdb-login)

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
      (add-txdb-option "-h" (concat "localhost" ":" (*service-port* "mysqls")))
      (message (chomp (pp *txdb-options*)))
      (sit-for 2)
      (message "")
      )
  )

(defun xmn (name)
  " lookup a name in fx.people"
  (interactive "sname: ")
  (let ((s (string* (xq* (format  "select * from people where concat(First_Name,\" \",Last_Name) like '%%%s%%'" name)))))
    (if s
	(let ((b (zap-buffer *x*)))
	  (funcall
	   (if (eq major-mode 'x-query-mode) 'switch-to-buffer 'switch-to-buffer-other-window)
	   (save-window-excursion
	     (set-buffer b)
	     (insert s)
	     (goto-char (point-min))
	     (x-query-mode)
	     b)
	   )
	  (run-hooks 'after-x-query-hook)
	  )
      (error "No matches found"))
    )
  )

; override: if not found in x.people, look in fx.people
(defun xn (name)
  " lookup a name in x.people"

  (interactive "sname: ")
  (condition-case x
      (let* ((s (x-query-1 (format  "select id,item from people where item like '%%%s%%'" name)))
	     (l (split s "
"))
	     (id (car (split (car l)))))
	(xe-set 'people id 'id))
    (error (xmn name))
    )
  )

; (add-hook 'xdb-init-hook 'xdb-login)

(if (scan-file-p "~/.private/.xdbrc")
    (progn
      (add-txdb-option "-b" ($ "$XDB"))
      (add-txdb-option "-h" ($ "$XDBHOST"))
      *txdb-options*
      )
  )

(setq *local-txdb-options* '("-b" "a@fx" "-h" "localhost"))
