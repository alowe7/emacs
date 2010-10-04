(put 'pre-vm 'rcsid
 "$Id$")

(add-to-list 'load-path "/usr/share/emacs/site-lisp/vm-7.19")
(require 'vm)

(setq vm-accounts '("a" "devr" "net" "anita" "root"))
(setq *imap-server* "mail.alowe.com")
(setq vm-imap-server-alist
      (loop for x in vm-accounts 
	    collect
	    (list x (format "imap:%s:%d:inbox:login:%s:*" *imap-server* 143 x))
	    ))

(defun vm-imap-server (name) (cadr (assoc name vm-imap-server-alist)))

(setq vm-imap-server-list
      '(
         "imap:mail.alowe.com:143:inbox:login:a:*"
       )
)

(defun vm-view-as-html ()
  (interactive)
  ; assert: in vm presentation buffer
  (if (eq major-mode 'vm-summary-mode)
      (set-buffer (get-buffer "INBOX Presentation")))

  (let ((b (get-buffer-create "*w3m view*"))
	(view-exit-action 'bury-buffer)
	)
    (save-window-excursion
      (html-format-region (point-min) (point-max) b)
)
    )
  )

; (define-key vm-summary-mode-map "o" 'vm-view-as-html)

(defun vm-visit-inbox ()
  (interactive)
  (call-interactively 'vm-visit-imap-folder)
  )


(defun vm1 (folder)
  (interactive (list
		(cadr (assoc (completing-read "mail account: " vm-imap-server-alist nil t) vm-imap-server-alist))
		))
  (vm-visit-imap-folder folder)
  )

(defun vm-devr ()
  (interactive)
  (let  ((vm-imap-server-list '("imap:mail.alowe.com:143:inbox:login:devr:*")))
    (call-interactively 'vm-visit-imap-folder)
    )
  )

; (vm-devr)

(defun vm-net ()
  (interactive)
  (let  ((vm-imap-server-list '("imap:mail.alowe.com:143:inbox:login:net:*")))
    (call-interactively 'vm-visit-imap-folder)
    )
  )

; (vm-net)


; xxx wet paint
(defun vm-root ()
  (interactive)

  (let  ((vm-imap-server-list 
	  (list (vm-imap-server "root"))))

    (call-interactively 'vm-visit-imap-folder)
    )
  )

(provide 'pre-vm)
