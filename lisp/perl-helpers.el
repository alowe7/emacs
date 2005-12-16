;; $Id: perl-helpers.el,v 1.17 2005-12-16 00:31:47 tombstone Exp $

(require 'perl-command)

(require 'fb)
(require 'cl)

; ask perl where it lives
; xxx tbd use config tree
(defvar perldir
 (expand-file-name (eval-process "perl" "-MConfig" "-e" 
				 (format "print  $Config{%s}"
					 (if (string= "Linux" (uname)) "installprivlib" "prefix")
					 )
				 )
		   )
)
;; alternative methods:
; (expand-file-name (eval-process "perl" "/usr/local/bin/perl-config" "prefix")))
; (clean-string (reg-query "machine" "software/perl" "")) ; windows only
(defvar perldocdir (expand-file-name "doc" perldir))
(defvar perldoc-cmd (whence "perldoc"))
(defvar perlfunc-pod (concat (expand-file-name "pod" perldir)  "/perlfunc.pod"))
(defvar perlfunc-file (expand-file-name "perlfunc" perldocdir))
(defvar perlop-file (expand-file-name "perlop" perldocdir))
              
; (assert (file-exists-p perlfunc-file))
; run pod on perlfunc.pod
(or (file-directory-p (file-name-directory perlfunc-file))
		(shell-command (format "mkdir -p %s" (file-name-directory perlfunc-file))))

; (assert (file-exists-p perlfunc-pod))
; also need write permission to this dir to create it the first time
(or (file-exists-p perlfunc-file)
		(shell-command (format "pod2text %s > %s" perlfunc-pod perlfunc-file)))

(define-derived-mode perldoc-mode view-mode "perldoc" "")

(defun perlfunc (func)
  (interactive (list
		(let ((w (indicated-word))) (string* (read-string (format "perl function (%s): " w)) w))
		))

  (if (string-match "::" func)
      (let ((module (substring func 0 (match-beginning 0)))
	    (func (substring func (match-end 0))))
	(perlmod module)
	(search-forward func)
	)
    (let* ((b (or
	       (find-buffer-visiting perlfunc-file)
	       (find-file-noselect perlfunc-file)
	       ))
	   (funcpat (format "^    %s[^a-z]" func))
	   (p (save-excursion
		(set-buffer b)
		(if (looking-at func)
		    (and 
		     (re-search-forward funcpat nil t)
		     (backward-word 1)
		     (point))
		  (progn
		    (goto-char (point-min))
		    (and (re-search-forward funcpat nil t)
			 (backward-word 1)
			 (point))))))
	   (w (and p (get-buffer-window b)))
	   )
      (if p 
	  (progn
	    (if w
		(select-window w)
	      (switch-to-buffer-other-window b))
	    (unless (eq major-mode 'perldoc-mode) (perldoc-mode))
	    (goto-char p))
	(message (format "%s not found" func))
	)
      )
    )
  )

; (perlfunc "open")
; (perlfunc "CGI::start_html")

; XXX todo completing read on oblist of operators

(defun perlop (op)
  (interactive "sop: ")
  (let ((perlfunc-file perlop-file))
    (perlfunc op)
    )
  )

(defun perldoc (thing)
  "find perldoc for THING"
  (interactive "sperldoc: ")
  (let* ((b (zap-buffer (format "*perldoc %s*" thing)))
	 (s (perl-command perldoc-cmd thing)))
    (set-buffer b)
    (insert s)
    (pop-to-buffer b)
    (beginning-of-buffer)
    ; fix man page
    (let ((buffer-read-only nil))
      (save-excursion
	(kill-pattern "_") ; hack for roff underlining
	(kill-pattern ".")
	(kill-pattern "8")
	(kill-pattern "9")
	))
    (view-mode)
    )
  )
; (perldoc "perlfaq1")
; (perldoc "CGI")

;; assumes this has been run:
;; for a in *.pod; do b=${a%%.pod}; pod2text $a > ../doc/$b; done

(defun perlfaq (pat) 
  "find perl faq matching PAT"
  (interactive "sfind perl faq: ")

  (grep (format "grep -n -e %s %s%s" pat
		(file-name-directory perlfunc-file)
		"perlfaq*"))
  )

(defun perlop (op) 
  "find perl op"
  (interactive "sfind perl op: ")

  (grep (format "grep -w -n -i -e %s %s%s" op
		(file-name-directory perlfunc-file)
		"perlop"))
  )
(defun perlvar (var) 
  "find perl op"
  (interactive "sfind perl var: ")

  (grep (format "grep -w -n -i -e %s %s%s" var
		(file-name-directory perlfunc-file)
		"perlvar"))
  )

(defvar *perl-libs* 
  (loop for val in '("lib" "sitelib")
	with l=nil
	nconc 
	(split (perl-command-2 "map {print \"$_ \"} @INC"))
	into l
	finally return (mapcar 'expand-file-name l))
  "list of known perl libraries"
  )


(defun browse-perl-modules ()
  "dired all known perl libraries in visible windows.
see `*perl-libs*'"
  (interactive)
  (n-windows (length  *perl-libs*))
  (loop for x in *perl-libs* do 
	(dired x)
	(other-window 1)
	)
  (loop for x being the windows do 
	(set-buffer (window-buffer x))
	(beginning-of-buffer))
  )

(defun find-perl-module (m)
  "pop to named perl MODULE along library path"
  (interactive "smod: ")
  (let ((mm (concat (replace-in-string "::" "/" m) ".pm")))
    (loop for x in *perl-libs*  
	  with mmm=nil
	  if (file-exists-p (setq mmm (concat x "/" mm)))
	  return
	  (find-file mmm)
	  )
    )
  )

(defun find-perl-module-like (m)
  "pop to named perl MODULE along library path"
  (interactive "smod: ")
  (let ((mmm
	 (loop for x in *perl-libs*  
	       with l=nil
	       nconc (get-directory-files x t m) into l
	       finally return l
	       )))
    (if (interactive-p) 
	(let ((b (zap-buffer "*Help*")))
	  (set-buffer b)
	  (loop for x in mmm do
		(insert x "\n"))
	  (beginning-of-buffer)
	  (fb-mode)
	  (pop-to-buffer b)
	  )
      mmm)
    )
  )

; (find-perl-module-like "sql")

(defun perlmod (m)
  "find pod for perl module found along library path"
  (interactive (list
		(let ((w (indicated-word ":"))) (string* (read-string (format "perl module (%s): " w)) w))
		))
  (interactive "smod: ")
  (let ((mm  (replace-in-string "::" "/" m)))
    (or
     (loop for x in *perl-libs*  
	   with mmm=nil
	   thereis
	   (loop for ext in '(".pod" ".pm")
		 if (file-exists-p (setq mmm (concat x "/" mm ext)))
		 return
		 (prog1 (pop-to-buffer (pod2text mmm (concat mm " *pod*"))) (cd (file-name-directory mmm)))
		 )
	   )
     (message "module %s not found" m))
    )
  )

(defun perlmod-0 (m)
  (interactive "smod: ")

  (let ((module (loop for m in
		      (split 
		       (eval-process "egrep" "-i" (concat m ".pm") *fb-db*) "\n")

		      if (on* (downcase 
			       (expand-file-name   
				(chomp (file-name-directory m))))
			      *perl-libs* )
		      return m

		      )))
    (if (string* module)
	(pop-to-buffer (pod2text module (concat m " *pod*")))
      (message "perl module %s not found" m))
    )
  )

(defun on* (d p)
  "eval to non-nil if directory d is on list p.
test using string-equal"
  (member* d p :test 'string-equal)
  )

(defun on (d p &optional sep)
  "eval to non-nil if directory d is on path p"
  (let ((sep (or sep ":"))
	(l (split p sep)))
    (on* d l))
  )


(defun map-lines (fn) 
  "apply lambda expression F(x) to each line in buffer.
F is a function taking one arg, the line as a string"
  (mapcar fn (split (buffer-string) "
")
	  )
  )

(defun perl-config ()
  (interactive)
  (shell-command "perl -MConfig -e 'foreach (keys %Config) {print $_, \"\t\", $Config{$_}, \"\n\"}'")
  )

; apparently C-RET is not a good prefix key if you're on telnet session
(if window-system
    (define-key perldoc-mode-map  (vector 'C-return) 'perlfunc)
  (define-key perldoc-mode-map "\C-j" 'perlfunc)
  )

(define-key help-map "" 'perlmod)
(define-key help-map "p" 'perlfunc)
(define-key help-map "" 'perldoc)
(define-key help-map "" 'perlfaq)

(provide 'perl-helpers)
