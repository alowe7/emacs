(defun replace-pattern (pat rep &optional n)
  "replace all ocurrences of PAT in current buffer with REP.
"
  (goto-char (point-min))
  (while 
      (re-search-forward pat nil t) 
    (replace-match rep)
    )
  )


(defun fix-prn-file ()
  (interactive)

  (save-excursion

    (replace-pattern "
            " " ")

    (replace-pattern "
" "")

    (loop
     for i from 80 downto 0 do

     (kill-pattern (concat "" (make-string i ? )))

     )


    (kill-pattern "")

    (goto-char (point-min))
    (while (search-forward "." nil t)
      (replace-match ".  " nil t))

    (goto-char (point-min))
    (while (search-forward "," nil t)
      (replace-match ",  " nil t))

    )
  )

