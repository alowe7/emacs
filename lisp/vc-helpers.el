
;; just a reminder:
;; todo: sort CVS/Entries file by date

(defun sort-cvs-entries-by-date

  (split (bgets) "/")
  (apply 'eval-process (list "date" (format "-d \"%s\"" (nth 3 (split (bgets) "/"))) "+\"%%s\""))

  )
