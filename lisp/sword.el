(put 'sword 'rcsid
 "$Id: sword.el,v 1.5 2004-09-03 15:12:33 cvs Exp $")

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

(defvar *sword-window-configuration* nil)
(defvar *sword-buffer* nil)
(defvar *sword-file* nil)
(make-variable-buffer-local '*sword-file*)

(defun kill-sword-buffer ()
  (interactive)
  (set-window-configuration *sword-window-configuration*)
  (kill-buffer *sword-buffer*)
  )

(defun edit-swords (arg)
  (interactive "P")
  (if (and *sword-file* (file-exists-p *sword-file*))
      (let* ((fn (intern *sword-file*))
	     (key (or (and
		       *cache-sword-key*
		       (not arg)
		       (get fn 'key))
		      (comint-read-noecho "key: " t))))
	(decrypt-find-file *sword-file* key)
	)
    )
  )

; (makunbound 'sword-font-lock-keywords)
(defvar sword-font-lock-keywords
  (list (cons "http[s]?://[^\\ 	\n]*" 'font-lock-variable-name-face)
	(cons "\\(1-\\)?\\((?[0-9][0-9][0-9])?\\)\\([- ]*\\)\\([0-9][0-9][0-9]\\)\\([- ]+\\)\\([0-9][0-9][0-9][0-9]\\)"  'font-lock-function-name-face)
	(cons "\\([0-9][0-9][0-9]\\)\\([- ]+\\)\\([0-9][0-9][0-9][0-9]\\)"  'font-lock-function-name-face)
	)
  )

(require 'xdb)

(define-derived-mode sword-mode fundamental-mode "Sword"
  "mode for viewing swords"
  (define-key sword-mode-map "\C-C\C-C" ' kill-sword-buffer)
  (define-key sword-mode-map "\C-C\C-F" 'edit-swords)
  (define-key sword-mode-map "\C-m" 'maybe-browse-url-at-point)
  (setq font-lock-defaults '((sword-font-lock-keywords)))
  (loop for x across "#?:+./-_~!"
	do
	(modify-syntax-entry x "w" sword-mode-syntax-table)
	)
  (run-hooks 'sword-mode-hook)
  )

; (makunbound 'sword-mode-hook)
; (makunbound 'sword-after-insert-hook)
(defvar sword-after-insert-hook 
  '(lambda () 
     (font-lock-mode)
     )
  )

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

    (setq *sword-buffer* (zap-buffer "*swords*" '(sword-mode)))
    (setq *sword-window-configuration* (current-window-configuration))
    (setq *sword-file* swordfile)

    (loop for x in swords
	  do (insert x "\n"))
    
    (run-hooks 'sword-after-insert-hook)

    (if (interactive-p)
	(progn
	  (pop-to-buffer *sword-buffer*)
  ;	      (read-key-sequence "press any key")
  ;	      (message nil)
 
	  (message "C-c C-c to exit")
	  )
      )
    swords)
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



