"ÿþ"
(put 'unicode 'rcsid
 "$Id$")

(defvar *unicode-signatures* (list
			      (vector 2303 2302 )
			      "Ã¿Ã¾"
			      "ÿþ"))

(defun is-utf8-p ()
  " determine if current buffer is utf8 encoded by looking at the signature
not sure why different versions require various `*unicode-signatures*' 
"
  (loop for x in  *unicode-signatures* thereis
	(save-excursion
	  (goto-char (point-min))
	  (condition-case x 
	      (looking-at x) 
	    (wrong-type-argument nil))))
  )

(defun utf8-hook () (interactive)
  (if (is-utf8-p)
      (fix-unicode-file))
  )

(add-hook 'find-file-hooks 'utf8-hook)

;; todo: put this on file load hook, with utf8 recognition/view only

(setq *unicode-uglies* '(
			 (?‐ ; 8208
			  "-" )
			 (?– ; 8211
			  "-" )
			 (?— ; 8212
			  "--" )
			 (?― ; 8213
			  "--" )
			 (?‘ ; 8216
			  "`" )
			 (?’ ; 8217
			  "'" )
			 (?‚ ; 8218
			  "," )
			 (?“ ; 8220
			  "\"" )
			 (?” ; 8221
			  "\"" )
			 (?„ ; 8222
			  "\"" )
			 (?† ; 8224
			  "+" )
			 (?‡ ; 8225
			  "++" )
			 (?• ; 8226
			  "-" )
			 (?… ; 8230
			  "..." )
			 (?‰ ; 8240
			  "%" )
			 (?‹ ; 8249
			  "<" )
			 (?› ; 8250
			  ">" )
			 (?‽ ; 8253
			  "?" )
			 (?⁄ ; 8260
			  "/" )
			 ))


(defun fix-unicode-file () (interactive)
  (save-excursion
    (if (is-utf8-p)
	(progn
	  (goto-char (point-min))
	  (delete-char 2)
	  (while (not (eobp))
	    (forward-char 1)
	    (delete-char 1))
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only t)
	  (auto-save-mode -1)
	  (add-hook 'local-write-file-hooks (function (lambda () (message "cannot edit unicode file") t)))
	  )
      )

  ; regardless of whether file is utf8, remap these high-code-page unicode chars
    (tr (current-buffer)  *unicode-uglies*)
    )
  )
(fset 'unicode-fix-file 'fix-unicode-file)

(defun dired-find-unicode-file ()
  (interactive)
  (let ((find-file-hook (remove* 'utf8-hook find-file-hook)))
    (find-file (dired-get-filename))
    )
  )

(add-hook 'dired-mode-hook 
	  (function (lambda nil 
	     (define-key  dired-mode-map "F" 'dired-find-unicode-file)
	     )))


(provide 'unicode)
