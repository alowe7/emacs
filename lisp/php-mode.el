(put 'php-mode 'rcsid
 "$Id: php-mode.el,v 1.1 2006-03-01 02:52:43 tombstone Exp $")

(define-derived-mode php-mode java-mode "PHP" "")
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(defvar *php-manual* "http://localhost/php-manual/")
(defun php-helpers ()
  (if (not (fboundp 'php-manual))
      (defun php-manual () 
	(interactive)
	(w3m-goto-url-new-session *php-manual*)
	)
    )
  )

(if (featurep 'w3m)
    (php-helpers)
  (add-hook 'w3m-load-hook 'php-helpers))
