(put 'sword 'rcsid
 "$Id: sword.el,v 1.4 2002-05-08 15:35:21 cvs Exp $")

(require 'comint)

(defvar *key-program* "key")
(defvar *default-swordfile* "~/.private/swords")

(defvar *cache-sword-key* t 
  "if set, keys are cached on the 'key property of the interned filename.
see `get-key' and `sword'")


(defun get-key (filename &optional force)

  "return a key for FILENAME.  key is acquired using
read-noecho from the keyboard, if optional FORCE is set.
otherwise if `*cache-sword-key*' is set and a key is cached, use that.
"

  (let* ((fn (intern filename))
	 (key (or (and
		   *cache-sword-key*
		   (not force)
		   (get fn 'key))
		  (comint-read-noecho "key: " t))))
    (if *cache-sword-key*
	(put fn 'key key)
      )
    key)
  )

; (get-key *default-swordfile*)

(defun sword (arg)
  "suck an encrypted password out of a swordfile.
if prefix arg is set, prompt for filename and key, else use the default `*default-swordfile*'.
if `*cache-sword-key*' is set and a key is cached, return it, otherwise use read-noecho.
"
  (interactive "P")

  (let* ((swordfile
	  (if arg
	      (read-file-name "file: " 
			      (file-name-directory *default-swordfile*)
			      *default-swordfile*)
	    *default-swordfile*))
	 (word (read-string "word: "))
	 (key 
	  (get-key swordfile arg))
	 (b (zap-buffer " *keyout*"))
	 (result (call-process
		  *key-program* nil b t "-d" "-k" key 
		  (expand-file-name swordfile)))
	 (swords (save-excursion 
		   (set-buffer b)
		   (loop for x in 
			 (split (buffer-string) "
")
			 when (string-match word x)
			 collect x))))
    (kill-buffer b)
    (if (interactive-p)
	(if (> (length swords) 1) 
	    (let ((b (zap-buffer "*swords*"))
		  (c (current-window-configuration)))
	      (loop for x in swords
		    do (insert x "\n"))
	      
	      (pop-to-buffer b)
	      (read-key-sequence "press any key")
	      (message nil)
	      (set-window-configuration c)
	      (kill-buffer b)
	      )
	  (message (car swords)))
      swords)
    )
  )
; (sword "aa.com")

(defun swords (arg) 
  (interactive "P")
  (let* ((swordfile
	 (if arg
	     (read-file-name "file: " 
			     (file-name-directory *default-swordfile*)
			     *default-swordfile*)
	   *default-swordfile*))
	(key 
	 (get-key swordfile arg)))
    (decrypt-find-file 
     swordfile
     key)
    )
  )

; (swords)



