(put 'escp2 'rcsid
 "$Id: escp2.el,v 1.1 2006-06-09 15:07:37 alowe Exp $")

; support for esc p2 compatible printers, e.g. from dos or dos emulation
; factored from os-init

; ESC-@ initialize printer
; ESC-l left margin
(defconst dos-print-header-format "@l%c")
(defconst dos-print-trailer "@" "special printing characters")

(defvar print-processes nil)
;(pop print-processes)
;(setq c (caar print-processes))
;(cdr (assq c  print-processes))

(defun print-process-sentinel (process msg)
  ;  (read-string (format "gotcha: %s" msg))
  (if (string-match "finished" msg) 
      (let ((a (assq process print-processes)))
	(setq print-processes (remq process print-processes))
	(and (file-exists-p (cdr a)) (delete-file (cdr a)))
  ;				(pop-to-buffer " *PRN*")
	)
    )
  )

(defconst esc-font-format "k%c")
(defconst esc-fonts '(Roman
		      SansSerif
		      Courier
		      Prestige
		      Script))
(defconst esc-proprotional "!")
