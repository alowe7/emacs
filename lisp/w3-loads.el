(provide 'w3-loads)
(addloadpath "$EMACSDIR/site-lisp/w3")
(setq w3-default-homepage "file://d|/p/web/index.html")
(setq url-be-asynchronous t)

(autoload 'w3-preview-this-buffer "w3" "WWW Previewer" t)
(autoload 'w3-follow-url-at-point "w3" "Find document at pt" t)
(autoload 'w3 "w3" "WWW Browser" t)
(autoload 'w3-open-local "w3" "Open local file for WWW browsing" t)
(autoload 'w3-fetch "w3" "Open remote file for WWW browsing" t)
(autoload 'w3-use-hotlist "w3" "Use shortcuts to view WWW docs" t)
(autoload 'w3-show-hotlist "w3" "Use shortcuts to view WWW docs" t)
(autoload 'w3-follow-link "w3" "Follow a hypertext link." t)
(autoload 'w3-batch-fetch "w3" "Batch retrieval of URLs" t)
(autoload 'url-get-url-at-point "url" "Find the url under the cursor" nil)
(autoload 'url-file-attributes  "url" "File attributes of a URL" nil)
(autoload 'url-popup-info "url" "Get info on a URL" t)
(autoload 'url-retrieve   "url" "Retrieve a URL" nil)
(autoload 'url-buffer-visiting "url" "Find buffer visiting a URL." nil)

(autoload 'gopher-dispatch-object "gopher" "Fetch gopher dir" t)


; return ms/vms disk:filename format
(defun canonize-url (url)
	" clean up an url into a directory or filename, if possible.  else return nil"
	(let*
			((base-url (and 
									(string-match "file:\\(//\\)?" url)
									(substring url (match-end 0))))
			 (disk (and base-url 
									(string-match "[a-zA-Z][:|]" base-url) 
									(concat
									 (substring base-url (match-beginning 0) (1- (match-end 0))) ":")
									))
			 (filename (if disk (substring base-url  (match-end 0)) base-url))
			 )
		(and filename (concat disk filename))
		))

;(canonize-url "file://c|/a/p/foo.bar") 
;(canonize-url "file:/a/p/foo.bar") 
;(canonize-url "http://foo.bar") 

(defun my-w3-mode-hook () (interactive) 
  "this function makes sure local files references work relatively"
	(if (boundp 'url)
			(let* ((basepath (canonize-url url))
						 (dir (or (file-directory-p basepath) (file-name-directory basepath))))
				(and  dir (file-directory-p dir) (cd dir)))))

(add-hook 'w3-mode-hooks 'my-w3-mode-hook)
