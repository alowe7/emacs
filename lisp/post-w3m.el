(put 'post-w3m 'rcsid
 "$Id: post-w3m.el,v 1.33 2005-08-05 20:44:45 cvs Exp $")
(require 'w3m)

;; from url-helpers
(defvar *url-regexp*  "^\\([a-z]+\\)://\\(.*\\)")

;; from emacs-w3m/TIPS
;; 
;; ** browse-url
;; 
;;    By following setting, "C-x m" on URL like string calls emacs-w3m. And
;;    you can preview HTML file by "C-c C-v" on html-mode which is
;;    distributed with Emacs21.
;; 

(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xm" 'browse-url-at-point)

;; xxx todo -- use i.e.

;;   If you want to use the other browser than emacs-w3m when "C-x m" is
;;   typed in w3m-mode buffers, you can put the following setting to your
;;   ~/.emacs.

(defadvice browse-url-at-point
  (around change-browse-url-browser-function activate compile)
  (let ((browse-url-browser-function
         (if (eq major-mode 'w3m-mode)
             'browse-url-netscape
           'w3m-browse-url)))
    ad-do-it))



;; ** dired
;; 
;;    By "C-x m" on a html file in dired-mode, you can open it by
;;    emacs-w3m.

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
    (beginning-of-buffer)
    (loop 
     do (w3m-next-anchor)
     while (and (< (w3m-anchor-sequence) w3m-max-anchor-sequence) (not (looking-at pat)))
     )
    (if (looking-at pat) (w3m-view-this-url) (goto-char p) (message "anchor %s not found" pat))
    )
  )

(defun w3m-copy-current-url (&optional arg) (interactive "P")
  (kill-new (if (and arg (w3m-anchor)) (w3m-anchor) w3m-current-url))
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
		 ("apache"  "http://alowe1/manual/")
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
		     (completing-read (format "%d matches for %s: " (length l) thing) (mapcar '(lambda (x) (list x x)) l))
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
  (w3m-goto-url-new-session "http://alowe1/usr/local/lib/mod_perl-1.99_08/docs/")
  )

(defun phpmanual () (interactive)
  (w3m-goto-url-new-session "http://localhost/php/manual")
  )
; ( phpmanual)
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
    (if (> (count-windows) 1) (progn (switch-to-buffer-other-window b) (other-window-1)))
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

(define-key w3m-mode-map "G" 'w3m-goto-this-url-new-session)
(define-key w3m-mode-map "/" 'find-anchor-named)
(define-key w3m-mode-map "U" '(lambda () (interactive) (find-anchor-named "Up")))
(define-key w3m-mode-map "N" '(lambda () (interactive) (find-anchor-named "Next")))
(define-key w3m-mode-map "P" '(lambda () (interactive) (find-anchor-named "Prev")))

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
	  (if (> (count-windows) 1) (progn (switch-to-buffer-other-window b) (other-window-1)))
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

(require 'ctl-slash)

(define-key ctl-/-map (vector (ctl ?/)) 'w3m-goto-current-file-as-url-new-session)
(define-key ctl-/-map "d" 'dired-w3m-find-file)
(define-key ctl-/-map "" 'find-anchor-named)
(define-key ctl-/-map "w" 'w3m-goto-url)
(define-key ctl-/-map "" 'w3m-goto-this-url-new-session)
(define-key ctl-/-map "z" 'w3m-copy-current-url)
(define-key ctl-/-map "g" 'w3m-goto-url-new-session)
; 
(define-key ctl-/-map "r" ' w3m-force-refresh)
;
(define-key ctl-/-map "y" 'w3m-yank-current-url-other-buffer)
(define-key  w3m-mode-map "y" 'w3m-yank-current-url)
;
(define-key w3m-mode-map "i" 'w3m-display-current-url)

; xxx finish this...
(defun w3m-view-file-url (f)
  (shell-command 
   (format "w3m %s" (gsn f)))
  )
(mapcar '(lambda (x) (add-file-association x 'w3m-view-file-url)) '("html" "htm"))


(add-hook 'dired-mode-hook
	  '(lambda ()
	     (define-key dired-mode-map "W" (lambda () (interactive) (w3m-goto-url (format "http://alowe1/%s" (unix-canonify (dired-get-filename) 0)))))
	     ))

