(put 'w3-helpers 'rcsid "$Id: w3-helpers.el,v 1.4 2000-10-03 16:44:08 cvs Exp $")
(require  'html-format)

; we want this file to load after w3, because it contains overloads
(require 'w3-vars)

(set-default 'url-be-asynchronous nil)
(setq w3-continuation '(url-clean-text)
      w3-default-continuation  '(url-clean-text)
      url-automatic-cacheing t
      w3-delimit-links nil
      w3-last-save-dir nil	
      w3-reuse-buffers 'always
      w3-mutable-windows t
      w3-auto-image-alt nil
      w3-mutable-windows t
      url-keep-history t)

(defun w3-dos-print-this-url (&optional url format)
  "Print out the current document "
  (interactive)
  (if (or (not (interactive-p)) (y-or-n-p (format "print %s " (or url (url-view-url)))))
      (let ((v (or url (url-view-url t))))
	(and v
	     (message "printing %s" v)
	     (dos-print-region (point-min) (point-max)))
	)
    (and (interactive-p) (message ""))
    )
  )

; I didn't like the default cache naming convention
(setq url-temporary-directory "e:/cache")

(defun url-create-cached-filename (url)
  "Return a filename in the local cache for file FNAME on host HOSTNAME"
  (setq url (url-strip-proxy url))
  (let (protocol hostname fname data grok)
    (if (string-match url-nonrelative-link url)
	(setq protocol (url-match url 1)
	      grok (intern (concat "url-grok-" protocol "-href"))))
    (if (and grok (fboundp grok))
	(setq data (funcall grok url)))
    (if data
	(cond
	 ((or (string= protocol "ftp") (string= protocol "file"))
	  (setq hostname (nth 1 data)
		fname (nth 2 data)))
	 (t
	  (setq hostname (nth 0 data)
		fname (nth 2 data)))))
    (let ((slash nil))
      (setq fname
	    (mapconcat
	     (function
	      (lambda (x)
		(cond
		 ((and (= ?/ x) slash)
		  (setq slash nil)
		  "%2F")
		 ((= ?/ x)
		  (setq slash t)
		  "/")
		 (t
		  (setq slash nil)
		  (char-to-string x))))) fname "")))
		    
    (if (not data)
	nil
      (setq fname (mapconcat
		   (function (lambda (x)
			       (if (= x ?~) "" (char-to-string x)))) fname ""))
      (expand-file-name (cond
			 ((string= "" fname) url-directory-index-file)
			 ((string= "/" fname) url-directory-index-file)
			 ((= (string-to-char fname) ?/)
			  (if (string= (substring fname -1 nil) "/")
			      (concat fname url-directory-index-file)
			    (substring fname 1 nil)))
			 (t
			  (if (string= (substring fname -1 nil) "/")
			      url-directory-index-file
			    fname)))
			(expand-file-name
			 (mapconcat 'identity
				    (cons (or protocol "file")
					  (nreverse
					   (mm-string-to-tokens
					    (or hostname "localhost") ?.)))
				    "/")
			 url-temporary-directory)))))

(defun web-save-directory (&optional d)
  "set or get directory for saving urls"
  (if d (setq w3-last-save-dir d))
  (or w3-last-save-dir
      (and (fboundp (quote find-world-directory))
	   (find-world-directory (current-world))
	   )
      default-directory
      )
  )

;
; to save a bunch of files known to be in a given location, and
; enumerated in a local file called filelist, use something like:
;
; (dolist (x (catfile "filelist"))
;  (web-save-url (concat location x)))
;
(defun web-save-url (url &optional file buffer)
  "visit URL and save unprocessed url into FILE.
the filename to save is taken from the basename of the URL and the value of (web-save-directory)
unless  FILE is specified.
url-working-buffer is used for the scratch buffer unless BUFFER is specified
"
  (interactive "Surl: ")
  (url-retrieve url)
  (set-buffer (or buffer url-working-buffer))
  (setq buffer-file-type t) ; indicates binary file
  (write-file
   (expand-file-name (or file (file-name-nondirectory url))
		     (web-save-directory))
   )
  (kill-buffer (current-buffer))
  )

(defun w3-forward-link (p &optional noerror)
  "Go forward 1 link"
  (interactive "p")
  (setq p (or p 1))
  (catch 'done
    (if (< p 0)
	(w3-back-link (- p))
      (if (/= p 1) (w3-forward-link (1- p) noerror))
      (cond
       ((= (point-max) (next-overlay-change (point)))
	(if noerror (throw 'done nil)
	  (error "No more links.")))
       (t
	(let ((save-pos (point))
	      (x (next-overlay-change (point)))
	      (y (point-max)))
	  (if (w3-overlays-at (point))
	      (progn
		(goto-char (overlay-end (car (w3-overlays-at (point)))))
		(setq x (next-overlay-change (point)))))
	  (while (and (not (w3-overlays-at x)) (/= x y))
	    (setq x (next-overlay-change x)))
	  (if (= x y)
	      (progn
		(goto-char save-pos)
		(if noerror 
		    (throw 'done nil)
		  (error "No more links.")))
	    (goto-char x)
	    (cond
	     ((eq w3-echo-link 'url) (w3-view-this-url))
	     ((and (eq w3-echo-link 'text)
		   (setq x (w3-overlays-at x)))
	      (message "%s" (buffer-substring (overlay-start (car x))
					      (overlay-end (car x)))))
	     (t nil)))))))))

(defvar w3-fill-column 95)
(make-variable-buffer-local 'w3-fill-column)

(defun w3-fill-column ()
  (min (- (window-width) w3-right-border) w3-fill-column))

(setq w3-strict-width nil)


(defun w3-save-region (from to &optional recurse) 
  "follows all links in current url between (point) and (mark).
should be preceeded by a call to w3-fetch to retrieve the current url.
from a program, specify arguments FROM and TO
does not recurse unless optional RECURSE is set.
"
  (interactive "r")
  (let (url-be-asynchronous 
	force
	(url-inhibit-uncompression t)
	(w3-dump-to-disk t)
	(b (current-buffer))
	(p (point))
	)

    (web-save-directory
     (read-file-name "Directory to save in: " (web-save-directory) (web-save-directory)))

    (goto-char from)
    (let ((ext (or (w3-zone-at (point)) 
		   (progn 
		     (w3-forward-link 1 t)
		     (w3-zone-at (point))))))
      (while (and ext (< (point) to) (not (eobp)))
	(let ((dat (and ext (w3-zone-data ext))))
	  (cond
	   ((null dat) (message "No link, form entry, or image at point."))
	   ((and (eq (car dat) 'w3)
		 (stringp (nth 2 dat))
		 (progn
		   (web-save-url (or (nth 1 dat) (file-name-nondirectory (nth 2 dat))))
		   (setq force t)
		   ))))

	  (pop-to-buffer b)
	  )
	(setq ext (progn 
		    (w3-forward-link 1 t)
		    (w3-zone-at (point))))
	)
      (goto-char p)
      )
    )
  )


(defun w3-spin-region (from to &optional recurse) 
  "follows all links in current url between (point) and (mark).
should be preceeded by a call to w3-fetch to retrieve the current url.
from a program, specify arguments FROM and TO
does not recurse unless optional RECURSE is set.
"
  (interactive "r")
  (let (url-be-asynchronous 
	(url-inhibit-uncompression t)
	(w3-dump-to-disk nil)
	(b (current-buffer))
	(p (point))
	)

  ;		(web-save-directory
  ;		 (read-file-name "Directory to save in: " (web-save-directory) (web-save-directory)))

    (goto-char from)
    (let ((ext (or (w3-zone-at (point)) 
		   (progn 
		     (w3-forward-link 1 t)
		     (w3-zone-at (point))))))
      (while 
	  (and ext (< (point) to) (not (eobp)))
	(let ((dat (and ext (w3-zone-data ext))))
	  (cond
	   ((null dat) (message "No link, form entry, or image at point."))
	   ((and (eq (car dat) 'w3)
		 (stringp (nth 2 dat)))
	    (w3-fetch (url-maybe-relative
		       (or (nth 1 dat)
			   (file-name-nondirectory (nth 2 dat))))))
	   )

	  (set-buffer b)
	  (goto-char p)
	  (setq ext (progn 
		      (w3-forward-link 1 t)
		      (w3-zone-at (point))))

	  )
	)
      )
    )
  )


(defun collect-w3-buffers () 
  (collect-buffers 'w3-mode)
  )


(defun list-w3-buffers () 
  "Create and return a buffer with a list of names of w3 buffers."
  (interactive)
  (list-buffers nil (collect-w3-buffers))
  )

(defun dired-w3-file ()
  "run rmail on specified file"
  (interactive)
  (if (not w3-setup-done) (w3-do-setup))
  (let* ((f (dired-get-filename))
	 (b (file-name-sans-extension (file-name-nondirectory f))))
    (w3-fetch-raw
     (concat "file:" f)
     (zap-buffer b))
    (set-buffer b)
    (w3-parse-partial (buffer-string) " *w3 helper*")))


(defun w3-spin-web (url)
  "retrieve specified url and all its links
see w3-spin-region"
  (interactive "Surl: ")
  (w3-fetch url)
  (w3-spin-region (point-min) (point-max))
  )

(defun w3-fetch (&optional url)
  "Retrieve a document over the World Wide Web.
The World Wide Web is a global hypertext system started by CERN in
Switzerland in 1991.

The document should be specified by its fully specified
Uniform Resource Locator.  The document will be parsed, printed, or
passed to an external viewer as appropriate.  Variable
`mm-mime-info' specifies viewers for particular file types."
  (interactive (list
		(progn
		  (if (not w3-setup-done) (w3-do-setup))
		  (let ((completion-ignore-case t)
			(default
			  (if (eq major-mode 'w3-mode)
			      (if (and current-prefix-arg (w3-view-this-url t))
				  (w3-view-this-url t)
				(url-view-url t))
			    (url-get-url-at-point))))
		    (completing-read "URL: "
				     url-global-history-completion-list
				     nil nil default)))))


  (if (boundp 'w3-working-buffer)
      (setq w3-working-buffer url-working-buffer))
  (if (equal url "") (error "No document specified!"))
  ;; In the common case, this is probably cheaper than searching.
  (while (= (string-to-char url) ? )
    (setq url (substring url 1)))
  (if (= (string-to-char url) ?#)
      (w3-relative-link url)

    (let ((x (url-view-url t))
	  (lastbuf (current-buffer))
	  (buf (url-buffer-visiting url)))
      (if (not w3-setup-done) (w3-do-setup))
      (if (and x (string= "file:nil" x)) (setq x nil))
      (if (or (not buf)
	      (cond
	       ((not (equal (downcase (or url-request-method "GET")) "get")) t)
	       ((memq w3-reuse-buffers '(no never reload)) t)
	       ((memq w3-reuse-buffers '(yes reuse always)) nil)
	       (t
		(if (and w3-reuse-buffers (not (eq w3-reuse-buffers 'ask)))
		    (progn
		      (ding)
		      (message
		       "Warning: Invalid value for variable w3-reuse-buffers: %s"
		       (prin1-to-string w3-reuse-buffers))
		      (sit-for 2)))
		(not (funcall url-confirmation-func
			      (format "Reuse URL in buffer %s? "
				      (buffer-name buf)))))))

	  (let ((cached (url-retrieve url)))
	    (w3-add-urls-to-history x url)
	    (if w3-track-last-buffer
		(setq w3-last-buffer (get-buffer url-working-buffer)))
	    (if (get-buffer url-working-buffer)
		(cond
		 ((and url-be-asynchronous (string-match "^http:" url)
		       (not cached))
		  (save-excursion
		    (set-buffer url-working-buffer)
		    (setq w3-current-last-buffer lastbuf)))
		 (t (w3-sentinel lastbuf)))))
	(if w3-track-last-buffer 
	    (setq w3-last-buffer buf))
	(switch-to-buffer buf)
	(if (string-match "#\\(.*\\)" url)
	    (w3-find-specific-link (url-match url 1)))
	(message "Reusing URL.  To reload, type %s."
		 (substitute-command-keys "\\[w3-reload-document]"))))))

(defun w3-fetch-raw (url &optional buffer)
  "synchronously fetch URL into url-working buffer and pop to that
buffer, does no formatting. with optional BUFFER, uses that buffer to format"
  (interactive "surl: ")
  (let  ((url-working-buffer (or buffer url-working-buffer))
	 url-be-asynchronous)
    (url-retrieve url)

    (if (interactive-p) (progn
			  (pop-to-buffer url-working-buffer)
			  (html-mode)))
    )
  )


(defun w3-empty-cache ()
  (interactive)
  "empty cache directory and all subdirectories"
  (if
      (or (not (interactive-p))
	  (y-or-n-p (format "emptying directory %s.  are you sure?" url-temporary-directory)))
      (empty-dir url-temporary-directory))
  (message "")
  )

(defun empty-dir (dir)
  (dolist (x (get-directory-files dir t))
    (if (not (file-directory-p x))
	(delete-file x)
      (empty-dir x)
      (delete-directory x)))
  )

(defun html-stats (parse)
  " returns a list of html tags on parse stream sorted by occurrence"
  (sort* 
   (let (foo)
     (mapcar '(lambda (x)
		(let ((y (assoc (car x) foo))) 
		  (if y (nconc y (1+ (cdr y)))
		    (push (cons (car x) 1) foo))))
	     parse)
     foo)
   '(lambda (x y) (< (cdr x) (cdr y))))
  )



(defvar w3-last-pat "") 
(defun find-indicated-w3-pat () (interactive)
  (find-w3-pat (indicated-word)))

(defun w3-find-references (pat) 
  (interactive 
   (list 
    (read-string 
     (format "find w3 references to (%s): " 
	     (if (and last-w3-pat (> (length last-w3-pat) 0)) last-w3-pat (indicated-word))
	     ))))

  (if (< (length pat) 1) 
      (setq pat last-w3-pat))
  (if (< (length pat) 1) 
      (setq pat (indicated-word)))
  (setq last-w3-pat  pat)

  (let (bl)
    (loop for x in (collect-w3-buffers) do 
	  (set-buffer x)
	  (goto-char (point-min))
	  (if (re-search-forward pat nil t) (push (list x (trim-white-space (bgets))) bl))
	  )
    (and bl (roll-buffer-list-2 bl))))

(defun roll-buffer-list-2 (l) 
  "like roll buffer list, but only list buffers in list
list may be an a-list, in which case, use the cars, and print the cadrs"
 
  (loop for x in l
	with b = nil
	with m = nil
	do
	(setq b (if (listp x) (car x) x))
	(setq m (if (listp x) (cadr x) ""))
	(set-buffer b)
	(message "%s -- %s" (buffer-name) m)
	(let ((c (read-char)))
	  (cond 
	   ((eq c ?\C-m) (return (pop-to-buffer b)))
	   ((eq c ?o) (return (switch-to-buffer-other-window b)))
	   ((eq c ?/) (return (pop-to-buffer b)))
	   )
	  )))

; added condition-case to ignore  loopy http specs
(defun url-store-in-cache (&optional buff)
  "Store buffer BUFF in the cache"
  (condition-case zz 
      (if (or (not (get-buffer buff))
	      (equal url-current-type "www")
	      (equal url-current-type "news")
	      (equal url-current-type "mailto")
	      (and (url-member url-current-type '("file" "ftp" nil))
		   (not url-current-server))
	      )
	  nil
	(save-excursion
	  (and buff (set-buffer buff))
	  (let* ((fname (url-create-cached-filename (url-view-url t)))
		 (info (mapcar (function (lambda (var)
					   (cons (symbol-name var)
						 (symbol-value var))))
			       '( url-current-content-length
				  url-current-file
				  url-current-isindex
				  url-current-mime-encoding
				  url-current-mime-headers
				  url-current-mime-type
				  url-current-mime-viewer
				  url-current-nntp-server
				  url-current-port
				  url-current-server
				  url-current-type
				  url-current-user
				  )))
		 (dir (file-name-directory fname))
		 (done t))

	    (cond
	     ((and (not (file-exists-p dir)) (fboundp 'make-directory))
	      (make-directory dir t))
	     ((and (file-exists-p dir) (not (file-directory-p dir)))
	      (delete-file dir)
	      (make-directory dir t))
	     (t
	      nil))
	    (setq done (file-directory-p (file-name-directory fname)))
	    (if (not done)
		nil
	      (write-region (point-min) (point-max) fname nil 5)
	      (set-buffer (get-buffer-create " *cache-tmp*"))
	      (erase-buffer)
	      (insert "(setq ")
	      (mapcar
	       (function
		(lambda (x)
		  (insert (car x) " " (cond
				       ((null (setq x (cdr x))) "nil")
				       ((stringp x) (prin1-to-string x))
				       ((listp x) (concat "'" (prin1-to-string x)))
				       ((numberp x) (int-to-string x))
				       (t "'???")) "\n")))
	       info)
	      (insert ")\n")
	      (write-region (point-min) (point-max)
			    (concat (url-file-extension fname t) ".hdr") nil
			    5))
	    )))
    ('file-error (message "error caching file"))
    )
  )

(add-hook 'dired-mode-hook '(lambda () (define-key dired-mode-map "" 'dired-w3-file)))

(defun my-w3-mode-hook () (interactive) 
  "this function makes sure local files references work relatively"
  (if (boundp 'url)
      (let ((dir (and (string-match "file:" url) (substring (url-basepath url) (match-end 0) ))))
	(and dir (file-directory-p dir) (cd dir)))))

(add-hook 'w3-mode-hooks 'my-w3-mode-hook)

(define-key w3-mode-map "" '(lambda () (interactive)
				  (let ((world-bookmarks (concat (getenv "W") "/bookmarks"))
					(url (url-view-url)))
				    (zap-buffer " bkmk")
				    (insert url "
")
				    (append-to-file (point-min) (point-max) world-bookmarks))))

(define-key w3-mode-map "p" 'w3-dos-print-this-url)
(define-key w3-mode-map "f" 'w3-find-references)
(define-key w3-mode-map "L" 'list-w3-buffers)
(define-key w3-mode-map "W" 'find-w3-pat)
(define-key w3-mode-map "w" 'find-indicated-w3-pat)
(define-key w3-mode-map (vector -67108832) '(lambda () (interactive) (roll-buffer-list-1 'w3-mode)))

(global-set-key (vector -67108832) 'roll-buffer-list-1)

(defun w3-go-home () (interactive) (w3-fetch w3-default-homepage))

; save a password association for these urls
(push
 '("www.nytimes.com:80" ("/" . "YWpsb3dlOm93MDJvdw==")) url-basic-auth-storage)


(define-key w3-mode-map "o" 'categorize-page)
(defun  categorize-page () (interactive)
  (let ((url (url-view-url))
	(category (read-string "Category: ")))
    (zap-buffer " url-tmp")
    (insert url "\t" category "\n")
    (append-to-file (point-min) (point-max) "/a/web/categories")))

(defun w3-scroll-up nil (interactive)
  (scroll-up)
  ;	 (recenter)
  )
(defun w3-scroll-down nil (interactive)
  (scroll-down)
  ; (recenter)
  )
 (define-key w3-mode-map "" 'w3-scroll-down)
 (define-key w3-mode-map " " 'w3-scroll-up)



;; 
(defun ihw (arg) (interactive "P")
  "draw some html inside current buffer
finds first region like: <html>...</html>
with arg, parses entire buffer
"

  (let* ((case-fold-search t)
	 (p0 (or
	      (and 
	       (goto-char (point-min))
	       (search-forward "<HTML>" nil t)
	       (match-beginning 0))
	      (and arg (point-min))
	      ))
	 (p1 (and p0 (if (or
			  (search-forward "</HTML>" nil t)
			  (search-forward "</BODY>" nil t))
			 (match-end 0) (point-max))))
	 (s (and p1 (buffer-substring p0 p1)))
	 (f (and s 
		 (save-excursion
		   (let* ((b (and s 
				  (prog1 
				      (set-buffer
				       (get-buffer-create url-working-buffer))
				    (insert s))))
			  (p (and b (w3-preparse-buffer url-working-buffer))))
		     (and p (progn (w3-draw-html p) (buffer-string))))))))

  ;		(if f
  ;				(progn
  ;					(goto-char p0)
  ;					(delete-region p0 p1)
  ;					(insert f)))
    (and f (beginning-of-buffer))
    )
  )


(defun w3-parse-partial (s &optional bn)
  (interactive (list (buffer-substring (point) (mark)) "*w3*"))
  "parse STREAM of html into optional buffer BUFFER-NAME
default buffer is value of url-working-buffer"

  (let* ((w3-draw-done-hooks (cons  'beginning-of-buffer w3-draw-done-hooks))
	 (url-working-buffer (or bn url-working-buffer))
	 (f (and s 
		 (save-excursion
		   (let* ((b (and s 
				  (prog1 
				      (set-buffer
				       (get-buffer-create url-working-buffer))
				    (insert s))))
			  (p (and b (w3-preparse-buffer url-working-buffer))))
		     (and p (progn (w3-draw-html p) (buffer-string)))))
		 )))
  ;		(if f
  ;				(progn
  ;					(goto-char p0)
  ;					(delete-region p0 p1)
  ;					(insert f)))
    )
  )

(defun ihv () (interactive)
  (if (looking-at "http://[a-zA-Z0-9./]*")
      (w3-fetch (buffer-substring (match-beginning 0) (match-end 0)))
    )
  )



(add-hook 'vm-mode-hook '(lambda ()
			   (define-key vm-mode-map "" 'ihw)
			   (define-key vm-mode-map "" 'ihv)
			   ))


(defun w3-hack-parse (f) (interactive "fFile name:")
  (let* ((s (eval-process "dsgml" f))
	 (b (zap-buffer "*w3*"))
	 )
    (insert s)
    (pop-to-buffer b)
    (beginning-of-buffer))
  )

(defun dired-w3-hack-parse () (interactive)
  (w3-hack-parse (dired-get-filename))
  )

;(add-hook 'dired-mode-hook '(lambda () (define-key dired-mode-map "" 'dired-w3-file)))
(add-hook 'dired-mode-hook '(lambda () 
			      (define-key dired-mode-map "" 'dired-w3-hack-parse)
			      (define-key dired-mode-map "" 'dired-w3-file)
			      ))


(autoload 'w3-find-person "w3-people" nil t)
