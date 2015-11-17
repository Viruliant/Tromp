#!/bin/bash
#    Copyright © 2015 Roy Pfund all rights reserved.
#    Use of this software and  associated  documentation  files  (the
#    "Software"), is governed by a MIT-style  License(the  "License")
#    that can be found in the LICENSE file. You should have  received
#    a copy of the License along with this Software. If not, see
#        http://Viruliant.GitHub.io/LICENSE-1.0.txt
#    ________________________________________________________________

ISO_8601=`date -u "+%FT%TZ"` #ISO 8601 Script Start UTC Time
utc=`date -u "+%Y.%m.%dT%H.%M.%SZ"` #UTC Time (filename safe)
owd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Path to THIS script.
#_______________________________________________________________________________

cd "$owd"

LCParse () {
	echo ""
	echo -n "$1" | cat parse.Blc - | ./LC;
	echo ""
	echo " = $1"
}

LCReduce () {
	LCParse "$1";
	echo -e "Reduces to"
	echo -n "$1" | cat parse.Blc - | ./LC | cat symbolic.Blc - | ./LC
}

Parse2Binary () {
	echo -n "$1" | cat parse.Blc - | ./LC | cat deflate.Blc - | ./LC
}
#Bound and Free variable collisions in de bruijn notation:

#00 00 00 01 00 00 00 01 01 1110 10 01 110 10 1110
#`\ \ \ (\ \ \ (3 1) (2 1)) 3
LCReduce "\a \b \c (\a \b \c (a c) (b c)) a"

#00 00 00 01 00 00 00 01 01 1110 10 01 110 10 1111110
#\ \ \ (\ \ \ (3 1) (2 1)) 6 = 
LCReduce "\a \b \c (\d \e \f d f (e f)) a"

exit; _________________________________________________________________________

echo -en "00000001" | cat deflate.Blc - | ./LC > ./1.bin
cat inflate.Blc - | ./LC > ./rev.Blc

#hexdump -e '16/1 "%02x"' file
#4444681601791a00167ffbcbcfdf65fbed0f3ce73cf3c2d820582c0b06c0 - inflate.Blc
#446816057e011700be55fff00dc18bb2c1b0f87c2dd8059e097fbfb14839ce81ce80 - deflate.Blc

________________________________________________________________________________

echo "primes"
(cat oddindices.Blc; echo -n " "; cat primes.blc | ./LC -b) | ./LC | head -c 71

echo -en "\nthree"
LCParse "\f\x f (f (f x))"

LCParse "\x x"
LCParse "\x \y y"
LCParse "\x \y x"
LCParse "\x x x"
LCParse "\x (\x \y y)"

LCParse "\a \b \c \d \e a e (d e)"

LCParse "\a \b \c (\d \e \f d f (e f)) a"
LCReduce "\a \b \c \d \e \f \g a b c d e f g"
LCReduce "\a \b \c \d \e \f \g a (b (c (d (e (f g)))))"

________________________________________________________________________________

Lambda is encoded as 00, application as 01, and the variable bound by the n'th enclosing lambda (denoted n in so-called De Bruijn notation) as (2^(n+1))-2 i.e. the 3rd enclosing lambda would be = 1110.

That’s all there is to BLC!

For example the encoding of lambda term S = \x \y \z (x z) (y z), with De Bruijn notation \ \ \ (3 1) (2 1), is 00 00 00 01 01 1110 10 01 110 10

\a \b \c \d \e \f \g a b c d e f g
=\ \ \ \ \ \ \ 7 6 5 4 3 2 1
=00 00 00 00 00 00 00 01 01 01 01 01 01 11111110 1111110 111110 11110 1110 110 10
=0000000000000001010101010111111110111111011111011110111011010

 0000000000000001111111100111111100111111001111100111100111010
=00 00 00 00 00 00 00 01 11111110 01 1111110 01 111110 01 11110 01 1110 01 110 10
=\ \ \ \ \ \ \ 7 (6 (5 (4 (3 (2 1)))))
=\a \b \c \d \e \f \g a (b (c (d (e (f g)))))

0010 = \x x = λx.x = I
000010 = \x \y y = λx y.y = nil = false
0000110 = \x \y x = λx y.x = true
00011010 = \x x x = λx.x x
00000010 = \x (\x \y y) = λx.λx y.y

