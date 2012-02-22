(put 'url-helpers 'rcsid 
 "$Id$")
(setq url-automatic-cacheing nil)
(setq url-use-viewers nil)

(defun url-retrieve-internally (url &optional no-cache)
  "Retrieve a document over the World Wide Web.
The document should be specified by its fully specified
Uniform Resource Locator.  No parsing is done, just return the
document as the server sent it.  The document is left in the
buffer specified by url-working-buffer.  url-working-buffer is killed
immediately before starting the transfer, so that no buffer-local
variables interfere with the retrieval.  HTTP/1.0 redirection will
be honored before this function exits."
  (if (get-buffer url-working-buffer)
      (with-current-buffer url-working-buffer
	(erase-buffer)
	(setq url-current-can-be-cached (not no-cache))
	(set-buffer-modified-p nil)))
  (if (not (string-match "\\([^:]*\\):/*" url))
			(progn (setq url (url-parse-relative-link url)) (string-match "\\([^:]*\\):/*" url)))
;      (error "Malformed URL: %s" url)

  (let* ((type (substring url (match-beginning 1) (match-end 1)))
	 (url-using-proxy (and
			   (if (assoc "no_proxy" url-proxy-services)
			       (not (string-match
				     (cdr
				      (assoc "no_proxy" url-proxy-services))
				     url))
			     t)
			   (not
			    (and
			     (string-match "file:" url)
			     (not (string-match "file://" url))))
			   (cdr (assoc type url-proxy-services))))
	 (handler nil)
	 (original-url url)
	 (cached nil)
	 (tmp url-current-file))
    (if url-using-proxy
	(setq url (concat url-using-proxy
			  (if (equal (substring url-using-proxy -1 nil) "/")
			      "" "/") url)
	      type (and (string-match "\\([^:]*\\):/*" url-using-proxy)
			(url-match url-using-proxy 1))))
    (setq
	; cached (url-is-cached url)
	; cached (and cached (not (url-cache-expired url cached)))
		 handler (if cached 'url-extract-from-cache
							 (intern (downcase (concat "url-" type))))
		 url (if cached (url-create-cached-filename url) url))

    (if (fboundp handler)
				(funcall handler url)
      (set-buffer (get-buffer-create url-working-buffer))
      (setq url-current-file tmp)
      (erase-buffer)
      (insert "<title> Link Error! </title>\n"
							"<h1> An error has occurred... </h1>\n"
							(format "The link type <code>%s</code>" type)
							" is unrecognized or unsupported at this time.<p>\n"
							"If you feel this is an error, please "
							"<a href=\"mailto://" url-bug-address "\">send me mail.</a>"
							"<p><address>William Perry</address><br>"
							"<address>" url-bug-address "</address>")
      (setq url-current-file "error.html"))
    (if (and
	 (not url-be-asynchronous)
	 (get-buffer url-working-buffer))
	(url-clean-text))
    (cond
     ((equal type "wais") nil)
     ((and url-be-asynchronous (not cached) (equal type "http")) nil)
     ((not (get-buffer url-working-buffer)) nil)
     ((and (not url-inhibit-mime-parsing)
	   (or cached (url-mime-response-p t)))
      (or cached (url-parse-mime-headers nil t))))
    (if (and (or (not url-be-asynchronous)
		 (not (equal type "http")))
	     (not url-current-mime-type))
	(if (url-buffer-is-hypertext)
	    (setq url-current-mime-type "text/html")
	  (setq url-current-mime-type (mm-extension-to-mime
				      (url-file-extension
				       url-current-file)))))
    (and url-using-proxy (url-fix-proxy-url))
    (if (and url-automatic-cacheing url-current-can-be-cached)
	(save-excursion
	  (url-store-in-cache url-working-buffer)))
    (and (not (url-have-visited-url original-url))
	 (setq url-global-history-completion-list
	       (cons (cons original-url (current-time-string)) 
		     url-global-history-completion-list)))
    cached)
)


