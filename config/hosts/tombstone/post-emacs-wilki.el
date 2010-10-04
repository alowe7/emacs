(put 'post-emacs-wilki 'rcsid
 "$Id$")

(defvar post-emacs-wiki-loaded nil)
(unless post-emacs-wiki-loaded
	(read-string "loading post emacs wiki")
	(setq post-emacs-wiki-loaded t))

(defvar emacs-wiki-history nil)
(defvar emacs-wiki-future nil)

(defun emacs-wiki-push-referrer ()
  (let ((link (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
	(if emacs-wiki-current-project
		(push (cons emacs-wiki-current-project link) emacs-wiki-history)
	  (push link emacs-wiki-history)
	  )
	)
  )

(defun emacs-wiki-referrer ()
  (interactive)
  (let ((link (pop emacs-wiki-history))
				(this (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
		(cond ((null link) (message "no referrer"))
					(t
					 (push this emacs-wiki-future)
					 (cond
						((listp link)
						 (if (and emacs-wiki-current-project
											(not (string= emacs-wiki-current-project (car link))))
								 (emacs-wiki-change-project (car link)))
						 (emacs-wiki-visit-link (cdr link)))
						(t (emacs-wiki-visit-link  link))))
					)
		)
	)
(define-key emacs-wiki-mode-map "b" 'emacs-wiki-referrer)

(defun emacs-wiki-next ()
  (interactive)
  (let ((link (pop emacs-wiki-future)))
		(cond ((null link) (message "no next"))
					(t
					 (push link emacs-wiki-history)
					 (cond
						((listp link)
						 (if (and emacs-wiki-current-project
											(not (string= emacs-wiki-current-project (car link))))
								 (emacs-wiki-change-project (car link)))
						 (emacs-wiki-visit-link (cdr link)))
						(t (emacs-wiki-visit-link  link))))
					)
		)
	)
(define-key emacs-wiki-mode-map "n" 'emacs-wiki-next)

(defun emacs-wiki-history ()
  (interactive)
  (describe-variable 'emacs-wiki-history)
  )


(defadvice emacs-wiki-follow-name-at-point 
  (around 
   hook-emacs-wiki-follow-name-at-point
   first activate)
  ""


  (emacs-wiki-push-referrer)
  ad-do-it

  )

; (if (ad-is-advised 'emacs-wiki-follow-name-at-point) (ad-unadvise 'emacs-wiki-follow-name-at-point))

(defadvice emacs-wiki-edit-link-at-point 
  (around 
   hook-emacs-wiki-edit-link-at-point
   first activate)
  ""


  (emacs-wiki-push-referrer)
  ad-do-it

  )

; (if (ad-is-advised 'emacs-wiki-edit-link-at-point) (ad-unadvise 'emacs-wiki-edit-link-at-point))