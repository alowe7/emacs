(put 'unicode 'rcsid
 "$Id$")

; tbd figure out why some systems like:
;	(vector 2303 2302 )
; some systems like:
;	"Ã¿Ã¾" 
; and some prefer:
;	"ÿþ"

(setq *unicode-signature* "ÿþ")

(chain-parent-file t)

