(require 'xdb)

;
; local xdb query
;
(defun list-db ()
  (let* ((out (zap-buffer-1 "*stdout*"))
	 (err (zap-buffer-1 "*stderr*"))
	 (res (and out err (shell-command "mysql --batch --execute=\"show databases\"" out err))))
    (if
	(= res 0) 
	(progn
	  (set-buffer out)
	  (cdr (split (buffer-string) "
")
	       ))
      (error
       (progn
	 (set-buffer err)
	 (buffer-string)
	 )
       )
      )
    )
  )
; 

(defvar *local-txdb-options* nil)
; e.g. '("-h" "-" "-b" "fx" "-u" "a"))

(defun xlq (s)  (interactive "squery: ")
  "perform a query against a local instance of mysql"
  (let ((*txdb-options* *local-txdb-options*))
    (chomp (x-query s)))
  )

; (xlq "select count(*) from f")
; (xlq "describe f")

;; run query on contents of current buffer (i.e. sql code)

(defun xlb ()
"`buffer-string' is assumed to contain a blob of sql code.  send it to the db pointed to by `*local-txdb-options*'"
 (interactive)
  (let ((*txdb-options* *local-txdb-options*)
	(b (zap-buffer *x*)))
    (insert (x-query (setq *x-query* query)))
    (switch-to-buffer-other-window b)
    (beginning-of-buffer)
    (x-query-mode)
    (run-hooks 'after-x-query-hook)
    (other-window-1)
    )
  )

(defun xlbi ()  (interactive)
"run txdbi on localhost"
  (let ((*txdb-options* *local-txdb-options*))
    (call-interactively 'txdbi)
    )
  )

(defun* xll (arg)
  " lookup a thing matching PAT in links (on db `*local-txdb-options*')

interactive with arg is like calling with :all t

when called from a program, takes optional keywords
 :all BOOL
 :keywords KEYWORDS

if all is nonnil, show matches in name, url or keywords fields 
if KEYWORDS is nonnil, it is a string representing keywords.  matches are like any words in string
"

  (interactive "P")

  (let ((name (read-string "find local links like: ")))

    (let ((*txdb-options* *local-txdb-options*))
      (xl name :all arg)
      )
    )
  )

(defun xall (link url &optional keywords)
  " local version of `xal' 
add a record to x.links"

  (interactive "snew local link: \nsurl: \nskeywords: ")

  (let ((*txdb-options* *local-txdb-options*))
    (xal link url keywords)
    )
  )

