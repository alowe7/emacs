(put 'post-helps 'rcsid
 "$Id: post-helps.el,v 1.4 2005-03-11 16:33:38 cvs Exp $")

; build up an alist for howto

; what were you thinking?
(defun howto (thing)
  "yet another howto command."
  (interactive (list (completing-read "howto: " *howto-alist* nil t)))
  (find-file (cadr (assoc thing *howto-alist*))))

(defun matching-read (prompt table &optional predicate require-match)
  "(matching-read PROMPT TABLE PREDICATE REQUIRE-MATCH)
like `completing-read', but filters completions first based on a regexp match anywhere in the key.

if table is empty after filtering, return nil
if table consists of one element, then return that,
otherwise calls `completing-read' on the resulting table. "

  (let* ((table table)
	 (b (zap-buffer "*matches*")))

    (save-window-excursion
      (let (momma daddy)

	(pop-to-buffer b)
	(catch 'bean
	  (while t
	    (erase-buffer)
	    (loop for x in table do (insert (car x) "\n"))
	    (beginning-of-buffer)
	    (unless (string* (setq momma (read-string "completions matching pat: ")))
	      (throw 'bean (buffer-string)))
	    (setq daddy 
		  (loop for x in table 
			when (string-match momma (car x))
			collect x)
		  )
	    (setq table daddy))
	  )
	(kill-buffer b)
	)
      )

    (if (= (length table) 1) (caar table)
      (completing-read prompt table predicate require-match)
      )
    )
  )
; (matching-read "plop: " *howto-alist*)


(defun howto* (thing)
  "yet another howto command."
  (interactive (list (matching-read "howto: " *howto-alist* nil t)))

  (let* (
	 (element (assoc thing *howto-alist*))
	 (file (cadr element))
	 (htaccess (concat (file-name-directory file) ".htaccess")))
    (if (file-exists-p htaccess) 
	(w3m-goto-url (concat "http://localhost" file))
      (find-file file))
    )
  )

; (howto* "howto-smartbridge")
(global-set-key "h" 'howto*)



