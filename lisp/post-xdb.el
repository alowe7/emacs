(put 'post-xdb 'rcsid 
 "$Id: post-xdb.el,v 1.12 2003-11-24 21:50:38 cvs Exp $")

(add-hook 'x-query-mode-hook '(lambda ()
				(loop for x across "/:\.-" do (modify-syntax-entry x "w"))
				))

; (pop x-query-mode-hook)
; (run-hooks (quote x-query-mode-hook))
