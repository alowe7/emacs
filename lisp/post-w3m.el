(put 'post-w3m 'rcsid
 "$Id: post-w3m.el,v 1.13 2003-12-15 22:46:31 cvs Exp $")
(require 'w3m)

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

(defun w3m-copy-current-url () (interactive)
  (kill-new w3m-current-url)
  )

(defun css-spec () (interactive)
  (w3m-goto-url "http://localhost/usr/share/specs/css2.0/cover.html")
  )

(defun apache-manual () (interactive)
  (w3m-goto-url "http://apache/htdocs/manual/index.html.en")
  )

(defun specs () (interactive)
  (w3m-goto-url "http://localhost/specs.nav")
  )

(defun headlines () (interactive)
  (w3m-goto-url "http://localhost/cgi-bin/headlines.cgi")
  )

(defun emacswiki () (interactive)
  (w3m-goto-url "http://www.emacswiki.org/cgi-bin/wiki")
  )

(defun perlmodhtml (mod) (interactive "smod: ")
(let ((res  (w3m-goto-url (format "http://localhost/perl/html/site/lib/%s" (replace-in-string "::" "/" mod)) nil nil)))
; (debug)
  )
)

(defun phpmanual () (interactive)
  (w3m-goto-url-new-session "http://localhost/php/manual")
  )
; ( phpmanual)

(defun html40 () (interactive)   
  (w3m-goto-url-new-session "http://localhost/usr/share/specs/html4.0/cover.html")
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
  (let ((b (current-buffer))
	(url (format "http://%s%s"  
		     (downcase (hostname))
		     (canonify
		      (if (eq major-mode 'dired-mode)
			  (dired-get-filename) 
			(buffer-file-name)) 0)
		     )))
    (catch 'done
      (unless (or (string-match "\.htm" url) (y-or-n-p (format "visit %s as url? " url)))
	(progn (message "") (throw 'done t)))

      (w3m-goto-url-new-session url)
      (if (> (count-windows) 1) (progn (switch-to-buffer-other-window b) (other-window-1)))
      )
    )
  )


(require 'ctl-slash)

(define-key ctl-/-map (vector (ctl ?/)) 'w3m-goto-current-file-as-url-new-session)
(define-key ctl-/-map "d" 'dired-w3m-find-file)
(define-key ctl-/-map "" 'find-anchor-named)
(define-key ctl-/-map "w" 'w3m-goto-this-url-new-session)
(define-key ctl-/-map "z" 'w3m-copy-current-url)
(define-key ctl-/-map "g" 'w3m-goto-url-new-session)

