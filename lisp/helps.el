(put 'helps 'rcsid 
 "$Id$")

(require 'cl)
;(require 'oblists)
(require 'indicate)
(require 'cat-utils)
(require 'directories)

;; various help related functions

(defvar *indent* 0)

(defun name-key ()
  "print out the description of a key read from the keyboard"
  (interactive)
  (key-description (read-key-sequence ""))
  )

; (describe-key (read-key-sequence ""))
; also see (describe-bindings &optional PREFIX)
; (key-description (read-key-sequence "")) 
; (single-key-description (aref (read-key-sequence "") 0))
; (text-char-description 0)
; (key-binding (read-key-sequence ""))
; (let ((major-mode 'isearch-mode)) (describe-mode))

(defun help-for-sparse-map (map)
  (interactive "Smap: ")

  (cond 
   ((listp map)
    (progn
      (loop for i from 0 to *indent* do (insert " "))
      (setq *indent* (1+ *indent*))
      (help-for-sparse-map (car map))
      (help-for-sparse-map (cdr map))
      (setq *indent* (1- *indent*))
      (insert "\n")
      ))
   ((symbolp map)
    (insert (format "%s"  map))
    (help-for-sparse-map map))
   ((numberp map)
    (insert (format "%c " map)))
   )
  )


(defun help-for-map (map) 
  "MAP is a keymap (vector or sparse keymap).
  display a relatively nice wall chart of keys on map.
MAP may be also be a string or symbol name of a map
"
  (interactive (list (intern (completing-read "map: "  (mapcar 'list (symbols-like "-map" t))))))
  (let* ((m (if (symbolp map) (eval map) map)))
    (with-output-to-temp-buffer "*Help*"
      (if (vectorp m)
	  (loop for x across m do
		(insert (format "%c\t%s\n" x (aref m x))))
	(if (and (listp m) (eq (car m) 'keymap))
  ;					(help-for-sparse-map m)
	    (pp (prettify-keymap m))
	  ))
      (goto-char (point-min))
      )
    )
  )
(fset 'describe-map 'help-for-map)

;; examples
(defvar *KeyMaps* '(
		    ( "ctl-x-map" ctl-x-map )
		    ( "help-map" help-map )
		    ( "esc-map" esc-map )
		    ( "global-map" global-map )
		    ( "ESC-O-prefix" (symbol-function 'ESC-O-prefix) )
		    ( "ctl-x-4-prefix" (symbol-function 'ctl-x-4-prefix) )
		    ( "ctl-c-4-prefix" (symbol-function 'ctl-c-4-prefix))
		    ( "ctl-c-map" (symbol-function 'mode-specific-command-prefix) )
		    ( "ctl-z-map" (aref global-map 26) )
		    ( "ctl-z-4-map" (cdr (assoc ?4 (cdr (aref global-map 26)))) )
		    ( "mail-mode-map" mail-mode-map )
		    ( "mail-mode-map ^C " (cdr (cadr mail-mode-map)))
		    ( "meta-\\-prefix" (symbol-function 'meta-\-prefix))
		    ( "ctl-\\-prefix" (symbol-function	'ctl-\-prefix))
		    )
  "default list of maps to show in function wall-chart"
  )

(defun wall-chart (&optional keymap)
  " display a nice chart of the given key map.
    if KEYMAP is specified it is the name of a keymap 
    as a string, symbol or expression 
    if no map is specified, displays value of *KeyMaps*"
  (interactive	(list (completing-read "keymap: " obarray)))
  (if (and (stringp keymap) (eq (length keymap) 0)) (setq keymap nil))

  (let ((b (zap-buffer "*KeyMaps*")))
    (set-buffer b)

    (pop-to-buffer b)
    (goto-char (point-min))
    )
  )

;; (defun wall-chart ()
;;   (interactive)
;;   (let ((b (zap-buffer "*KeyMaps*")))
;;     (set-buffer b)
;;     (insert "\n*** ctl-x-map ***\n")
;;     (help-for-map ctl-x-map b)
;;     (insert "\n*** help-map ***\n")
;;     (help-for-map help-map b)
;;     (insert "\n*** esc-map ***\n")
;;     (help-for-map esc-map b)
;;     (insert "\n*** global-map ***\n")
;;     (help-for-map global-map b)
;;     (insert "\n*** (ESC-O-prefix) i.e. fn keys ***\n");; should have used sparse keymap
;;     (help-for-map (symbol-function 'ESC-O-prefix) b)
;;     (insert "\n*** (ctl-x-4-prefix) ***\n")
;;     (help-for-map (symbol-function 'ctl-x-4-prefix) b)
;;     (insert "\n*** ctl-c-map ***\n")
;;     (help-for-map (symbol-function 'mode-specific-command-prefix) b)
;;     (insert "\n*** ctl-z-map ***\n")
;;     (help-for-map (aref global-map 26) b)
;;     (insert "\n*** ctl-z-4-map ***\n")
;;     (help-for-map (cdr (assoc ?4 (cdr (aref global-map 26)))) b)
;;     (insert "\n*** mail-mode-map ***\n")
;;     (help-for-map mail-mode-map b)
;;     (insert "\n*** mail-mode-map ^C ***\n")
;;     (help-for-map (cdr (cadr mail-mode-map)))
;;     (pop-to-buffer b)
;;     )
;;   )
;; 


(defvar *default-section* "1" "default section if none specified")
(defun fman (topic &optional section)
  (interactive "sManual entry (topic): ")
  (if (and (null section)
	   (string-match "\\`[ \t]*\\([^( \t]+\\)[ \t]*(\\(.+\\))[ \t]*\\'" topic))
      (setq section (substring topic (match-beginning 2)
			       (match-end 2))
	    topic (substring topic (match-beginning 1)
			     (match-end 1)))
    (setq section *default-section*))
  (or (catch 'done
	(dolist (a (catpath "MANPATH")) 
	  (dolist (b '("cat"))
	    (let ((try (format "%s/%s%s/%s.%s" a b section topic section))) 
	      (if (file-exists-p try)
		  (progn 
  ;      (view-file try)
		    (find-file try)
		    (auto-save-mode -1)
  ;      (view-mode)
		    (man-page-mode (string= b "cat")) ;don't format if found in cat dir
		    (throw 'done t)))))))
      (progn
	(message "%s(%s) not found" topic section)
	nil))
  )

(defun indicated-manual-entry (topic &optional section)
  "Display the Unix manual entry for TOPIC.
TOPIC is either the title of the entry, or has the form TITLE(SECTION)
where SECTION is the desired section of the manual, as in `tty(4)'."
  (interactive
   (let* ((top (indicated-word))
	  (enable-recursive-minibuffers t)
	  (m (assocd major-mode '((shell-mode shell-obarray "(1)") (c-mode c-obarray "(3)")) '(c-obarray "(3)")))
	  (oblist (eval (car m)))
	  (vol (cadr m))
	  (val (completing-read (if top
				    (format "Manual entry (default %s): " (concat top vol))
				  "Manual entry: ")
				(or oblist obarray)))) 
     (list (if (equal val "")
	       (concat top vol ) val))))

  (or  (fman topic section)  (manual-entry topic))
  )


;;; todo allow interaction for multiple hits
;;(defvar howto-vector nil "vector of active howtos")

;; boy, was *this* a bad idea!
;;(defun build-howto-vector()
;;  (setq howto-vector
;;	    (catvector (clean-string (eval-process  "ls" "/a/n/howto") ":")))
;;  )

(defun howto-grep (name &optional output-buffer)
  "run grep for topic in dirs on HOWTOPATH"
  (catch 'done
    (dolist (x *howto-path*)
      (let ((doit (y-or-n-q-p "run grep in %s? " " " x)))
	(cond
	 ((eq doit ?q) (throw 'done t))
	 ((eq doit ? ) nil)
	 (doit (let ((d default-directory))
		 (setq default-directory (expand-file-name x))
		 (egrep (format "-i %s *" name))
		 (setq default-directory d)
		 ))))
      )
    )
  )

(defvar *howto-search* t "if set, run grep for topic in dirs on HOWTOPATH")


(defun rstring-match (regexp string &optional start)
  "like string match, only finds last occurrence not good for loops"
  (let ((x (or start 0)) y)
    (while
	(setq y
	      (string-match regexp string x)
	      )
      (setq x (1+ y))
      )
    (and (> x 0) (1- x)))
  )

(defun file-name-extension (fn &optional ext)
  (if (rstring-match (concat "\\." ext)	fn) 
      (substring fn (match-end 0))
    "")
  )

(defun file-name-sans-extension (fn &optional ext)
  (if (string-match (concat "\\." ext)	fn) 
      (substring fn 0 (match-beginning 0))
    fn)
  )
;; (file-name-sans-extension "abc.z" "z")
;; (file-name-sans-extension "abc.z" )

(defun howto-find-file (fn &optional bufname)
  " find howto file.  allow compressed."
  ;; note -- run inside (catch 'done ...)

  (let ((a (file-name-sans-extension fn "z")))
    (if (string= fn a)
	(find-file fn) ;not compressed.

      (let* ((bname (or bufname a))
	     (b (or (get-buffer bname) (zap-buffer bname))))

	(if  (buffer-modified-p b)
	    (let ((doit 
		   (y-or-n-q-p " buffer %s exists and is modified.  delete (y/n/q/RET)? " "\C-m"  bname)))
	      (if (or (not doit ) (eq doit ?q))
		  (throw 'done t) )))

	(set-buffer b)
	(switch-to-buffer b)
	(message "uncompressing %s" fn)
	(insert-eval-process "gzcat" a)
	(goto-char (point-min))
	(set-buffer-modified-p nil) 
	)
      )

    ;; either way
    (local-set-key "" '(lambda () (interactive) (save-buffer 0)))
    (setq buffer-read-only t) ; avoid blunders
    (auto-save-mode 0)
    )
  )

(defun sorted-completions (file dir)
  (save-excursion
    (zap-buffer  " tmp")
    (set-buffer " tmp")
    (mapcar #'(lambda (x) (format "%s\n" x))  (file-name-all-completions file dir) )
  ;    (mapcar '(lambda (x) (insert (format "%s\n" x)))  (file-name-all-completions file dir) )
  ;    (sort-lines nil (point-min) (point-max))
  ;    (catlist (buffer-substring (point-min) (point-max)) ?
  ;      )
  ;    (kill-buffer " tmp")
    )
  )

(defun munged-completions (name x)
  (loop for y in   
	(get-directory-files (expand-file-name x))
	when (and (string-match name y) (not (string-match "~$" y)))
	collect y)
  )

;; (defun munged-completions (munge l)
;;   " if munge appears on list, put it at head, else leave unchanged"
;;   (and l 
;;        (let* ((x 0) (y
;; 		(catch 'done
;; 		  (progn
;; 		    (mapcar '(lambda (z) (if (string-equal munge z) (throw 'done x) (setq x (1+ x))))
;; 			    l)
;; 		    (throw 'done nil)
;; 		    )
;; 		  ))
;; 	 )
;;     (if (or (null y) (= y 0)) l		;no change
;;       (let* ((z (nthcdr (1- y) l))
;; 	     (m (rplacd z (cddr z))))
;; 	(cons munge l))))))

(defvar *init-howto* nil)
(defun init-howto ()
  (or *init-howto*
      (progn
	(defvar *howto-path* (split ($ "$HOWTOPATH") ":")
	  "list of directories to search for `howto'" )

	(defvar *howto-alist* 
	  (loop
	   for x in *howto-path*
	   with l = nil
	   nconc (and (file-directory-p x)
		      (loop for y in (get-directory-files x)
			    collect (list y x))) into l
	   finally return l)
	  " completion alist for `howto'")

	(setq *init-howto* t)
	)))

;; (defun howto (name)
;;   (interactive 
;;    (list
;;     (completing-read "what? " *howto-alist*)))
;; 
;;   (let ((hit (assoc name *howto-alist*)))
;;     (find-file (concat  (cadr hit) "/" (car hit)))
;;     )
;;   )

(defun howto (pat)
  (interactive (list (completing-read "pat: " *howto-alist*)))
  (init-howto)
  (catch 'done
    (let* ((matches (loop for x in *howto-alist* 
			  when (string-match pat (car x))
			  collect x))
	   (hit (cond
		 ((= 1 (length matches)) (car matches))
		 ((= 0 (length matches)) (message "no matches") (throw 'done t))
		 (t 
		  (assoc* (completing-read "what? " matches) *howto-alist*  :test '(lambda (x y) (string-match x y))))))
	   (where (concat  (cadr hit) "/" (car hit))))

      (and (file-exists-p where) (view-file where)))
    )
  )

; (howto "DNS")

; another attempt at the same thing

(defun howto-1 (name &optional exact)
  "searches for files matching NAME along environment variable *howto-path*
does regexp matching unless optional EXACT is set
if *howto-path* is not set, searches in current directory
"
  (interactive "swhat? ")


  (catch 'done
    (let ((*howto-path* (or *howto-path* (list (pwd))))
	  (output-buffer (and  *howto-search* "*Help*")))

      (or exact
	  (let ((p (string-match  "\\." name)))
	    (and p (= p (1- (length name)))
		 (progn
		   (setq name (substring name 0 (match-beginning 0)))
		   (setq exact t)
		   )
		 )
	    ))

      (if (let ((name
		 (roll-list
		  (loop for x in  *howto-path*
			nconc (munged-completions name x) into ret
			finally return ret)
		  )))

	    (and (string* name)
		 (loop for x in  *howto-path*
		       do
		       (let ((fn (concat x "/" name)))
			 (if (file-exists-p fn)
			     (throw 'done
				    (howto-find-file fn))

  ; not found.  try contents file
			   (let ((fn (concat x "/contents")))
			     (if (and output-buffer (file-exists-p fn))
				 (progn
				   (shell-command (format "grep %s %s" name fn) output-buffer)
				   (if (> (point-max) 1)
				       (throw 'done
					      (pop-to-buffer output-buffer)
					      )))))
			   )
			 )
		       ))
	    )

	  (message "")
	(if output-buffer (howto-grep name output-buffer)
	  (message "%s not found" name))
	)

      (if (and (bufferp output-buffer)
	       (> (with-current-buffer output-buffer (buffer-size)) 0))
	  (progn 
	    (pop-to-buffer output-buffer)
	    (set-buffer-modified-p nil)
	    (setq buffer-read-only t)
	    )
	)
      )
    )
  )
(defun enquote-string (s)
  (replace-regexp-in-string " " "\\\\ " s)
  )
; (enquote-string "DCGS-A V3 Quality Audit Assessment Technical Brief.pdf")

(defun enquote (arg)
  " wrap all words in quotes.
with optional prefix arg, wrap by line "
  (interactive "P")
  (save-excursion
    (goto-char (point-min))
    (if arg
	(progn
	  (while (re-search-forward  "$"  nil t)
	    (replace-match "\"" nil nil))
	  (goto-char (point-min))
	  (while (re-search-forward "^" nil t)
	    (replace-match "\"" nil nil))
	  )
	  (while (re-search-forward  "[a-zA-Z0-9_-]+" nil t)
	    (replace-match  " \"\\\&\" " nil nil))
      )
    )
  )

(defun show-code (x)
  (interactive (list (read-string (format "show code for %s: " (indicated-word)))))
  (message "%c" (car (read-from-string (or (and x (> (length x) 0)) (indicated-word)) ))))

;(format "%d" ?a)

(defun integerify (x)
  (cond
   ((null x) x)
   ((listp x) 
    (cond ((eq (car x) 'lambda) x)
	  (t (cons (integerify (car x)) (integerify (cdr x))))))
   ((or (integerp x) (characterp x))
    (key-description (vector x)))
   (t x)
   )
  )

(defun prettify-keymap (m)
  (interactive (list (intern (completing-read "map: "  (mapcar 'list (symbols-like "-map" t))))))

  (let* ((m 
	  (cond ((and (symbolp m) (boundp m)) (eval m))
		(t m)))
	 )

    (mapcar 'integerify m)
    )
  )

; (prettify-keymap 'isearch-mode-map)
; (prettify-keymap 'xz-mode-map)

(defsubst macrop (sym)
  "true if sym is a macro"
  (eq 'macro (car (symbol-function sym)))
  )

(defun find-function-or-variable (w)
  (interactive (list
		(string* (read-string (format "find function or variable (%s): " (indicated-word "-")))
			 (indicated-word "-"))))

  (let ((symbol (if (symbolp w) w (intern w))))

    (condition-case err  

	(cond
	 ((boundp symbol)
	  (find-variable symbol))
	 ((functionp symbol)
	  (find-function symbol))
	 ((macrop symbol)
	  (find-function symbol))
	 (t 
	  (message
	   (format "%s not defined as a variable, function, or macro." symbol)))
	 )

      (void-function
       (message
	(format "%s not defined as a variable, function, or macro." (cadr err)))
       )       

      (error
  ; all this goop is because find-func* assumes sources are shipped with compiled modules
  ; and does not properly respect `find-function-source-path'
  ; maybe it would just be easier to ship the sources
       (let* (
	      (load-file (symbol-file symbol))
	      (basename (concat (file-name-sans-extension (file-name-nondirectory load-file)) ".el"))
	      (source-file (cond
			    ((string-match "\.elc$" load-file)
			     (loop for x in find-function-source-path thereis (let ((f (expand-file-name basename x))) (and (file-exists-p f) f)))
			     )
			    ))
	      )
	 (cond
	  (source-file
	   (let* ((b (or (find-buffer-visiting source-file) (find-file-noselect source-file)))
		  (w (get-buffer-window b)))
	     (with-current-buffer b
	       (goto-char (point-min))
	       (let* ((regexp-symbol (cdr (assq (cond ((boundp symbol) 'defvar)) find-function-regexp-alist)))
		      (regexp (format (symbol-value regexp-symbol)
				      (concat "\\\\?"
					      (regexp-quote (symbol-name symbol)))))
		      (case-fold-search))
		 (re-search-forward regexp nil t)
		 )
	       )
	     (if w (select-window w) (switch-to-buffer b))
	     ))
	  (t
	   (message "unable to find %s in %s or along find-function-source-path" basename (file-name-directory load-file)))
	  )
	 )
       )
      )
    )
  )

; (find-function-or-variable 'find-parent-file)
; (fmakunbound 'find-function-or-variable)

(load-library "post-view")


(defun find-library (thing)
  (interactive "sthing: ")
  (let ((fn (locate-library thing)))
    (find-file fn)
    )
  )

(defun switch-to-help-buffer ()
  (interactive)
  (let ((b (get-buffer "*Help*")))
    (if (and b (buffer-live-p b))
	(switch-to-buffer b)
      (message "buffer *Help* not found"))
    )
  )

