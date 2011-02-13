(put 'escp2 'rcsid
 "$Id$")

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

(defun relt (sequence val)
  "reverse elt: return n of sequence whose value equals val"
  (let ((len (length sequence)))
    (loop with i = 0
	  when (equal (elt sequence i) val) return i
	  when (> i len) return nil
	  do (setq i (1+ i))))
  )

(defun* dos-print-region (from to &key font fixed)

  "print REGION as text.
 with prefix ARG, use that as left margin.
 see dos-print-header for default parameters."

  (interactive "r")

  (let* ((dos-print-header
	  (format dos-print-header-format
		  (or current-prefix-arg 2)))
	 (esc-font (relt esc-fonts font))
	 (s (buffer-substring from to))
	 (b (generate-new-buffer " *print*"))
	 (fn (concat "c:\\tmp\\" (make-temp-name (format "__%s" (gensym)))))
	 p)
    (set-buffer b)
    (insert dos-print-header)
    (and esc-font (insert (format esc-font-format esc-font)))
    (unless fixed (insert esc-proprotional))
    (insert s)
    (insert dos-print-trailer)
    (write-region (point-min) (point-max) fn)
    (kill-buffer b)
  ; use process-sentinel to catch completion
  ;		(call-process "cmd" nil 0 nil "/c" "print" fn)
    (set-process-sentinel 
     (setq p (start-process "prn" (get-buffer-create " *PRN*") "cmd" "/c" "print" fn))
     'print-process-sentinel)
    (push (cons p fn) print-processes)
    )
  )

(defun dos-print-buffer ()
  (interactive)
  (dos-print-region (point-min) (point-max))
  )
 
(defun dos-print (file) 
  (interactive "fFile: ")
  (let* ((ob (find-buffer-visiting file))
	 (b (or ob (find-file-noselect file))))
    (if b
	(with-current-buffer b
	  (dos-print-buffer)))
    (or ob (kill-buffer b))))
