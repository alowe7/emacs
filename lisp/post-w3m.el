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


(define-key w3m-mode-map "u" 'w3m-view-parent-page)
(define-key w3m-mode-map "n" 'w3m-view-next-page)
(define-key w3m-mode-map [prior] 'w3m-scroll-down-or-previous-url)
(define-key w3m-mode-map [next] 'w3m-scroll-up-or-next-url)
; (define-key w3m-mode-map [up] 'fb-up)
(define-key w3m-mode-map [left] 'w3m-view-previous-page)

(defun w3m-copy-current-url () (interactive)
  (kill-new w3m-current-url)
  )

(define-key w3m-mode-map "" 'w3m-copy-current-url)

(defun specs () (interactive)
  (w3m-goto-url "http://alowe2/specs.nav")
  )

(defun perlmodhtml (mod) (interactive "smod: ")
(let ((res  (w3m-goto-url (format "http://alowe2/perl/html/site/lib/%s" (replace-in-string "::" "/" mod)) nil nil)))
(debug)
  )
)

(defun phpmanual () (interactive)
  (w3m-goto-url-new-session "http://alowe2/php/manual")
  )
; ( phpmanual)