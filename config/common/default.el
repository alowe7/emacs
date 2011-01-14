(put 'default 'rcsid
 "$Id$")

(chain-parent-file t)


; the idea is to add the zt-init-hook only in a configuration where zt-loads is preloaded
; too much?
(add-hook 'zt-preload-hook '(lambda () (add-hook 'zt-init-hook '(lambda () (require 'zt-init)))))
