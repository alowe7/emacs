(put 'xosus-oblist 'rcsid 
 "$Id: xosus-oblist.el,v 1.4 2000-10-03 16:50:29 cvs Exp $")

(defvar xosus-oblist (quote (("a64l" 36235) ("abort" 38572) ("abs" 40474) ("access" 41407) ("acos" 44420) ("acosh" 46418) ("advance" 47849) ("alarm" 48517) ("asctime" 50384) ("asin" 52674) ("asinh" 54846) ("assert" 55104) ("atan" 56372) ("atan2" 57821) ("atanh" 59519) ("atexit" 59798) ("atof" 61316) ("atoi" 62504) ("atol" 63704) ("basename" 64978) ("bcmp" 66019) ("bcopy" 66798) ("brk" 67554) ("bsd" 70049) ("bsearch" 71876) ("bzero" 75740) ("calloc" 76345) ("catclose" 78990) ("catgets" 79865) ("catopen" 81637) ("cbrt" 85945) ("ceil" 86462) ("cfgetispeed" 88647) ("cfgetospeed" 89958) ("cfsetispeed" 91270) ("cfsetospeed" 92679) ("chdir" 94079) ("chmod" 96253) ("chown" 100860) ("chroot" 105494) ("clearerr" 108130) ("clock" 108617) ("close" 110798) ("closedir" 114756) ("closelog" 115879) ("compile" 120774) ("confstr" 121457) ("cos" 124463) ("cosh" 126082) ("creat" 127431) ("crypt" 128335) ("ctermid" 129956) ("ctime" 131627) ("cuserid" 133368) ("daylight" 135951) ("dbm" 136226) ("difftime" 143152) ("dirname" 143829) ("div" 145571) ("drand48" 146621) ("dup" 151994) ("ecvt" 154152) ("encrypt" 156966) ("endgrent" 159125) ("endpwent" 161286) ("endutxent" 163451) ("environ" 167863) ("erand48" 168288) ("erf" 168721) ("errno" 170814) ("exec" 173320) ("exit" 185569) ("exp" 190478) ("expm1" 191904) ("fabs" 192984) ("fattach" 194287) ("fchdir" 197388) ("fchmod" 198443) ("fchown" 199529) ("fclose" 200629) ("fcntl" 203757) ("fcvt" 213702) ("FD" 214006) ("fdetach" 214411) ("fdopen" 216498) ("feof" 219182) ("ferror" 219910) ("fflush" 220614) ("ffs" 223456) ("fgetc" 224042) ("fgetpos" 227567) ("fgets" 228536) ("fgetwc" 230105) ("fgetws" 232845) ("fileno" 234411) ("floor" 235235) ("fmod" 237272) ("fmtmsg" 239759) ("fnmatch" 245276) ("fopen" 248371) ("fork" 254178) ("fpathconf" 257431) ("fprintf" 257851) ("fputc" 274622) ("fputs" 278046) ("fputwc" 279416) ("fputws" 282287) ("fread" 283415) ("free" 285424) ("freopen" 287006) ("isalpha" 291293) ("fscanf" 293096) ("fseek" 310389) ("fsetpos" 315606) ("fstat" 316734) ("fstatvfs" 319205) ("fsync" 321400) ("ftell" 322872) ("ftime" 323924) ("ftok" 325069) ("ftruncate" 326982) ("ftw" 329829) ("fwrite" 335224) ("gamma" 337057) ("gcvt" 337806) ("getc" 338081) ("getchar" 339498) ("getcontext" 340543) ("getcwd" 343473) ("getdate" 345448) ("getdtablesize" 352212) ("getegid" 352963) ("getenv" 353913) ("geteuid" 355641) ("getgid" 356574) ("getgrent" 357510) ("getgrgid" 357805) ("getgrnam" 359696) ("getgroups" 361697) ("gethostid" 363562) ("getitimer" 364178) ("getlogin" 366874) ("getmsg" 369366) ("getopt" 376307) ("getpagesize" 382462) ("getpass" 383314) ("getpgid" 385689) ("getpgrp" 386760) ("getpid" 387748) ("getpmsg" 388729) ("getppid" 389060) ("getpriority" 390083) ("getpwent" 393207) ("getpwnam" 393495) ("getpwuid" 395916) ("getrlimit" 398149) ("getrusage" 402547) ("gets" 403914) ("getsid" 405599) ("getsubopt" 406651) ("gettimeofday" 408918) ("getuid" 409696) ("getutxent" 410656) ("getw" 411040) ("getwc" 412833) ("getwchar" 413890) ("getwd" 414567) ("glob" 415660) ("gmtime" 423940) ("grantpt" 425264) ("hcreate" 426593) ("hdestroy" 427008) ("hsearch" 427405) ("hypot" 431974) ("iconv" 433552) ("iconv_close" 439589) ("iconv_open" 440379) ("ilogb" 442281) ("index" 443125) ("initstate" 443688) ("insque" 447144) ("ioctl" 450469) ("isalnum" 477335) ("isalpha" 478778) ("isascii" 480214) ("isastream" 480825) ("isatty" 481522) ("iscntrl" 482764) ("isdigit" 484192) ("isgraph" 485463) ("islower" 486913) ("isnan" 488323) ("isprint" 488990) ("ispunct" 490426) ("isspace" 491862) ("isupper" 493294) ("iswalnum" 494743) ("iswalpha" 496093) ("iswcntrl" 497390) ("iswctype" 498671) ("iswdigit" 500817) ("iswgraph" 502054) ("iswlower" 503369) ("iswprint" 504663) ("iswpunct" 505951) ("iswspace" 507242) ("iswupper" 508540) ("iswxdigit" 509846) ("isxdigit" 511090) ("j0" 512375) ("jrand48" 513882) ("kill" 514403) ("killpg" 517918) ("l64a" 518566) ("labs" 518828) ("lchown" 519410) ("lcong48" 521442) ("ldexp" 521885) ("ldiv" 523554) ("lfind" 524530) ("lgamma" 525199) ("link" 527737) ("localeconv" 531687) ("localeconv" 532679) ("localtime" 538833) ("lockf" 540306) ("log" 545916) ("log" 546842) ("log10" 548285) ("log1p" 549729) ("logb" 550612) ("longjmp" 551531) ("longjmp" 553467) ("lrand48" 556183) ("lsearch" 556682) ("lseek" 559867) ("lstat" 561985) ("makecontext" 563846) ("malloc" 565428) ("mblen" 567563) ("mbstowcs" 569651) ("mbtowc" 571371) ("memccpy" 573734) ("memchr" 574911) ("memcmp" 575857) ("memcpy" 577128) ("memmove" 578322) ("memset" 579146) ("mkdir" 579924) ("mkfifo" 583265) ("mknod" 586605) ("mkstemp" 590361) ("mktemp" 591723) ("mktime" 592838) ("mmap" 595495) ("modf" 604173) ("mprotect" 605709) ("mrand48" 607400) ("msgctl" 607881) ("msgget" 611061) ("msgrcv" 613728) ("msgsnd" 618054) ("msync" 622208) ("munmap" 625003) ("nextafter" 626249) ("nftw" 627245) ("nice" 631358) ("langinfo" 633145) ("nrand48" 634654) ("open" 635016) ("opendir" 644874) ("openlog" 648189) ("fpathconf" 648491) ("fpathconf" 648971) ("pause" 655175) ("pclose" 656596) ("perror" 658757) ("pipe" 660477) ("poll" 662394) ("popen" 667210) ("pow" 671374) ("printf" 673366) ("ptsname" 673983) ("putc" 675070) ("putchar" 676232) ("putenv" 676635) ("putmsg" 678590) ("puts" 684295) ("pututxline" 685621) ("putw" 685910) ("putwc" 687189) ("putwchar" 688252) ("qsort" 688664) ("raise" 690116) ("rand" 690772) ("random" 692959) ("read" 693203) ("readdir" 703916) ("readlink" 708223) ("readv" 709914) ("realloc" 710208) ("realpath" 713075) ("re_comp" 714789) ("regcmp" 720301) ("regcomp" 724339) ("regex" 735549) ("expressions" 735900) ("remainder" 749969) ("remove" 751159) ("remque" 752410) ("rename" 752663) ("rewind" 759351) ("rewinddir" 760167) ("rindex" 761790) ("rint" 762353) ("rmdir" 763443) ("sbrk" 767935) ("scalb" 768220) ("scanf" 769584) ("seed48" 770217) ("seekdir" 770664) ("select" 772173) ("semctl" 778809) ("semget" 784937) ("semop" 788179) ("setbuf" 794402) ("setcontext" 795356) ("setgid" 795629) ("setgrent" 797320) ("setitimer" 797587) ("setjmp" 797927) ("setjmp" 798202) ("setkey" 800730) ("setlocale" 802554) ("setlogmask" 807384) ("setpgid" 807669) ("setpgrp" 810243) ("setpriority" 811024) ("setregid" 811340) ("setreuid" 813010) ("setrlimit" 814530) ("setsid" 814848) ("setstate" 816458) ("setuid" 816721) ("setutxent" 818492) ("setvbuf" 818761) ("shmat" 820785) ("shmctl" 824017) ("shmdt" 827344) ("shmget" 829211) ("sigaction" 832550) ("sigaddset" 856748) ("sigaltstack" 858110) ("sigdelset" 861788) ("sigemptyset" 863148) ("sigfillset" 864060) ("sighold" 865004) ("siginterrupt" 865319) ("sigismember" 866590) ("siglongjmp" 868143) ("void" 870382) ("sigpause" 877185) ("sigpause" 877621) ("sigpending" 877889) ("sigprocmask" 878578) ("sigrelse" 881223) ("sigsetjmp" 881558) ("sigstack" 884257) ("sigsuspend" 887941) ("sin" 889665) ("sinh" 891305) ("sleep" 892853) ("sprintf" 895616) ("sqrt" 896222) ("srand" 897515) ("srand48" 897994) ("srandom" 898417) ("sscanf" 898689) ("stat" 899252) ("statvfs" 903095) ("stderr" 903386) ("step" 905024) ("strcasecmp" 905708) ("strcat" 907149) ("strchr" 908427) ("strcmp" 909468) ("strcoll" 910690) ("strcpy" 912588) ("strcspn" 913902) ("strdup" 914864) ("strerror" 915637) ("strfmon" 917573) ("strftime" 924103) ("strlen" 931843) ("strncasecmp" 932747) ("strncat" 933061) ("strncmp" 934251) ("strncpy" 935605) ("strpbrk" 937074) ("strptime" 938074) ("strrchr" 944559) ("strspn" 945574) ("strstr" 946540) ("strtod" 947664) ("strtok" 951979) ("tan" 952805) ("tanh" 954731) ("tcdrain" 956041) ("tcflow" 958310) ("tcflush" 961319) ("tcgetattr" 964075) ("tcgetpgrp" 965923) ("tcgetsid" 967787) ("tcsendbreak" 968668) ("tcsetattr" 971298) ("tcsetpgrp" 976673) ("tdelete" 978689) ("telldir" 979347) ("tempnam" 980488) ("tfind" 982876) ("time" 983515) ("times" 984444) ("timezone" 986589) ("tmpfile" 987082) ("tmpnam" 988963) ("toascii" 990538) ("tolower" 991051) ("tolower" 991797) ("toupper" 993050) ("toupper" 993792) ("towlower" 995009) ("towupper" 996258) ("truncate" 997484) ("tdelete" 997774) ("ttyname" 1005200) ("ttyslot" 1006374) ("twalk" 1007471) ("tzname" 1007988) ("tzset" 1008391) ("ualarm" 1010005) ("ulimit" 1011470) ("umask" 1013891) ("uname" 1015504) ("ungetc" 1017095) ("ungetwc" 1019481) ("unlink" 1021438) ("unlockpt" 1025892) ("usleep" 1026752) ("utime" 1028684) ("utimes" 1032229) ("valloc" 1034714) ("vfork" 1035859) ("vfprintf" 1038807) ("wait" 1040404) ("wait3" 1049421) ("waitid" 1050603) ("waitpid" 1053025) ("wcscat" 1053359) ("wcschr" 1054222) ("wcscmp" 1055109) ("wcscoll" 1056071) ("wcscpy" 1057557) ("wcscspn" 1058446) ("wcsftime" 1059174) ("wcslen" 1060605) ("wcsncat" 1061237) ("wcsncmp" 1062240) ("wcsncpy" 1063309) ("wcspbrk" 1064649) ("wcsrchr" 1065398) ("wcsspn" 1066301) ("wcstod" 1067018) ("wcstok" 1070881) ("wcstol" 1073054) ("wcstombs" 1077458) ("wcstoul" 1079232) ("wcswcs" 1083861) ("wcswidth" 1084763) ("wcsxfrm" 1085846) ("wctomb" 1088055) ("wctype" 1090038) ("wcwidth" 1091644) ("wordexp" 1092544) ("write" 1099629) ("y0" 1111512))))
