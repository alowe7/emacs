(setq wdirs (split (apply 'tw-command (nconc (list "fw") (lw)))))
; todo uniquify duplicates
(setq *howto-alist*
      (mapcar '(lambda (x) (list (basename x) x))
	      (loop for x in 
		    (loop for w in wdirs
			  with u=nil
			  nconc (loop for v in (get-directory-files w t "^n$\\|^x$") collect (canonify v 0))
			  into u
			  finally return u)
		    with z=nil
		    nconc
		    (loop for y in (get-directory-files x t)
			  when (or (string-match "\.xtx$" y) (not (string-match "\\.\\|~$" y)))
			  collect (canonify y 0))
		    into z
		    finally return z)
	      )
      )

;; version duh
;; (loop for x in (ff "/l/*/n/*") collect (list (basename x) x))

