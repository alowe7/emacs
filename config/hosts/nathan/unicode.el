(put 'unicode 'rcsid
 "$Id: unicode.el,v 1.2 2006-09-04 19:05:51 nathan Exp $")

; tbd figure out why some systems like:
;	(vector 2303 2302 )
; some systems like:
;	"ÿþ" 
; and some prefer:
;	"��"

(setq *unicode-signature* "��")

(chain-parent-file t)

