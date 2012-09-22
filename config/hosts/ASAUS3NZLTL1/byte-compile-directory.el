(add-to-list 'load-path ".")
(add-to-list 'load-path  (car (directory-files "/usr/share/emacs/site-lisp" t "^x-"))) 
(setq byte-compile-warnings '(not cl-functions free-vars unresolved))