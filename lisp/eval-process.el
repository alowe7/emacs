;; a package to return process evaulation as a string

(provide 'eval-process)
(require 'zap)

;; processes that return values

(defun eval-process (cmd &rest args)
  "execute CMD as a process, giving it optional ARGS.
this function evaluates to the process output  "
  (let
      ((buffer (get-buffer-create " *eval*"))
       v)
    (save-excursion
      (set-buffer buffer)
      (erase-buffer)
      (apply 'call-process (nconc (list cmd nil (list buffer nil) nil) args))
  ;    (set-buffer buffer)
  ;    (setq v (buffer-string))
  ;    (kill-buffer buffer) ; may be faster not to bother with this.
  ;    v
      (buffer-string)
      )
    )
  )

(defun eval-process-1 (cmd &rest args)
  "execute CMD as a process, giving it optional ARGS.
this function evaluates to the process output  "
  (let
      ((buffer (prog1 (set-buffer (get-buffer-create " *tmp*")) (erase-buffer)))
       v)
    (apply 'call-process (nconc (list cmd nil (list buffer nil) nil) args))
    (set-buffer buffer)
    (setq v (buffer-string))
    (kill-buffer buffer) ; may be faster not to do this.
    (replace-letter (chop v) "
 " ? )
    )
  )


(defun insert-eval-process (line)
  " insert results of executing COMMAND into current buffer"
  (interactive "scommand: ")
  (let* ((cmd (string-to-word line)) (args (substring line (match-end 0))))
    (insert (eval-process cmd (and (> (length args) 0) args)))))

;; todo -- rewrite to use &rest

(defun eval-string (cmd &optional arg)
	"special case of eval-process taking CMD and one ARG.
cleans up linefeeds in resulting output"
	(clean-string (eval-process cmd arg))
	)

;; this is here because it is mostly used to clean up ^J's from eval-process output

(defun replace-letter (s old-letter &optional new-letter)
  (let* ((ol (if (and (stringp old-letter) (> (length old-letter) 0))
		(aref old-letter 0) old-letter))
	(nl (if (and (stringp new-letter) (> (length new-letter) 0))
		     (aref new-letter 0) new-letter))
	(fn (if nil
		'(lambda (x) (char-to-string (if (char-equal x ol) nl x)))
	      '(lambda (x) (if (char-equal x ol) nl (char-to-string x)))
	      )))
    (mapconcat fn s ""))
  )

;; this is no reason to (require 'cl)
;; (defun replace-letter (s old-letter &optional new-letter)
;;   "modify STRING replacing OLD-LETTER with NEW-LETTER" 
;;   (let ((ol (if (stringp old-letter) (aref old-letter 0) old-letter))
;; 	(nl (if (string* new-letter) (aref new-letter 0) new-letter)))
;; 
;;     (if nl
;; 	(loop for x across s 
;; 	      collect (if (eq x ol) nl x) into l
;; 	      finally return (concat (apply 'vector l)))
;;       (loop for x across s 
;; 	    when (not (eq x ol))
;; 	    collect x into l
;; 	    finally return (concat (apply 'vector l)))
;;       )
;;     )
;;   )

(defun clean-string (s &optional c)
  "replace occurrences of ^J in STRING with CHAR (default nil)"
  (replace-letter s "
" c)
  )

;;; *** from c-fill.el ***

(defun re-clean-string (from s &optional to)
  "replace regexp FROM in string S to string TO (default nil)"
  (let ((pos 0)
	(new "")) 
    (while (string-match from s pos)
      (setq new (concat new (substring s pos (match-beginning 0)) to))
      (setq pos (match-end 0))
      )
    (concat new (substring s pos))
  )
)


(defun chop (s &optional c)
  "maybe chop trailing linefeed"
  (if (eq (aref (substring s -1) 0) (or c ?
					)	  ) (substring s 0 -1) s)
  )
