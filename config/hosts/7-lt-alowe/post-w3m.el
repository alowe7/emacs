(chain-parent-file t)

(require 'long-comment)

(setq w3m-no-proxy-domains '("ows.com" "textron.com"))
(setq w3m-default-display-inline-images t)

(defvar *ows-net-mask* '("172.17.0.0" "255.255.0.0") "list of the form (NET MASK) describing the ows network")

(defvar *use-proxy* (use-proxy))
(defvar *ows-proxy* "http://10.232.50.8:8080")

; need hook when ipaddress changes

(defun use-proxy () 
  (setq *use-proxy* (loop for x in (ipaddress) thereis (apply 'isInNet (nconc (list x) *ows-net-mask*))))
  (setq w3m-command-arguments
	(if *use-proxy* '("-o" "http_proxy=http://10.232.50.8:8080")))
  )

; (setenv "HTTP_PROXY" (if *use-proxy* *ows-proxy* ""))
; (getenv "HTTP_PROXY")
; (setenv "HTTP_PROXY" nil)

(/*
(defadvice w3m (around 
		hook-w3m
		first activate)
  ""

  (let* ((url (ad-get-arg 0)))
    ad-do-it
    )
  )
)

(setq browse-url-browser-function 'w3m-browse-url)
(global-set-key "\C-xm" 'browse-url-at-point)
(global-set-key "\C-xw" 'w3m)

; w3m-process-authinfo-alist
(setq *realmrc* "/src/.private/.realmrc")

; (setq w3m-process-authinfo-alist nil)

(defun init-w3m-process-authinfo-alist (realmrc &optional overwrite)

  (when overwrite 
    (setq w3m-process-authinfo-alist nil)
    )

  (unless (file-exists-p realmrc)
    (error "error reading realmrc, %s does not exist"  realmrc))

  (when (file-exists-p realmrc)
    (let ((l (splitf (read-file realmrc))))
      (loop for x in l do
	    (let* ((v (split x ","))
		   (hostname (car v))
		   (realm (cadr v))
		   (username (caddr v))
		   (password (cadddr v)))


	      (setq w3m-process-authinfo-alist
		    (remove* (cons hostname realm) w3m-process-authinfo-alist :test '(lambda (x y) (equal x (cons (car y) (caadr y))))))

	      (pushnew
  ;      (("hostname" ("realm" ("username" . "password"))))
	       `(, hostname (, realm (,@(cons username password))))
	       w3m-process-authinfo-alist
	       )
	      )
	    )
      )
    )
  )

; (init-w3m-process-authinfo-alist *realmrc* t)

(init-w3m-process-authinfo-alist *realmrc*)
