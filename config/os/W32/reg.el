(put 'reg 'rcsid
 "$Id: reg.el,v 1.3 2003-04-15 16:32:15 cvs Exp $")
(require 'qsave)

(defun reg-canonify (s)	(if (and s (stringp s) (> (length s) 0)) (replace-in-string  "/" "\\" s) ""))

; 
; (reg-query "machine" "software/Technology-X/tw" "wbase")
; (eval-process  "perl" "e:/a/bin/queryval -v machine software/Technology-x/tw wbase")
; (perl-command "queryval" "-v machine software/Technology-x/tw wbase")

(defun reg-query (hive key val) 
  " evaluates to the contents of HIVE stored in KEY"

  (interactive (list 
		(completing-read "hive: " '(("machine" "machine") ("users" "users") ("user" "user") ("config" "config")) nil t)
		(read-string "key: ")
		(read-string "value: ")))

  (perl-command
   "queryvalue" 
   "-v" 
   hive
   key
   val
   )
  )


(defun complete-key (prompt hive key)
  "build a completion list in HIVE from subkeys of KEY"
  (let* ((v (mapcar (enumerate-keys hive key) 'list))
	 (subkey (completing-read prompt v)))
    (if subkey
	 (complete-key
	  (format "%s: " subkey)
	  hive
	  (if key (concat key "\\" subkey) subkey))
	 key)
    )
  )

; (reg-query "machine" "" "boo")

(defun complete-hive (prompt)
  (completing-read prompt '(("machine") ("users") ("current user") ("config")) 
		   nil
		   t)
  )

(defun browse-to-key (hive &optional prompt)
  (interactive (list 
		(complete-hive "Hive: ")
		))
  (complete-key (or prompt "key: ") hive "")
  )

; (setq k (browse-to-key "machine"))

(defun reg-dump (hive &optional key)
  (interactive (list
		(complete-hive "Hive: ")))

  (let ((key (cond (key key)
		   ((interactive-p) (browse-to-key hive "Key: "))))
	(s (perl-command
	    "regdmp" "-v" hive (reg-canonify key)))
	(b (zap-buffer "*Perl*")))		
    (insert s)
    (not-modified)
    (setq buffer-read-only t)
    (beginning-of-buffer)
    (pop-to-buffer b)
    (reg-view-mode)
    )
  )

;(reg-dump "machine" "software/digitalequipmentcorporation")

;; xxx what is the difference with reg-query?

(defun reg-command (command hive &optional key value)
  (let* ((b (zap-buffer "*reg*"))
	 (s (perl-command command "-v" hive key value)))
    (set-buffer b)
    (insert s)
    (setq
     mode-line-buffer-identification (format "%s/%s *reg*" hive key)
     *reg-query* (list hive key value))
    (pop-to-buffer b)
    (beginning-of-buffer)
    (reg-view-mode)
    )
  )

(defun lsreg (hive key)
  (interactive (list 
		(completing-read "hive: " '(("machine" "machine") ("users" "users") ("user" "user") ("config" "config")) nil t)
		(read-string "key: ")))

  (if (and (not (string* key)) (buffer-exists-p "*reg*"))
      (pop-to-buffer "*reg*")
    (reg-command "lsreg" hive key)
    )
  )

(defun queryvalue (hive key value)
  (interactive "shive: \nskey: \nvalue: ")
  (if (interactive-p)
      (reg-command "queryvalue" hive key value)
    (perl-command  "queryvalue" "-v" hive key value)
    )
  )

;; xxx reg view stuff

(defvar *reg-query* nil " last query as a list: (hive key &optional value)
default hive is machine." )
(make-variable-buffer-local '*reg-query*)

(defvar reg-view-mode-map nil "keymap for hit buffer")

(defun reg-view-mode ()
  "mode for browsing reg-queries
	uses reg-view-mode-map
	runs reg-view-mode-hook
"
  (interactive)
  (use-local-map reg-view-mode-map)
  (setq major-mode 'reg-view-mode)
  (setq mode-name "reg view")
  (run-hooks 'reg-view-mode-hook)
  (set-buffer-modified-p nil)
  (setq buffer-read-only t)
  )

(defvar reg-view-mode-hook nil)
; xxx check that there isn't a bug in x-query-mode in x.el from which this was copied

(defun reg-view-save-search ()
  (qsave-search (current-buffer) (format "%s/%s" (car *reg-query*) (cadr *reg-query*)) *reg-query*)
)
(add-hook 'reg-view-mode-hook 'reg-view-save-search) ; xxx check this

(defun reg-previous-query () (interactive) 
  (let ((q (previous-qsave-search (current-buffer))))
    (if q (setq *reg-query* q)))
  )

(defun reg-next-query  () (interactive)
  (let ((q (next-qsave-search (current-buffer))))
    (if q (setq *reg-query* q)))
  )

(defun reg-setvalue (hive key)
  "this will only work on REG_SZ types"

  (if (save-excursion (beginning-of-line) (looking-at "^[ 	]*[a-zA-Z0-9_-]+ \\[REG_SZ\\]: "))
      (let* ((prompt (trim-leading-white-space (buffer-substring (match-beginning 0) (match-end 0))))
	     (val (buffer-substring (match-end 0) (save-excursion (end-of-line) (point))))
	     (newval (read-string prompt val 'minibuffer-history))
	     (name (car (split prompt)))
	     (p (point))
	     )
	(perl-command  "setvalue" "-v" hive key name newval)
	(reg-refresh)
	(goto-char p)
	t)
    )
  )

(defun reg-descend ()
  (interactive)
  (let ((hive (car *reg-query*))
	(key (cadr *reg-query*))
	(subkey (trim-white-space (bgets))))
    (unless (reg-setvalue hive key)
      (lsreg hive (concat key "/" subkey)))
    )
  )

(defun reg-refresh ()
  (interactive)
  (let ((hive (car *reg-query*))
	(key (cadr *reg-query*)))
      (lsreg hive key)
    )
  )

(defun reg-up () (interactive)
  (lsreg (car *reg-query*) (join (butlast (split (cadr *reg-query*) "/")) "/"))
  )

(if reg-view-mode-map ()
  (setq reg-view-mode-map (make-sparse-keymap))
  (define-key  reg-view-mode-map "\C-m" 'reg-descend)
  (define-key  reg-view-mode-map "\M-p" 'reg-previous-query)
  (define-key  reg-view-mode-map "\M-n" 'reg-next-query)
  (define-key  reg-view-mode-map (vector 'f5) 'reg-refresh)
  (define-key  reg-view-mode-map "\M-u" 'reg-up)
  (loop for x from ?a to ?z do
	(define-key reg-view-mode-map (format "%c" x) `(lambda nil (interactive) (if (re-search-forward (format "^	%c" ,x) nil t) (backward-word 1) (progn (beginning-of-buffer) (if (re-search-forward (format "^	%c" ,x) nil t) (backward-word 1)))))))
  )

(provide 'reg)
