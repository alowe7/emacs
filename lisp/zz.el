(put 'zz 'rcsid
 "$Id$")
; poor, deaf, blind man's xz

(require 'locate)
(require 'qsave)

;; see locate1 in post-locate.el
(defvar *top* (let ((top "/projects")) (if (file-directory-p top) top (expand-file-name "~"))))

(defun bungee () 
  (setq result
	(mapcar 'trim-leading-white-space
		(nthcdr 2 
			(split (buffer-substring-no-properties (point-min) (point-max)) "
")
			)
		)
	)
  )

(defun filelist (base type)
  (let ((locate-post-command-hook 'bungee)
	result)
    (save-window-excursion (locate base type))
    result)
  )

(defun zz1 (thing)
  (interactive "sthing: ")
  (let ((orig-compilation-sentinel (symbol-function 'compilation-sentinel)))

					; wrap compilation-sentinel 
    (fset 'compilation-sentinel
	  '(lambda (proc msg)  (set-buffer (process-buffer proc)) (setq truncate-lines t) (funcall orig-compilation-sentinel proc msg)))

    (grep (format "grep -n -i -e %s %s"
		  thing
		  (mapconcat 'identity (filelist "/a/emacs" "\.el$") " ")
		  ))

    (fset 'compilation-sentinel orig-compilation-sentinel)
    )
  )

(defvar *zz-last-thing* "")
(defvar *zz-last-extra* "")

(defvar *zz-extra-alist*  
  '(
    ("JITIDB"  "-iregex \".*\\.\\(txt\\|adp\\|UDT\\|XPC\\|UDF\\|vbs\\|dsw\\|mak\\|vdproj\\|dsp\\|bat\\|rpc\\|PRC\\|RUL\\|TRG\\|TAB\\|prc\\|rul\\|tab\\|udf\\|udt\\|xpc\\|SQL\\|sql\\|viw\\|VIW\\)\"")
    )
  "when `default-directory' matches a car of this alist, use cadr of that cell as extra filter for `zz'"
  )

(defun zz-deduce-extra (&optional arg)
					; this is just dumb
					;  *zz-last-extra*
					;   "-name \"*.cs\" -o -name \"*.java\" -o -name \"*.el\""
					; with current-prefix arg, search all files
  (let ((farq (if current-prefix-arg
		  ""
		  (or (cadr (loop for x in  *zz-extra-alist* when (string-match (car x) default-directory) return x))
		      "-iregex \".*\\.\\(cs\\|java\\|el\\|c\\|h\\)\"")
		)))

    farq    
    )
  )
; (insert (zz-deduce-extra))

; if you're going to do a lot of searching in a deep directory structure, you might save some time by generating a filecache like so:

; find . -iregex ".*\.\(cs\|java\|el\)" | perl -e 'print join("\0",map {chomp;$_} (<>))' > .files

(defun zz-deduce-cmd (thing)
					; this is a little faster than grep-find...
					; (format "locate %s | xargs grep  -n -i -e %s" dir thing)
					; when it works..
					; special case: if exists a file named .files, use that rather than searching
					; assert: already in target dir
  (let ((*filecache* ".files"))

    (format "%s | xargs -0 -e grep -n -i -e %s" 
	    (cond 
	     ((file-exists-p  *filecache*) (concat "cat " *filecache*))
	     (t 
	      (concat "find . -type f "
		      (zz-deduce-extra thing)
		      " -print0"))
	     )
	    thing)
    )
  )
; (zz-deduce-cmd "filecache")

(define-derived-mode zz-mode nil "zz" "" 
  (setq truncate-lines t)
  (setq buffer-read-only t)
  ; should work buyt doesn't
  ;(setq compilation-minor-mode t)
  )

(define-key zz-mode-map (vector 'return) 'zz-find-file-other-window)
(define-key zz-mode-map "o" 'zz-find-file-other-window)
(define-key zz-mode-map "f" 'zz-find-file)
; (define-key zz-mode-map "" 'zz-find-next-file)
; (define-key zz-mode-map "" 'zz-find-previous-file)
(define-key zz-mode-map "`" 'zz-next-hit)
(defun zz-next-hit (&optional arg) 
  (interactive "P")
  (if arg
      (progn
	(goto-char (point-min))
	(forward-line 1)
	))

  (forward-line 1)
  (if (not (looking-at "$"))
      (save-selected-window
	(zz-find-file-other-window))
    (progn
      (message "no more hits")
      (forward-line -1))
    )
  )


(add-hook 'zz-post-hook 'zz-post-hook)
; (pop zz-post-hook)
(defun zz-post-hook ()
  (qsave-add nil *zz-last-thing* default-directory (point))
  )
(define-key zz-mode-map "p" 'previous-qsave)
(define-key zz-mode-map "n" 'next-qsave)


(defun zz-find-file-noselect () (interactive)
  (let* ((l (split (thing-at-point (quote line)) ":")) 
	 (fn (car l))
	 (ln (car (read-from-string (cadr l))))
	 (b (or (get-file-buffer fn) (find-file-noselect  fn)))
	 )

    (set-buffer b)
    (goto-line ln)
   ; (message "%s" (point))
    b
    )
  )

(defun zz-find-file-other-window () (interactive)
  (zz-find-file t)
  )

(defun zz-find-file (&optional arg) (interactive)
  (let* ((l (split (thing-at-point (quote line)) ":")) 
	 (dir (save-excursion (goto-char (point-min)) (cadr (split (chomp (thing-at-point (quote line))) " "))))
	 (fn (expand-file-name (car l) dir))
	 (ln (car (read-from-string (cadr l))))
	 (b (funcall (if arg 'find-file-other-window 'find-file) fn))
	 )

    (goto-line ln)
    b
    )
)

(defun zz-find-next-file () (interactive)
  (forward-line 1)
  (let* ((b (zz-find-file-noselect))
	(w (get-buffer-window b))
	)

					;    (debug)
    (or w 
	(display-buffer b))
    )
  )

(defun zz-find-previous-file () (interactive)
  (previous-line 1)
  (display-buffer (zz-find-file-noselect))
  )

; custom...
(defvar *zz-dir-stack* *top*)
(defun zz-dir-stack-completion-list ()
; always include current directory.  dot is a shortcut for that 
  (nconc (list  (list "." default-directory) (list default-directory default-directory)) (mapcar  '(lambda (x) (list x x)) *zz-dir-stack*))
  )
; (zz-dir-stack-completion-list)

(defvar *zz-last-dir* nil)

(defun zz-last-dir (&optional set)
  (if set
      (prog1
	  (setq *zz-last-dir* set)
	(unless (member set *zz-dir-stack*) (push set *zz-dir-stack*))
	)
    )

  (or
   *zz-last-dir*
   default-directory)
  )

; tbd -- mechanism to provide feedback

(defun zz (thing &optional dir)
  "do a grep-find among sources for THING 
with prefix, prompts for optional DIR, using `zz-last-dir' as default
"
					; prompt for thing, unless its a prefix arg, prompt for dir, extra and thing
  (interactive 
   (list 
    (read-string* (format "grep-find sources for thing like (%s): " (thing-at-point 'word)) (thing-at-point 'word))
    (and current-prefix-arg
	 (let* (
		(l (zz-dir-stack-completion-list))
		(d 
		 (expand-file-name (completing-read*
				    (format "in directory (%s): " (zz-last-dir))
				    (zz-last-dir) 
				    l
				    ))))
		(or (cadr (assoc d l)) d)
		))))

  (if thing
      (let* (
	     (default-directory (zz-last-dir (or dir default-directory)))
	     (cmd (zz-deduce-cmd thing))
	     (err (zap-buffer "*err*"))
	     (b (zap-buffer "*zz*"))
	     w
	     res
	     )

	(shell-command cmd b err)

	(set-buffer b)
	(setq buffer-read-only nil)

	(goto-char (point-max))
	(insert "\ncompleted at " (current-time-string) "\n")

	(goto-char (point-min))
	(insert (format "cd %s\n%s\n" default-directory cmd))

	(setq *zz-last-thing* thing)

	(setq compilation-error-regexp-alist
	      '(("\\([a-zA-Z]?:?[^:(	\n]+\\)[:( 	]+\\([0-9]+\\)[:) 	]" 1 2)))
	(setq mode-line-buffer-identification (format "*%s*" thing))

	(set-buffer-modified-p nil)

	(zz-mode)

	(let ((w (get-buffer-window b)))
	  (if w (select-window w)
	    (switch-to-buffer b))

	  (run-hooks 'zz-post-hook)

	  default-directory
	  )

	)
    (message "no thing")
    )
  )

; heres another way to do that
(defun gf (pat)
  (interactive (list (read-string* "grep find for (%s): " (thing-at-point 'word))))
  (grep-find (format "find . -type f -name \"*.cs\" -print0 | xargs -0 -e grep -n -i -e %s" pat))
  )

; heres yet another way to do that

(defvar *last-grep-find-dir* nil)
(defvar source-modes  '((java-mode "*.java") (emacs-lisp-mode "*.el")))
(defun grep-find-1 (&optional arg) 
  (interactive "P")
  (let* ((dir (or (and (not arg) *last-grep-find-dir*) (setq  *last-grep-find-dir* default-directory)))
	 (mode (assoc major-mode source-modes))
	 (word
	  (let ((w (thing-at-point 'word)))
	    (if mode ; in a source mode, default to indicated word, if any
		(if (or arg (null w)) (read-string* "grep-find for: " w) w)
					; otherwise always prompt
	      (read-string* "grep-find for: " w)
	      )))
	 (type (cond (mode (cadr mode)) (arg (read-string "matching pattern: ")) (t "*")))
	 (default-directory dir)
	 )
    (grep-find (format "find . -type f -name \"%s\" -print0 | xargs -0 -e grep -n -i -e \"%s\""   type word))

    (goto-char (point-max))
    (insert "\ncompleted at " (current-time-string) "\n")
    (goto-char (point-min))

    )
  )

(defun zz-switch-to-buffer ()
  (interactive)
  (let
      ((b (get-buffer "*zz*")))
    (if (buffer-live-p b) (switch-to-buffer b) (message "buffer not found"))
    )
  )

(defun zz-dir (thing dir)
					; prompt for thing, unless its a prefix arg, prompt for dir, extra and thing
  (interactive 
   (list (read-string* (format "grep find sources for thing like (%s): " (thing-at-point 'word)) (thing-at-point 'word))
	 (read-string* (format "in dir (%s): " default-directory) default-directory)))
  (zz thing (expand-file-name dir))
  )

; construct a regexp that matches a method definition for thing

(defun zz-method-definition (thing)
  (interactive 
   (list (read-string* (format "locate method definitions like (%s): " (thing-at-point 'word)) (thing-at-point 'word))))
  (let ((method-regexp (concat "\"\\(public\\|private\\|protected\\).* " thing "\"")))
    (zz method-regexp)
    )
  )
(defvar thing-at-point-method-or-class-chars "~/A-Za-z0-9---_.${}#%,:()"
  "Characters allowable in method or class names.")
(put 'method-or-class 'end-op    
     (lambda () (skip-chars-forward thing-at-point-method-or-class-chars)))
(put 'method-or-class 'beginning-op
     (lambda () (skip-chars-backward thing-at-point-method-or-class-chars)))

(defun method-or-class-at-point ()
  (let ((class (thing-at-point 'method-or-class)))
					; if its a method invocation, peel off the method name
    (if (string-match "\\(.*\\)\\..*\(.*\)$" class)
	(substring class (match-beginning 1) (match-end 1))
      class)
    )
  )

(defun locate-def (thing)
  "find definition of THING somewhere among sources, loosley defined
"
					; prompt for thing, unless its a prefix arg, prompt for dir, extra and thing
  (interactive 
   (list (read-string* (format "locate class definitions like (%s): " (method-or-class-at-point)) (method-or-class-at-point))))

  (let* (
	 (l (split thing "\\."))
	 (class (car (last l)))
	 (container (join (progn (rplacd (nthcdr (- (length l) 2) l) nil) l) "/")))

    (locate-with-filter container (concat class ".cs$"))
    (flush-lines "/AssemblyInfo\.cs$")
    (keep-lines  (concat "/" *top* "/"))

    (and (= 1 (count-lines (point-min) (point-max)))
	 (fb-find-file))
; tbd if it was a method, jump there
    )
  )

(defun locate-derivatives (thing)
  "find definition of THING somewhere among sources, loosley defined
"
					; prompt for thing, unless its a prefix arg, prompt for dir, extra and thing
  (interactive 
   (list (read-string* (format "locate derivative class definitions like (%s): " (thing-at-point 'word)) (thing-at-point 'word))))

  (let ((pat (format "public class.*%s" thing)))
    (grep-find (concat "find . -type f -name \"*.cs\" -print0 | xargs -0 -e grep -n -i -e \"" pat "\""))
    )
  )

(defun zz-emacs (thing)
  (interactive 
   (list (read-string* (format "grep find sources for thing like (%s): " (thing-at-point 'word)) (thing-at-point 'word))
	 ))
  (zz thing "~/emacs/lisp")
  )

; (zz "hook-xml-mode")
(require 'ctl-backslash)
(define-key ctl-\\-map (vector (ctl ? )) 'zz)
(define-key ctl-\\-map "j" 'zz-dir)
(define-key ctl-\\-map "\C-f"  'zz-method-definition)
(define-key ctl-\\-map "\C-z" 'zz-emacs)

; ctl-\ ctl-\
(define-key ctl-\\-map  "\C-g"  'gf)
(define-key ctl-\\-map "d" 'locate-def)

(define-key ctl-\\-map "\C-j" 'zz-switch-to-buffer)
(define-key ctl-/-map "\C-j" 'last-locate-buffer)

(defun buffer-display-time (&optional b) (let ((b (or b (current-buffer)))) (save-excursion (set-buffer b) buffer-display-time)))
(defun last-locate-buffer () 
  "return most recently viewed buffer among LIST
"
  (interactive)
  (let* ((locate-buffer-names (list "*Locate*" "*zz*" "*Shell Command Output*"))
	 (l (remove* nil (loop for bn in locate-buffer-names collect (get-buffer bn)) ))
	 (v (cond
	     ((< (length l) 1) nil)
	     ((< (length l) 2) (car l))
	     (t 
	      (let ((v (apply 'compare-filetime (loop for b in l collect (buffer-display-time b)))))
		(cond ((< v 0) (car l))
		      ((= v 0) (roll-buffer-list l))
		      (t (cadr l))))
	      )
	     )))
    (if (null v) (message "you lose")
	(switch-to-buffer v)
      )
    )
  )

(provide 'zz)
