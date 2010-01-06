(put 'post-man 'rcsid
 "$Id: post-man.el,v 1.1 2010-01-06 02:31:53 alowe Exp $")

(setq Man-filter-list
      '(("sed" "" "-e '/^[-][-]*$/d'" "-e '/[789]/s///g'" "-e '/Reformatting page.  Wait/d'" "-e '/Reformatting entry.  Wait/d'" "-e '/^[ 	]*Hewlett-Packard[ 	]Company[ 	]*-[ 	][0-9]*[ 	]-/d'" "-e '/^[ 	]*Hewlett-Packard[ 	]*-[ 	][0-9]*[ 	]-.*$/d'" "-e '/^[ 	][ 	]*-[ 	][0-9]*[ 	]-[ 	]*Formatted:.*[0-9]$/d'" "-e '/^[ 	]*Page[ 	][0-9]*.*(printed[ 	][0-9\\/]*)$/d'" "-e '/^Printed[ 	][0-9].*[0-9]$/d'" "-e '/^[ 	]*X[ 	]Version[ 	]1[01].*Release[ 	][0-9]/d'" "-e '/^[A-Za-z].*Last[ 	]change:/d'" "-e '/^Sun[ 	]Release[ 	][0-9].*[0-9]$/d'" "-e '/[ 	]*Copyright [0-9]* UNIX System Laboratories, Inc.$/d'" "-e '/^[ 	]*Rev\\..*Page [0-9][0-9]*$/d'")
	;; this phrase causes problems
  ; ("awk" "'\n" "BEGIN { blankline=0; anonblank=0; }\n" "/^$/ { if (anonblank==0) next; }\n" "{ anonblank=1; }\n" "/^$/ { blankline++; next; }\n" "{ if (blankline>0) { print \"\"; blankline=0; } print $0; }\n" "'"))

	))