(defun url-open-stream (name buffer host service)
  "Open a stream to a host"
  (let ((tmp-gateway-method (if (and url-gateway-local-host-regexp
				     (string-match
				      url-gateway-local-host-regexp
				      host))
				'native
			      url-gateway-method)))
    (and (eq url-gateway-method 'tcp)
	 (require 'tcp)
	 (setq url-gateway-method 'native
	       tmp-gateway-method 'native))
    (cond
     ((eq tmp-gateway-method 'native)
      (if url-broken-resolution
	  (setq host
		(cond
		 ((featurep 'ange-ftp) (ange-ftp-nslookup-host host))
		 ((featurep 'efs) (efs-nslookup-host host))
		 ((featurep 'efs-auto) (efs-nslookup-host host))
		 (t host))))
      (let ((retry url-connection-retries)
	    (conn nil))
				; this previously had an infinite loop!
				; don't retry on failed connects to local files
				; then don't forget to decrement retry count
	(while (and (not conn)
							(not (string-equal host "file"))
							retry)

	  (condition-case ()
	      (setq conn (open-network-stream name buffer host service))
	    (error
			 (prog1
					 (setq retry (funcall url-confirmation-func
																(concat "Connection to " host
																				" failed, retry? "))))
			 )))
	(if conn
 	    (progn
 	      (if (boundp 'MULE)
		  (with-current-buffer (get-buffer-create buffer)
		    (setq mc-flag nil)
		    (set-process-coding-system conn *noconv* *noconv*)))
 	      conn)
	  (error "Unable to connect to %s:%s" host service))))
     ((eq tmp-gateway-method 'host)
      (if (or (null url-gateway-host-process)
	      (not (processp url-gateway-host-process))
	      (not (memq (process-status url-gateway-host-process)
			 '(run open))))
	  (progn
	    (or url-gateway-host-username
		(setq url-gateway-host-username (user-login-name)))
	    (or url-gateway-host-password
		(setq url-gateway-host-password
		      (funcall url-passwd-entry-func
			       (concat "Password for gateway "
				       url-gateway-host-username "@"
				       url-gateway-host ": "))))
	    (url-gateway-initialize-host-process url-gateway-host
						 url-gateway-host-username
						 url-gateway-host-password)))
      (with-current-buffer
	  (get-buffer-create url-working-buffer)
	(set-process-buffer url-gateway-host-process
			    (current-buffer))
	(erase-buffer)
	(process-send-string url-gateway-host-process
			     (concat
			      (if url-gateway-shell-is-telnet
				  "open"
				url-gateway-host-program)
			      " " host " " service "\n"))
	(while (not
		(progn
		  (goto-char (point-min))
		  (re-search-forward
		   url-gateway-host-program-ready-regexp nil t)))
	  (url-accept-process-output url-gateway-host-process)
	  (url-lazy-message "Waiting for remote process to initialize..."))
	(delete-region (point-min) (point-max))
	url-gateway-host-process))
     ((eq tmp-gateway-method 'program)
      (let ((proc (start-process name buffer url-gateway-telnet-program host
				 (int-to-string service)))
	    (tmp nil))
	(with-current-buffer buffer
	  (setq tmp (point))
	  (while (not (progn
			(goto-char (point-min))
			(re-search-forward 
			 url-gateway-telnet-ready-regexp nil t)))
	    (url-accept-process-output proc))
	  (delete-region tmp (point))
	  (goto-char (point-min))
	  (if (re-search-forward "connect:" nil t)
	      (progn
		(condition-case ()
		    (delete-process proc)
		  (error nil))
		(url-replace-regexp ".*connect:.*" "")
		nil)
	    proc))))
     (t (error "Unknown url-gateway-method %s" url-gateway-method)))))

; do not infer remote file://... from non-existent local file://...
; remote ftp:// is ok
(defun url-grok-file-href (url)
  "Return a list of username, server, file, destination out of URL"
  (let (user server file dest pswd)
    (cond
     ((and (string-match "file://" url)	; local file
					 (not (file-exists-p (substring url (match-end 0))))) 
			(error  "file not found: %s" url))
     ((and (string-match "ftp://" url) ; Remote file
					 (not (file-exists-p (substring url (match-end 0)))))
      (string-match "^\\(ftp\\)://*\\([^/]*\\)/*\\(/.*\\)" url)
      (setq server (url-match url 2)
						file (url-match url 3)
						user "anonymous"
						dest (if (string-match "#.+$" file)
										 (prog1
												 (substring file (1+ (match-beginning 0))
																		(match-end 0))
											 (setq file (substring file 0 (match-beginning 0))))
									 nil))
      (if (string= "" server)
					(setq server (if (= (string-to-char file) ?/) (substring file 1 nil)
												 file)
								file "/"))
      (if (string-match "@" server)
					(setq user (substring server 0 (match-beginning 0))
								server (substring server (1+ (match-beginning 0)) nil)))
      (if (string-match ":" server)
					(setq server (substring server 0 (match-beginning 0))))
      (if (equal server "localhost")
					(setq server nil))
      (if (string-match "\\(.*\\):\\(.*\\)" user)
					(setq user (url-match user 1)
								pswd (url-match user 2)))
      (cond
       ((null pswd) nil)
       ((fboundp 'ange-ftp-set-passwd)
				(ange-ftp-set-passwd server user pswd))
       ((fboundp 'efs-set-passwd)
				(efs-set-passwd server user pswd))))
     (t
      (setq dest (if (string-match "#\\(.+\\)$" url)
										 (prog1
												 (url-match url 1)
											 (setq url (substring url 0 (match-beginning 0))))
									 nil)
						file url)
      (if (string-match "file:\\(.*\\)" file)
					(setq file (url-match file 1)))))

		(setq file (expand-file-name file (url-basepath url-current-file)))
		(list user server file dest)))


(defun w3-build-continuation ()
  "Build a series of functions to be run on this file"
  (with-current-buffer url-working-buffer
    (let ((cont w3-default-continuation)
	  (extn (url-file-extension url-current-file)))
      (if (assoc extn url-uncompressor-alist)
	  (setq extn (url-file-extension
		      (substring url-current-file 0 (- (length extn))))))
      (if w3-source
	  (setq url-current-mime-viewer '(("viewer" . w3-source))))
      (if (not url-current-mime-viewer)
	  (setq url-current-mime-viewer
		(mm-mime-info (or url-current-mime-type
				  (mm-extension-to-mime extn)) nil 5)))
      (if url-current-mime-viewer
	  (if url-use-viewers (setq cont (append cont '(w3-pass-to-viewer))))
	(setq cont (append cont (list w3-default-action))))
      cont)))