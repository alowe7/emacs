(require 'reg)

;; default is to take these from the environment.
;; in windows land, try to pull initial values for these from the registry if env. vars not defined.

(setq wbase (or (getenv "WBASE") (queryvalue "machine" "Software\\Technology x\\tw" "wbase")))
(setq wtop (or (getenv "WTOP") (queryvalue "machine" "Software\\Technology x\\tw" "wtop")))


(chain-parent-file t)
