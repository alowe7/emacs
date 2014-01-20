
; functions that shortcut to dscm specific content entries

(defvar *cmdb-url* "http://localhost/pub/cmdb.php?qtype=keywords&cmid=%s")
(defun cmdb (thing)
  (interactive (list (read-string* "search cmdb for (%s): "  (thing-at-point 'word))))
  (cond ((string* thing)
	 (w3m-goto-url
	  (format *cmdb-url* (urlencode thing)))
	 )
	(t (message "no thing")))
  )

; (cmdb "ndoc")
