(require 'fb)

(setq picpat "\"gif$\\|jpg$\\|bmp$\\|png$\\|tif$\"")

(defun fpic ()
  "fast find all drives -- search for file matching pat in *:`cat *fb-db*`"
  (interactive)

  (let ((b (zap-buffer "*fpic*")))
    (loop 
     for d in '("c" "e")
     do

     (let ((s (eval-process "egrep" "-i" picpat (format "%s:%s" d *fb-db*))))
       (set-buffer b)
       (insert s)
       )
     )

    (pop-to-buffer b)
    (beginning-of-buffer)
    (cd "/")
    (fb-mode)
    )
  )
