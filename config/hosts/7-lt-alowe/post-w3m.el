(eval-when-compile (require 'cl))

(require 'long-comment)

(setq w3m-no-proxy-domains '("ows.com" "textron.com"))
(setq w3m-default-display-inline-images t)

(defvar *ows-net-mask* '("172.17.0.0" "255.255.0.0") "list of the form (NET MASK) describing the ows network")
(defvar *ows-proxy* "http://10.232.50.8:8080")

; need hook when ipaddress changes

(defun use-proxy () 
  (setq *use-proxy* (loop for x in (ipaddress) thereis (apply 'isInNet (nconc (list x) *ows-net-mask*))))
  (setq w3m-command-arguments 
	(if *use-proxy* `("-o" ,(format "http_proxy=%s" *ows-proxy*))))
  )

(defvar *use-proxy* (use-proxy))

; (setenv "HTTP_PROXY" (if *use-proxy* *ows-proxy* ""))
; (getenv "HTTP_PROXY")
; (setenv "HTTP_PROXY" nil)

;; from url-helpers
(defvar *url-regexp*  "\\([a-z]+\\)://\\(.*\\)")

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
		    (remove* (cons hostname realm) w3m-process-authinfo-alist :test (lambda (x y) (equal x (cons (car y) (caadr y))))))

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


(add-hook 'dired-mode-hook
          (lambda ()
              (define-key dired-mode-map "\C-xm" 'dired-w3m-find-file)))
(defun dired-w3m-find-file ()
  (interactive)
  (require 'w3m)
  (let ((file (dired-get-filename)))
    (if (y-or-n-p (format "Open 'w3m' %s " (file-name-nondirectory file)))
        (w3m-find-file file))))


;; mainly for docbook style pages
(defun find-anchor-named (pat) (interactive "spat: ")
  (let ((p (point)))
    (goto-char (point-min))
    (loop 
     do (w3m-next-anchor)
     while (and (< (w3m-anchor-sequence) w3m-max-anchor-sequence) (not (looking-at pat)))
     )
    (if (looking-at pat) (w3m-view-this-url) (goto-char p) (message "anchor %s not found" pat))
    )
  )

(defun urlencode (thing) (replace-regexp-in-string " " "%20" thing))
(defun w3m-copy-current-url (&optional arg) 
  (interactive "P")
  (let* ((url 
	  (if
	      (or arg (null (w3m-anchor)))
	      w3m-current-url  (w3m-anchor)))
	 )
    (kill-new url)
    )
  )

(defun w3m-display-current-url () (interactive)
  (message w3m-current-url)
  )

(defun w3m-yank-current-url-other-buffer ()
  "if the other window is showing *w3m*, yank the url it is showing"
  (interactive)
  (let ((u (save-window-excursion (other-window 1) (and (eq major-mode 'w3m-mode)) w3m-current-url)))
    (if u (progn
	    (kill-new u)
	    (push-mark)
	    (insert u))
      (message "other buffer isn't in w3m-mode")
      )
    )
  )


(defun w3m-yank-current-url () (interactive)
  (kill-new w3m-current-url)
  )

; todo -- externalize to xml a/o links?  rationalize with all-docs
; tie in with error handler from man
(defvar *all-docs-alist* nil "alist mapping quick references to urls.  see `all-docs'")
(loop for x in '(
		 ("apache"  "http://localhost/manual/")
		 ("css" "http://localhost/usr/share/specs/css2.0/cover.html")     
		 ("html" "http://localhost/usr/share/specs/html4.0/cover.html")
		 ("forms" "http://localhost/usr/share/specs/html4.0/interact/forms.html")
		 ("" "http://localhost/specs.nav")
  ; ...
		 ("w3m" "http://localhost/u/w3m-0.3/doc/MANUAL.html")
  ; ...
  ; frames 	 ("ant" "/usr/local/lib/ant-1.5.3-1/docs/manual/index.html")
		 ("ant" "/usr/local/lib/ant-1.5.3-1/docs/manual/toc.html")
		 ("xerces" "/xerces/docs/api.html")
		 ("struts" "http://struts.apache.org/api/overview-summary.html")
		 ("beans:" "http://struts.apache.org/api/org/apache/struts/taglib/bean/package-summary.html")
		 ("logic:" "http://struts.apache.org/api/org/apache/struts/taglib/logic/package-summary.html")
		 ("html:" "http://struts.apache.org/api/org/apache/struts/taglib/html/package-summary.html")
		 ("struts examples" "http://j2ee.masslight.com/Chapter5.html")
		 ("struts form examples" "http://javaboutique.internet.com/tutorials/strutsform/")
		 )
      do
      (add-association x '*all-docs-alist* t)
      finally return *all-docs-alist*
      )

(add-association '("tomcat api" "http://localhost:8080/tomcat-docs/catalina/docs/api/overview-summary.html") '*all-docs-alist* t)

;(pop *all-docs-alist*)

(defun head (url)
  "send a http head to URL.  return nil if there's an error, t otherwise"
  (let* ((l (split (perl-command "get" "-m" "head" "-t" "1" url)))
	 (stat (read (car l))))
    (= 200 stat)
    )
  )
; (head "http://localhost/")
; (head "http://localhost/notthere")

;; todo -- catch exit handler and offer to save updated specsvec
(defun add-to-docs-helper-alist (name)
  (interactive "sname: ")
  (add-to-list '*all-docs-alist* (list name w3m-current-url))
  )

(defun all-docs-helper (thing) 
  (let ((x (assoc thing *all-docs-alist*)))
    (if x (cadr x)
      (let* ((l (ff (format "*doc*%s.html" thing)))
	     (it (if l 
		     (completing-read (format "%d matches for %s: " (length l) thing) (mapcar (lambda (x) (list x x)) l))
		   thing
		   )))
	it)
      )
    )
  )
; (all-docs-helper "ant")
; (all-docs-helper "beans")
; (all-docs-helper "xerces")
; (all-docs-helper "w3m")
; (all-docs-helper "HttpSession")

(defun all-docs (arg) 
  "shortcut to documentation defined in `*all-docs-alist*'"
  (interactive "P")
  (let* ((thing 
	  (string*
	   (completing-read
	    (format "find doc (%s): " (indicated-word))
	    *all-docs-alist* nil t)
	   (indicated-word)))
	 (url (string* (cadr (assoc thing *all-docs-alist*))
		       (all-docs-helper thing)))
	 (navigator (if arg 'w3m-goto-url-new-session 'w3m-goto-url)))

    (if 
	(catch 'err  
	  (cond 
	   ((not (string* url)) (throw 'err t))
	   ((string-match *url-regexp* url) (funcall navigator url))
  ; allow specs relative to localhost
	   ((head (concat "http://localhost" url)) (funcall navigator (concat "http://localhost" url)))
	   ((file-exists-p url) (aexec url))
	   ((file-exists-p thing) (aexec thing))
	   (t (throw 'err t))
	   )
	  )
	(message "no help for %s" thing)
      )
    )
  )

; for some reason this is easier to remember
(fset 'specs 'all-docs)

(defun emacswiki () (interactive)
  (w3m-goto-url "http://www.emacswiki.org/cgi-bin/wiki")
  )

(defun modperlmanual () (interactive)
  (w3m-goto-url-new-session "http://localhost/usr/local/lib/mod_perl-1.99_08/docs/")
  )

(defun phpmanual () (interactive)
  (w3m-goto-url-new-session  "http://localhost/php-manual/")
  )
; (phpmanual)
; xxx todo generalize this ala bookmarks
(defun html40 () (interactive)   
  (w3m-goto-url-new-session "http://localhost/usr/share/specs/html4.0/cover.html")
  )
(defun html-forms () (interactive)   
  (w3m-goto-url-new-session  "http://localhost/usr/share/specs/html4.0/interact/forms.html")
  )


(defun w3m-goto-this-url-new-session () (interactive)
  (let ((b (current-buffer)))
    (if (w3m-anchor) (w3m-goto-url-new-session (w3m-anchor))
      (call-interactively 'w3m-goto-this-url-new-session)
      )
    (if (< (count-windows) 2)
	(split-window-vertically))
    (progn (switch-to-buffer-other-window b) (other-window-1))
    )
  )

(require 'ctl-ret)

(defun my-w3m-mode-hook () 
  (defvar w3m-mode-syntax-table (make-syntax-table (syntax-table)))
  (modify-syntax-entry ?< "("  w3m-mode-syntax-table)
  (modify-syntax-entry ?> ")"  w3m-mode-syntax-table)
  (set-syntax-table w3m-mode-syntax-table)
  )

(add-hook 'w3m-mode-hook 'my-w3m-mode-hook)

; ugh ?2 ?
(define-key ctl-RET-map "w" 'w3m)

(define-key w3m-mode-map "o" 'w3m-goto-this-url-new-session)
(define-key w3m-mode-map "/" 'find-anchor-named)
(define-key w3m-mode-map "U" (lambda () (interactive) (find-anchor-named "Up")))
(define-key w3m-mode-map "N" (lambda () (interactive) (find-anchor-named "Next")))
(define-key w3m-mode-map "P" (lambda () (interactive) (find-anchor-named "Prev")))

(define-key w3m-mode-map [prior] 'w3m-scroll-down-or-previous-url)
(define-key w3m-mode-map [next] 'w3m-scroll-up-or-next-url)
; (define-key w3m-mode-map [up] 'fb-up)
(define-key w3m-mode-map [\M-left] 'w3m-view-previous-page)
(define-key w3m-mode-map [\M-right] 'w3m-view-next-page)
(define-key w3m-mode-map "u" 'w3m-view-parent-page)
(define-key w3m-mode-map "n" 'w3m-view-next-page)
(define-key w3m-mode-map "b" 'w3m-view-previous-page)

(define-key w3m-mode-map "" 'w3m-copy-current-url)


(defun w3m-goto-current-file-as-url-new-session () (interactive)
  (let* (
	 (fn (cond ((eq major-mode 'dired-mode)
		    (dired-get-filename))
		   ((eq major-mode 'fb-mode)
		    (fb-indicated-file))
		   (t (buffer-file-name))
		   ))
	 (url (and fn (format "http://%s%s"  
			      (downcase (hostname))
			      (canonify fn 0)
			      )))
	 )
    (if fn
	(catch 'done
	  (unless (or (string-match "\.htm" url) (y-or-n-p (format "visit %s as url? " url)))
	    (progn (message "") (throw 'done t)))

	  (w3m-goto-url-new-session url)

	  )
      (message "can't figure out filename")
      )
    )
  )

(defun w3m-force-refresh ()
  "remove current url from cache and force a reload"
  (interactive)
  (w3m-cache-remove w3m-current-url)
  (w3m-reload-this-page)
  )

(defun my-w3m-goto-url (arg)
  "frontend to w3m-goto-url that creates a new session with interactive ARG.
"
  (interactive "P")

  (call-interactively
   (if arg 'w3m-goto-url-new-session 'w3m-goto-url)
   )
  )

(require 'ctl-slash)

(define-key ctl-/-map (vector (ctl ?/)) 'w3m-goto-current-file-as-url-new-session)
(define-key ctl-/-map "d" 'dired-w3m-find-file)
(define-key ctl-/-map "" 'find-anchor-named)
(define-key ctl-/-map "w" 'my-w3m-goto-url)
(define-key ctl-/-map "" 'w3m-goto-this-url-new-session)
(define-key ctl-/-map "z" 'w3m-copy-current-url)
; 
(define-key ctl-/-map "r" ' w3m-force-refresh)
;
(define-key ctl-/-map "y" 'w3m-yank-current-url-other-buffer)
(define-key  w3m-mode-map "y" 'w3m-yank-current-url)
;
(define-key w3m-mode-map "i" 'w3m-display-current-url)

(defun w3m-view-file-url (&optional s)
  "view current buffer's file via w3m.  interactive with arg, prompt for file name"
  (interactive "P")

  (let ((f 
	 (expand-file-name (cond ((null s)
				  (cond ((eq major-mode 'dired-mode)  (dired-get-filename))))
				 (t s)))))
    (w3m-goto-url f) 
    )
  )

(mapc (lambda (x) (add-file-association x 'w3m-view-file-url)) '("html" "htm"))

(add-hook 'dired-mode-hook
	  (lambda ()
	     (define-key dired-mode-map "W" (lambda () (interactive) (w3m-goto-url (format "http://localhost/%s" (unix-canonify (dired-get-filename) 0)))))
	     ))

(setq w3m-icon-directory "/usr/share/pixmaps/w3m-el")

(require 'ctl-slash)
(define-key ctl-/-map "s" 'all-docs)

;; w3m-om overrides some standard lisp in an incompatible way.
(load-library "rect")

(defvar *firefox-bin* "c:/Program Files/Mozilla Firefox/firefox.exe")

(defun w3m-w32-browser-with-firefox (url)
  (let ((proc (start-process "w3m-w32-browser-with-firefox"
			     (current-buffer)
			     *firefox-bin*
			     (if (w3m-url-local-p url)
				 (w3m-url-to-file-name url)
			       url))))
    (set-process-filter proc 'ignore)
    (set-process-sentinel proc 'ignore)))

;; todo -- support inline images using  `create-image', `defimage' and `find-image' 
(setq w3m-content-type-alist
      `(("text/plain" "\\.\\(txt\\|tex\\|el\\)" nil)
	("text/html" "\\.s?html?$"  w3m-w32-browser-with-firefox)
	("image/jpeg" "\\.jpe?g$"
	 (,*firefox-bin* file))
	("image/png" "\\.png$"
	 (,*firefox-bin* file))
	("image/gif" "\\.gif$"
	 (,*firefox-bin* file))
	("image/tiff" "\\.tif?f$"
	 (,*firefox-bin* file))
	("image/x-xwd" "\\.xwd$"
	 (,*firefox-bin* file))
	("image/x-xbm" "\\.xbm$"
	 (,*firefox-bin* file))
	("image/x-xpm" "\\.xpm$"
	 (,*firefox-bin* file))
	("image/x-bmp" "\\.bmp$"
	 (,*firefox-bin* file))
	("video/mpeg" "\\.mpe?g$"
	 (,*firefox-bin* file))
	("video/quicktime" "\\.mov$"
	 (,*firefox-bin* file))
	("application/postscript" "\\.\\(ps\\|eps\\)$"
	 (,*firefox-bin* file))
	("application/pdf" "\\.pdf$"
	 (,*firefox-bin* file))))

(add-association '("html" . w3m-html-view) 'file-assoc-list t)

(defun w3m-html-view (&optional fn) 
  "view specified file or buffer as html"
  (interactive)
  (let* ((fn (expand-file-name (or fn (buffer-file-name))))
	 (default-directory (file-name-directory fn))
	 (w3m-pop-up-frames t)
	 (w3m-use-tab-menubar nil)
	 (w3m-use-tab nil)
	 (w3m-popup-frame-parameters default-frame-alist)
	 )

    (w3m fn t)
    )
  )

; fix problem on windows
(defun w3m-expand-file-name (file directory)
  (let ((f (expand-file-name file directory)))
    (if (string-match "^[a-zA-Z]:" f)  (substring f (match-end 0)) f)
    )
  )

;; emacs-w3m-1.4.5/w3m.el defines some obsolete CYGWIN options in w3m-command-environment
(setq w3m-command-environment (delete* "CYGWIN" w3m-command-environment :test (lambda (x y) (string= x (car y)))))
