(put 'post-xdb 'rcsid 
 "$Id: post-xdb.el,v 1.13 2004-04-08 01:27:25 cvs Exp $")

(add-hook 'x-query-mode-hook '(lambda ()
				(loop for x across "/:\.-" do (modify-syntax-entry x "w"))
				))

; (pop x-query-mode-hook)
; (run-hooks (quote x-query-mode-hook))

