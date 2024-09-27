#Example for using linux man format to display extended help

_LIB_NAME=lib_man_format

cat <<EOF >/tmp/${_LIB_NAME}.1.man
.TH LIBCTL "1" "September 2024" "util-linux" "User Commands"
.SH NAME
libctl \- control shell libraries
.SH SYNOPSIS
.BI libct
.I [options] parameters
.br
.SH DESCRIPTION
.B libctl
is used to control shell libraries and their runtime behaviour.
.PP
The parameters
.B libctl
is called with can be divided into two parts: options which modify
the way
.B libctl
works. The second part are arguments to make libctl do things with the libraries invoked.
.PP
.SH OPTIONS
.TP
.BR \-a , " \-\-alternative"
Allow long options to start with a single
.RB ' \- '.
.TP
.BR \-h , " \-\-help"
Display help text and exit.  No other output is generated.
.TP
.PP
The syntax if you do not want any short option variables at all is
not very intuitive (you have to set them explicitly to the empty
string).
.SH AUTHOR
.MT s.obermeyer@t-online.de
Stefan Obermeyer
.ME
.SH "SEE ALSO"
.BR bash (1),
.BR grep (1),
.BR getopt (3)
.SH AVAILABILITY
The libctl command is part of the lib package and is available from
.br
.UR https://\:github.com\:/ora\:/shlib
KZVNR Oracle Scripts
.UE .
EOF
# read man page
man /tmp/${_LIB_NAME}.1.man
rm -f /tmp/${_LIB_NAME}.1.man
