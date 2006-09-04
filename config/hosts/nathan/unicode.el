(put 'xdb 'rcsid
 "$Id: unicode.el,v 1.1 2006-09-04 19:04:52 nathan Exp $")

; tbd figure out why some systems like:
;	(vector 2303 2302 )
; some systems like:
;	"Ã¿Ã¾" 
; and some prefer:
;	"ÿþ"

(setq *unicode-signature* "ÿþ")

(chain-parent-file t)

