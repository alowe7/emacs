(defvar namedb-query-format
"http://notesweb.pswtech.com/Info/People.nsf/SearchResultsView2?SearchView&Query=%s"
)

(defun w3-lookup-person (name)
	(interactive "sname: ")
	(w3-fetch
	 (format namedb-query-format name))
	)

; (w3-lookup-person "deb")

(defun w3-find-person (name)
  (interactive "sname: ")
  (let ((b1 (zap-buffer " *url-tmp*"))
	(b2 (zap-buffer "*people*")))
    (w3-fetch-raw
     (format namedb-query-format name)
     b1
     )
    (beginning-of-buffer)
    (search-forward "%")
    (beginning-of-line)
  ; (assert (looking-at "<TR>"))
    (call-process-region-1 (point) 
			   (progn (end-of-line) (point))
			   "dsgml"
			   nil 
			   b2)
  ;		(delete-region (mark) (point-max))
    (set-buffer b2)

    (cond ((and (not (get-buffer-window b2)) 
		(= 1 (count-lines (point-min) (point-max))))
	   (message (buffer-string)))
	  (t (pop-to-buffer b2)))
    )
  )

;  (w3-find-person "hua")
;  (w3-find-person "deb")
