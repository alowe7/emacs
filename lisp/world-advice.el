(defconst rcs-id "$Id: world-advice.el,v 1.2 2000-07-30 21:07:49 andy Exp $")
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

  (ad-disable-advice
   'minibuffer-complete-word
   'around
   'interactive-world-completion)

  (ad-activate 'minibuffer-complete-word)

  )

(defadvice read-file-name (around interactive-world-completion activate)
  (interactive  (list (read-file-name "Find file: ")))

  (ad-enable-advice 
   'minibuffer-complete-word
   'around
   'interactive-world-completion)

  (ad-activate 'minibuffer-complete-word)

  ad-do-it

  (ad-disable-advice
   'minibuffer-complete-word
   'around
   'interactive-world-completion)

  (ad-activate 'minibuffer-complete-word)

  )

; (ad-unadvise 'find-file)

; define advice initially disabled
(defadvice minibuffer-complete-word (around 
				     interactive-world-completion
				     first disable)
  ""
  (let ((s (buffer-string)))
    (erase-buffer)
    (insert (maybe-complete-world s)))
  ad-do-it)

