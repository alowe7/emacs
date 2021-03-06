(put 'locations 'rcsid
 "$Id$")

(require 'canonify)
(require 'regtool)
(require 'typesafe)

(defun substitute-expand-file-name (f)
  (expand-file-name (substitute-in-file-name f))
  )

(defun w32-environment-variable (s)
  (unix-canonify
   (if (string-match "%\\([^%]+\\)%" s)
       (concat (substring s 0 (match-beginning 0)) 
	       "$"
	       (substring s (match-beginning 1) (match-end 1))
	       (substring s (match-end 0)))
     s
     )
   )
  )

(defun personal-folders ()
  (w32-environment-variable
   (regtool "get" "/user/Software/Microsoft/Windows/CurrentVersion/Explorer/User Shell Folders/Personal"))
  )

(loop for x in `(
		 (all-users-profile "$ALLUSERSPROFILE")
		 (user-profile "$USERPROFILE")
		 (desktop "$USERPROFILE/Desktop")
		 (downloads "$USERPROFILE/Downloads")
		 (documents "$USERPROFILE/Documents")
		 (pictures "$USERPROFILE/Pictures")
		 (my-documents
		  ,(or
		    (string*
		     (personal-folders))
		    "$USERPROFILE/My Documents")
		  )
		 (my-favorites "$USERPROFILE/Favorites")
		 (my-links "$USERPROFILE/Favorites/Links")
		 (start-menu "$USERPROFILE/Start Menu")
  ; 		 (quicklaunch "$USERPROFILE/Application Data/Microsoft/Internet Explorer/Quick Launch")
		 (my-templates "C:/Documents and settings/$USERNAME/Application Data/Microsoft/Templates")
		 )
      do
      (unless (fboundp `,(car x))
	(eval `(defun ,(car x)  () (interactive) (dired (substitute-expand-file-name ,(cadr x))))))
      (unless (boundp `,(car x))
	(eval `(defvar ,(car x)  ,(canonify (cadr x))))
	)
      )

(provide 'locations)
