(put 'phone 'rcsid "$Id: phone.el,v 1.4 2000-10-03 16:44:07 cvs Exp $")

(defvar lastdial nil)

(defun lastdial ()
  "figure out the currently selected dialup entry"
  (let ((index (read
		(eval-process
		 "perl" 
		 "/a/bin/queryval"
		 "-v" "user" 
		 "\"Software\\Microsoft\\RAS Autodial\\Networks\""
		 "NextId"
		 )
		)))

    (setq  lastdial
	   (clean-string (eval-process
			  "perl" 
			  "/a/bin/queryval"
			  "-v" "user" 
			  "\"Software\\Microsoft\\RAS Autodial\\Networks\\NETWORK0\""
			  (format "%d" index)
			  )))
    )
  )

(defvar dial-entries
  (loop for x in (read
		  (eval-process
		   "perl" 
		   "/a/bin/enumkeys"
		   "-l" 
		   "-v" "user" 
		   "\"Software/Microsoft/RAS Autodial/Entries\""
		   )
		  )
	collect (list x)))

(defun phone (&rest args) (interactive)
  (apply 'call-process 
	 (nconc (list
		 (concat *systemroot* "/system32/cmd.exe")
		 nil 0 nil  "/c" 
		 (concat *systemroot* "\\system32\\RASPHONE.EXE")) args)
	 )
  )

(defun dial (entry) 
  (interactive (list 
		(completing-read (format "entry (%s): " (lastdial))
				 dial-entries nil t)))
  (setq lastdial (if (> (length entry) 0) entry lastdial))
  (phone  "-d" (format "\"%s\"" lastdial))

  (if (functionp 'swap-mail-domain)
      (let ((l (all-completions 
		(string-to-word lastdial) *mail-domain-list*)))
	(if (= (length l) 1)
	    (swap-mail-domain (car l)))))
  )

(defun dialstatus () (interactive)
  (phone "-s")
  )

(defun hangup (entry) 
  (interactive (list 
		(completing-read (format "entry (%s): " (lastdial))
				 dial-entries nil t)))
  (setq lastdial (if (> (length entry) 0) entry lastdial))
  (phone  "-h" (format "\"%s\"" lastdial))
  )
