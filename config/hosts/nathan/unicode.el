(put 'xdb 'rcsid
 "$Id: unicode.el,v 1.1 2006-09-04 19:04:52 nathan Exp $")

; tbd figure out why some systems like:
;	(vector 2303 2302 )
; some systems like:
;	"ÿþ" 
; and some prefer:
;	"��"

(setq *unicode-signature* "��")

(chain-parent-file t)

