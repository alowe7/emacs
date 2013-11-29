; hack load-path

(let ((hackdirs 
       (nconc
	(list
	 "."
	 "~/emacs/lisp"
	 "/src/emacs/config/os/W32"
	 "/src/emacs/config/common/"
	 (expand-file-name (concat "os/" (symbol-name window-system)) "~/emacs/config/")
	 (expand-file-name (concat "hosts/"  (system-name)) "~/emacs/config/")
	 )
 
	(mapcar
	 (lambda (pat) (car (directory-files "/usr/share/emacs/site-lisp" t (concat "^" pat))))
	 '("auto-complete-" "x-" "w3m" "db-")
	 )
	)
       )
      )
  (mapc (lambda (dir) (add-to-list 'load-path dir)) hackdirs)
  ;  hackdirs
  )
 

(setq byte-compile-warnings '(not cl-functions free-vars unresolved))
