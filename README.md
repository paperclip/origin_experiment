# origin_experiment
A set of tests for using $ORIGIN in setuid and capabilities.

Can a program load a library via $ORIGIN in runpath if it is suid? Or it if adds capabilities?

# Links
Pages supporting the idea that $ORIGIN should work for capability-adding binaries:

A bug report for Ubuntu glibc: https://bugs.launchpad.net/ubuntu/+source/glibc/+bug/565002

Converse pages suggesting that it shouldn't work:
https://stackoverflow.com/questions/39486866/using-origin-with-setuid-application-does-not-fail-as-expected
https://seclists.org/fulldisclosure/2010/Oct/257
https://sourceware.org/bugzilla/show_bug.cgi?id=12393#c0
http://web.archive.org/web/20041026003725/http://www.caldera.com/developers/gabi/2003-12-17/ch5.dynamic.html#substitution
