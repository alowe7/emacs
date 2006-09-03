(defadvice gnuserv-edit-files (after 
			     hook-gnuserv-edit-files
			     first 
			     nil
			     activate)
  (raise-frame)
  )

; (if (ad-is-advised 'gnuserv-edit-files) (ad-unadvise  'gnuserv-edit-files))
