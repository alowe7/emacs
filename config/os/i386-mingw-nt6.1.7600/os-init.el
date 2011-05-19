(put 'os-init 'rcsid
 "$Id$")

; (read-string "hey!  you!")

; this  is actually not x64, but rather a perl5.10 issue:
(setq perldir "c:/Perl64")
(setq perlfunc-pod (concat (expand-file-name "lib/pods" perldir)  "/perlfunc.pod"))
;(assert (file-exists-p perlfunc-pod))

; put here tweaks necessary for x64
