(require 'long-comment)

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

(/*

 (let (l (s " GGooaall AArreeaaPPrriimmaarryy OObbjjeeccttiivveeP Pr  riimma ar  ryy  IIn ni it  tiiaatti iv ve  e"))
   (mapconcat 'char-to-string (loop with p = ?  for x across s unless (= p x) nconc (list (setq p x)) into l finally return l) "")
   )

(defun dribble ()
  (interactive)
  (let ((s (buffer-string)) (b (zap-buffer "*dribble*")))
    (with-current-buffer b
      (insert
       (mapconcat 'char-to-string (loop with p = ?  for x across s unless (= p x) nconc (list (setq p x)) into l finally return l) ""))
      (goto-char (point-min))
      )
    (switch-to-buffer b)
    )
  )

 */)