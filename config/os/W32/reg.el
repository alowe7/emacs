(put 'reg 'rcsid
 "$Id$")
(require 'qsave)

(defun reg-canonify (s) (if (and s (stringp s) (> (length s) 0)) (replace-regexp-in-string "\\\\"  "/" s) ""))

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

;(reg-dump "machine" "software/digitalequipmentcorporation")

; (makunbound '*reg-hivelist*)
(defvar *reg-hivelist* '(
			 ("machine" . "machine")
			 ("HKEY_LOCAL_MACHINE" . "machine")
			 ("HKLM" . "machine")
			 ("users" . "users")
			 ("HKEY_USERS" . "users")
			 ("user" . "user")
			 ("HKCU" . "user")
			 ("config" . "config")
			 ("classes" . "classes")))

;; xxx what is the difference with reg-query?
(defun reg-command (command hive &optional key value)
  (let* ((hive (cdr (assoc hive *reg-hivelist*)))
	 (b (get-buffer-create "*reg*"))
	 (s (perl-command command "-v" hive key value)))
    (set-buffer b)
    (setq buffer-read-only nil)
    (erase-buffer)
    (insert s)
    (setq
     mode-line-buffer-identification (format "%s/%s *reg*" hive key)
     *reg-query* (list hive key value))
    (unless (eq (current-buffer) (get-buffer "*reg*"))
      (pop-to-buffer b))
    (goto-char (point-min))
    (reg-view-mode)
    b)
  )

(defun lsreg (hive &optional key)
  (interactive (list 
		(string* (completing-read "hive: " *reg-hivelist* nil t) (cdar *reg-hivelist*))))

  (let* ((x (cond ((string-match "/" hive)
		   (split hive "/")) 
		  ((string-match "\\\\" hive)
		   (split hive  "\\\\"))))
	 (hive (if x (car x) hive))
	 (key (or key (if x (join (cdr x) "/") 
			(if (interactive-p)
			    (read-string "key: ")))))
  ; if key is empty and *reg* exists, just show it.

	 (b (or  
	     (and (string* key) (reg-command "lsreg" hive key))
	     (buffer-exists-p "*reg*"))))
				       
    (and b
	 (unless (get-buffer-window b)
	   (pop-to-buffer b)))
    )
  )

(defun queryvalue (hive key &optional value)
  (interactive "shive: \nskey: ")
  (let ((value (or value "")))
    (if (interactive-p)
	(reg-command "queryvalue" hive key value)
      (perl-command  "queryvalue" "-v" hive key value)
      )
    )
  )
(fset 'getvalue 'queryvalue)

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

(defun reg-setvalue (hive key name val)
  "this will only work on REG_SZ types"
  (interactive (list 
		(completing-read "hive: " '(("machine" "machine") ("users" "users") ("user" "user") ("config" "config") ("classes" "classes")) nil t)
		(read-string "key: ")
		(read-string "name: ")
		(string* val (read-string "value: "))))

  (perl-command  "setvalue" "-v" hive key name val)
  (perl-command  "queryvalue" "-v" hive (concat key "/" name))
  )
(fset 'setvalue 'reg-setvalue)

(defun reg-descend ()
  " descend into a subkey.  if looking at a REG_SZ value, then prompt for newval."
  (interactive)
  ; (assert (eq major-mode 'reg-view-mode))
  (let* ((hive (car *reg-query*))
	 (key (cadr *reg-query*))
	 (subkey (trim-white-space (bgets)))
	 (name (and	
		(string-match "\\(\\sw+\\) \\[REG_SZ\\]: \\(.*\\)$" subkey)
		(substring subkey (match-beginning 1) (match-end 1))))
	 (val (and name (substring subkey (match-beginning 2) (match-end 2))))
	 (newval (and name (read-string (concat name ": ") val 'minibuffer-history)))
	 (p (point))
	 )

    (if val
	(progn
	  (rplacd (nthcdr 1 *reg-query*) (list name newval))
	  (apply 'reg-setvalue *reg-query*)
	  (reg-refresh)
	  (goto-char p)
	  t)
      (lsreg hive (concat key "/" subkey))
      )
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
