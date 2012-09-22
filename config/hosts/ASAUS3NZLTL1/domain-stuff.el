(defun nextpwreset ()
  "dumb helper to tell when I need to reset my passwords again"

  (interactive)
  (message (perl-command "/z/pl/nextpwreset"))
  )

; (nextpwreset)
