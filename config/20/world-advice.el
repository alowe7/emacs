(put 'world-advice 'rcsid 
 "$Id$")
(require 'advice)
(provide 'world-advice)

; really only want this on interactive find file
(defadvice find-file (around interactive-world-completion activate)
  (interactive  (list (read-file-name "Find file: ")))

  (ad-enable-advice 
   'minibuffer-complete-word
   'around
   'interactive-world-completion)

  (ad-activate 'minibuffer-complete-word)

  ad-do-it

  (if (ad-is-advised 'minibuffer-complete-word)
      (ad-disable-advice
       'minibuffer-complete-word
       'around
       'interactive-world-completion))

  (ad-activate 'minibuffer-complete-word)

  )
; (ad-unadvise 'find-file)

(defadvice read-file-name (around interactive-world-completion activate)
  (interactive  (list (read-file-name "Find file: ")))

  (ad-enable-advice 
   'minibuffer-complete-word
   'around
   'interactive-world-completion)

  (ad-activate 'minibuffer-complete-word)

  ad-do-it

  (if (ad-is-advised 'minibuffer-complete-word)
      (ad-disable-advice
       'minibuffer-complete-word
       'around
       'interactive-world-completion))

  (ad-activate 'minibuffer-complete-word)

  )

; (ad-unadvise 'read-file-name)

; define advice initially disabled
(defadvice minibuffer-complete-word (around 
				     interactive-world-completion
				     first
  ; disable
				     )
  ""
  (let* ((s (buffer-string))
	 (w (maybe-complete-world s)))
    (condition-case x  
	(let ((buffer-read-only nil)) ; XXX does not work on emacs 21.*
	  (erase-buffer)
	  (insert w))
      (error
       (progn 
	 (debug)
	 )))
    )
  ad-do-it
  )
; (ad-unadvise 'minibuffer-complete-word)

; (if (ad-is-advised 'minibuffer-complete) (ad-unadvise 'minibuffer-complete))
(if nil
(defadvice minibuffer-complete (around 
				interactive-world-completion
				first disable)
  ""
  (let ((s (buffer-string)))
    (erase-buffer)
    (insert (maybe-complete-world s)))
  ad-do-it)
)

(defadvice xwf (around xwf-hook activate)
  ad-do-it
  (let* ((d ad-return-value)
	 (d1 (unless (string-match "^//\\|^~\\|^[a-zA-`]:" d)
	       (loop for y in cygmounts 
		     if (or
			 (string-match (concat "^" (car y) "/") d)
			 (string-match (concat "^" (car y) "$") d))
		     return (expand-file-name (replace-in-string (concat "^" (car y)) (cadr y) d))
		     ))))
    (cond
     (d1 (setq ad-return-value d1))
     (t d)
     )
    )
  )

; (if (ad-is-advised 'xwf) (ad-unadvise 'xwf))

; (mapcar 'ad-unadvise '(find-file read-file-name minibuffer-complete-word xwf))
