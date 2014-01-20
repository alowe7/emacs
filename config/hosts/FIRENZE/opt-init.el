(unless (> emacs-major-version 23)

  (progn
					; some extras
    (defvar *opt-site-lisp* '("/z/lucene/site-lisp" "/z/db")
      "list of optional/experimental projects that might be added to `load-path'")
					;   '("/z/w3m" "/z/nw" "/z/gpg")

    (when (boundp '*opt-site-lisp*)
      (loop for d in *opt-site-lisp* do (add-to-load-path d t)  )
      )

    (load-library "pre-w3m")
    (load-library "lucene")
    )
  )
