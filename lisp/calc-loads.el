(put 'calc-loads 'rcsid "$Id: calc-loads.el,v 1.4 2000-10-03 16:44:06 cvs Exp $")
(provide 'calc-loads)
(defvar var-TimeZone '(+ (var GMT var-GMT) 6))
;;; Variable "var-Holidays" stored by Calc on Mon May 11 20:57:43 1998
(setq var-Holidays '(vec (var sat var-sat) (var sun var-sun)))

;;; Variable "var-Decls" stored by Calc on Mon May 11 20:57:44 1998
(setq var-Decls '(vec))

;;; Commands added by calc-private-autoloads on Fri Jan 07 10:05:52 2000.
(autoload 'calc-dispatch	   "calc" "Calculator Options" t)
(autoload 'full-calc		   "calc" "Full-screen Calculator" t)
(autoload 'full-calc-keypad	   "calc" "Full-screen X Calculator" t)
(autoload 'calc-eval		   "calc" "Use Calculator from Lisp")
(autoload 'defmath		   "calc" nil t t)
(autoload 'calc			   "calc" "Calculator Mode" t)
(autoload 'quick-calc		   "calc" "Quick Calculator" t)
(autoload 'calc-keypad		   "calc" "X windows Calculator" t)
(autoload 'calc-embedded	   "calc" "Use Calc inside any buffer" t)
(autoload 'calc-embedded-activate  "calc" "Activate =>'s in buffer" t)
(autoload 'calc-grab-region	   "calc" "Grab region of Calc data" t)
(autoload 'calc-grab-rectangle	   "calc" "Grab rectangle of data" t)
(setq load-path (nconc load-path (list "c:/usr/local/lib/emacs-20.5/site-lisp/calc-2.02f")))
(global-set-key "\e#" 'calc-dispatch)
;;; End of Calc autoloads.
