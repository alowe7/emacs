(put 'config 'rcsid 
 "$Id: config.el,v 1.6 2000-11-01 15:53:38 cvs Exp $")
(require 'advice)
(require 'cl)

;; this advice allows pre- and post- hooks on all loaded features
;; this way customization can be tailored to the feature instead of all lumped together
;; also see eval-after-load

(defvar *debug-pre-load-hook* nil)
(defvar *debug-post-load-hook* nil)

(defadvice load (around 
		 hook-load
		 first 
		 activate)

  "hook (load f) to optionally (load pre-f) (load f) (load post-f)
no errors if files don't exist.
 "
  (if (ad-is-advised 'load)
      (ad-disable-advice 
       'load
       'around
       'hook-load))

  (ad-activate 'load)

  (and *debug-pre-load-hook* (debug))
  (load (concat "pre-" (ad-get-arg 0)) t t)

  ad-do-it

    (and *debug-post-load-hook* (debug))
  (load (concat "post-" (ad-get-arg 0)) t t)

  (ad-enable-advice 
   'load
   'around
   'hook-load)
  (ad-activate 'load)
  )

; (ad-unadvise 'load)
; (ad-is-advised 'load)

; (defvar *debug-require-hook* t)

(defadvice require (around 
		    hook-require
		    first 
		    activate)

  "hook (require f) to optionally (load pre-f) (require f) (load post-f)
only if (not (featurep f))
no errors if files don't exist.
 "
  (if (featurep (ad-get-arg 0)) nil

  (if (ad-is-advised 'require)
      (ad-disable-advice 
       'require
       'around
       'hook-require))

    (ad-activate 'require)

; 		(and *debug-require-hook* (debug))
    (load (format "pre-%s" (ad-get-arg 0)) t t)

    ad-do-it

; 		(and *debug-require-hook* (debug))
    (load (format "post-%s" (ad-get-arg 0)) t t)

    (ad-enable-advice 
     'require
     'around
     'hook-require)
    (ad-activate 'require)
    )
  )

; (ad-unadvise 'require)
; (ad-is-advised 'require)



; warning: this fails for any built in functions, so ...
; we need to get fancy

(defmacro make-hook-name (fname)
  `(intern
    (concat "hook-" ,(symbol-name (eval fname)))
    )
  )
; (make-hook-name 'dired-mode)

(defmacro hookfn (fn &optional file)

  "this macro hooks the first invocation of FUNCTION from optional FILE.
it attempts to load a pair of libraries before proceeding with the call.  

the library names are constructed like: pre-<file>.el and post-<file>.el where
<file> defaults to the pname of the hooked function.  after loading the library, this
advice removes itself."

  (let* ((f (eval fn))
	 (hook-name (make-hook-name f))
	 (pre-lib-name (concat "pre-" (or (eval file) (symbol-name f))))
	 (post-lib-name (concat "post-" (or (eval file) (symbol-name f)))))

    `(defadvice ,f (around
		    ,hook-name
		    first 
		    activate)

       (load ,pre-lib-name t t)

       ad-do-it

; don't remove this advice until after invocation, or the advice
; package gets confused.

       (ad-remove-advice (quote ,f) 'around (quote ,hook-name))
       (ad-activate (quote ,f))

       (load ,post-lib-name t t)

       )
    )
  )

; (hookfn 'dired-mode)

(mapcar '(lambda (x) (hookfn x))
	'(cc-mode
	  dired-mode
	  perl-mode
	  sgml-mode
	  shell-mode
	  help-mode))

; (ad-is-advised 'dired-mode)
; (ad-is-advised 'shell-mode)

(provide 'config)

(defun addloadpath (dir &optional prepend)
  (let ((dir (substitute-in-file-name dir)))
    (cond ((not (member dir load-path))
	   (setq load-path
		 (apply 'nconc
			(if prepend 
			    (list (list dir) load-path)
			  (list load-path (list dir)))))
	   (run-hooks 'load-path-mod-hook)
	   dir)
	  )
    )
  )

; we need to apply some here on first invocation, since some functions come preloaded.

(defun post-wrap (f) 
  (load (format "post-%s" f) t t)
  )

(let ((l '("compile" "cl")))
  (loop for x in l
	do
	(or (member
	     `(,x (post-wrap ,x)) after-load-alist)
	    (push 
	     `(,x (post-wrap ,x)) after-load-alist))
	))
; (pop after-load-alist)
