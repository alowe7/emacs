(put 'unicode 'rcsid
 "$Id$")

; tbd figure out why some systems like:
;	(vector 2303 2302 )
; some systems like:
;	"ÿþ" 
; and some prefer:
;	"��"

(setq *unicode-signature* "��")

(chain-parent-file t)

