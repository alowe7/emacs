(put 'perl-helpers 'rcsid
 "$Id: perl-helpers.el,v 1.1 2004-01-25 20:35:51 cvs Exp $")

(chain-parent-file t)

(setq perlfunc-file "/usr/lib/perl5/5.8.0/pod/perlfunc.pod"
      perlfunc-buffer-name "perlfunc *pod*")

(defun perlfunc (func)
  (interactive "sfunc: ")
  (if (string-match "::" func)
      (let ((module (substring func 0 (match-beginning 0)))
            (func (substring func (match-end 0))))
        (perlmod module)
        (search-forward func)
        )
      (let* ((b (get-buffer (progn 
                (and (not (buffer-exists-p perlfunc-buffer-name)) 
                     (pod2text perlfunc-file (get-buffer-create perlfunc-buffer-name)))
                perlfunc-buffer-name))) 
           p)
    (save-excursion
      (set-buffer b)
      (goto-char (point-min))
      (setq p (and (re-search-forward (format "^    %s[^a-z]" func) nil t)
                   (backward-word 1)
                   (point)))
      )
      (if p 
          (progn 
            (unless (eq b (current-buffer))
              (switch-to-buffer-other-window b))
            (goto-char p))
        (message (format "%s not found" func))
        )
      )
    )
  )