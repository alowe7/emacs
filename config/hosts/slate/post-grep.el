
(defun grep-default-command ()
  "Compute the default grep command for C-u M-x grep to offer."
  (let ((tag-default (shell-quote-argument (grep-tag-default)))
	;; This a regexp to match single shell arguments.
	;; Could someone please add comments explaining it?
	(sh-arg-re "\\(\\(?:\"\\(?:[^\"]\\|\\\\\"\\)+\"\\|'[^']+'\\|[^\"' \t\n]\\)+\\)")
	(grep-default (or (car grep-history) grep-command)))
    ;; In the default command, find the arg that specifies the pattern.
    (when (or (string-match
	       (concat "[^ ]+\\s +\\(?:-[^ ]+\\s +\\)*"
		       sh-arg-re "\\(\\s +\\(\\S +\\)\\)?")
	       grep-default)
	      ;; If the string is not yet complete.
	      (string-match "\\(\\)\\'" grep-default))
;;; xxx I think this is a bug?
      ;; Maybe we will replace the pattern with the default tag.
      ;; But first, maybe replace the file name pattern.
      ;; (condition-case nil
;; 	  (unless (or (not (stringp buffer-file-name))
;; 		      (when (match-beginning 2)
;; 			(save-match-data
;; 			  (string-match
;; 			   (wildcard-to-regexp
;; 			    (file-name-nondirectory
;; 			     (match-string 3 grep-default)))
;; 			   (file-name-nondirectory buffer-file-name)))))
;; 	    (setq grep-default (concat (substring grep-default
;; 						  0 (match-beginning 2))
;; 				       " *."
;; 				       (file-name-extension buffer-file-name))))
;; 	;; In case wildcard-to-regexp gets an error
;; 	;; from invalid data.
;; 	(error nil))

      ;; Now replace the pattern with the default tag.
      (replace-match tag-default t t grep-default 1))))

