(put 'post-comint 'rcsid
 "$Id$")

(chain-parent-file t)

(add-to-list 'comint-output-filter-functions 'comint-watch-for-password-prompt)
