(put 'post-cc-mode 'rcsid 
 "$Id$")

(defun narrow-to-fn ()
  " narrow to region surrounding current function"
  (interactive)
  (save-excursion
    (mark-c-function)
    (narrow-to-region (region-beginning) (region-end))))

(defun beginning-of-comment ()
  "goto beginning of enclosing comment"
  (interactive)
  (search-backward "/*" (point-min) 'move)
  )

(defun end-of-comment ()
  "goto end of enclosing comment"
  (interactive)
  (search-forward "*/" (point-max) 'move)
  )

(defun mark-c-comment ()  
  "Put mark at end of C comment, point at beginning."
  (interactive) 
  (push-mark (point))
  (end-of-comment)
  (push-mark (point))
  (beginning-of-comment)
  (backward-paragraph))

(defun narrow-to-comment ()
  " narrow to region surrounding current function"
  (interactive)
  (save-excursion
    (mark-c-comment)
    (narrow-to-region (region-beginning) (region-end))))

;; modified to handle cpp options
(defvar default-cpp-options "-")

(defun c-macro-expand (beg end)
  "Display the result of expanding all C macros occurring in the region.
The expansion is entirely correct because it uses the C preprocessor."
  (interactive "r")
  (let ((outbuf (get-buffer-create "*Macroexpansion*"))
	(tempfile "%%macroexpand%%")
	process
	last-needed)
    (with-current-buffer outbuf
      (erase-buffer))
    (setq process (start-process "macros" outbuf "/lib/cpp" default-cpp-options))
    (set-process-sentinel process '(lambda (&rest x)))
    (save-restriction
      (widen)
      (save-excursion
	(goto-char beg)
	(beginning-of-line)
	(setq last-needed (point))
	(if (re-search-backward "^[ \t]*#" nil t)
	    (progn
	      ;; Skip continued lines.
	      (while (progn (end-of-line) (= (preceding-char) ?\\))
		(forward-line 1))
	      ;; Skip the last line of the macro definition we found.
	      (forward-line 1)
	      (setq last-needed (point)))))
      (write-region (point-min) last-needed tempfile nil 'nomsg)
      (process-send-string process (concat "#include \"" tempfile "\"\n"))
      (process-send-string process "\n")
      (process-send-region process beg end)
      (process-send-string process "\n")
      (process-send-eof process))
    (while (eq (process-status process) 'run)
      (accept-process-output))
    (delete-file tempfile)
    (with-current-buffer outbuf
      (goto-char (point-max))
      (if (re-search-backward "\n# [12] \"\"" nil t)
	  (progn
	    (forward-line 2)
	    (while (eolp) (delete-char 1))
	    (delete-region (point-min) (point))))
      )
    (display-buffer outbuf)))

(defvar *grep-source-file-types* '("c" "cpp" "h" "rc" "idl" "java" "pl" "el"))
(defun grep-source (arg)
  (interactive (list (read-string (format "grep source for (%s): " (indicated-word)))))
  (grep (format "%s %s %s" grep-command (string* arg (indicated-word))  (mapconcat '(lambda (x) (concat "\*\." x)) *grep-source-file-types* " ")))
  )

(global-set-key "g" 'grep-source)


(add-hook 'c++-mode-hook 
	  '(lambda () 
	     (modify-syntax-entry ?_ "w")
	     (setq comment-column 2)
	     (setq c-tab-always-indent t)
	     (setq tab-width 4)
	     (local-set-key "\C-c\C-s" 'current-word-search-forward)
	     (local-set-key "\M-gc" 'goto-char)
;	     (turn-on-lazy-lock)
	     )
	  )

; tolerate errors
(condition-case e
    (require 'post-java-mode)
  (error nil)
  )


