(put 'pod 'rcsid
 "$Id: pod.el,v 1.1 2007-05-09 19:16:33 tombstone Exp $")

; functions to facilitate using pod from emacs

(defvar pod2text (find-script "pod2text"))

(defun pod2text (f &optional buffer)
  "find pod for FILE in optional BUFFER"
  (interactive "ffile: ")
  (let* ((b (cond ((buffer-live-p buffer) buffer)
		  (t (zap-buffer (or buffer "*pod*"))))))
    (set-buffer b)
    (insert 
     (perl-command pod2text f))

  ; if window is visible in another frame, then raise it
    (if (and (not (get-buffer-window b))  
	     (get-buffer-window b t))
	(raise-frame
	 (select-frame
	  (window-frame 
	   (get-buffer-window b t)))))

    (pop-to-buffer b)
    (help-mode)
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (beginning-of-buffer)
    b)
  )


(defun perldoc2 (module)
  "find perldoc for MODULE where module is of the form XX::YY"
  (interactive "sModule: ")
  (if (string-match "::" module) (setq module (replace-in-string "::" "/" module)))
  (let* ((fn (loop for x in (mapcar 'expand-file-name (split (chomp (reg-query "machine" "software/perl" "sitelib")) ";"))
		  when (file-exists-p (concat x "/" module ".pm"))
		  return (concat x "/" module ".pm")))
	(b (if fn (zap-buffer (concat (file-name-sans-extension fn) " *pod*")))))
    (if b (progn
	    (pod2text fn b)
	    (set-buffer b)
	    (cd (file-name-directory fn))))
    ))


;(perldoc2 "XML::Parser")

;; these allow pod2text to catch non-found man pages, and if they're perl scripts, try to pod them.
(defun man-cooked-fn () 
  (if (= 0 (length (buffer-string)))
      (let* ((orig-man (cadr (split (cadr (split (buffer-name Man-buffer) "*")))))
	     (f (find-script orig-man)))
	(if f (save-window-excursion (pod2text f (current-buffer)))))))


(add-hook 'Man-cooked-hook 'man-cooked-fn)

(defun pod (&optional file)
  "if looking at a perl script containing pod, format it as text.
with optional FILE, operate on that"
  (interactive)
  (let ((fn (or file (buffer-file-name))))
    (pod2text fn
	      (concat (file-name-sans-extension fn) " *pod*"))
    )
  )

(defun dired-pod () (interactive)
  (let ((f (dired-get-filename)))
	(pod2text f (concat (file-name-sans-extension f) " *pod*"))))

(add-hook 'dired-load-hook
	  '(lambda () 
	     (define-key  dired-mode-map (vector 'f9) 'dired-pod)
	     )
	  )


(defmacro =pod (&rest args) "a blob of pod: plain old documentation" nil)

(=pod

=head1 NAME

	=pod

=head1 SYNOPSIS

	(=pod blob of pod)

=head1 DESCRIPTION

	this macro serves to just hid a blob of pod from the lisp parser.
	so just run pod2text on the elisp file and goodness results.

=cut
)

(provide 'pod)