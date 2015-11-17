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
#Creates a minified JS exe for the binary lambda calculator described at
# http://tromp.github.io/cl/cl
#and at
# http://www.ioccc.org/2012/tromp/hint.html

cd "$owd"

[ ! -f ./2012.tar.bz2 ] && echo "Downloading" && \
curl -R -O -L http://www.ioccc.org/2012/2012.tar.bz2

[ ! -f ./compiler-latest.zip ] && echo "Downloading" && \
curl -R -O -L https://dl.google.com/closure-compiler/compiler-latest.zip

[ ! -f ./uni.c ] && echo "Downloading" && \
curl -R -O -L http://tromp.github.io/cl/uni.c

[ ! -f ./tromp.c ] && echo "Decompressing" && \
tar --wildcards --strip-components 2 -xvjf ./2012.tar.bz2 2012/tromp/*
#/2012/tromp/

[ ! -f ./compiler.jar ] && echo "Decompressing" && \
unzip  compiler-latest.zip compiler.jar

[ ! -f ./LC ] && echo "Compiling" && \
clang -DM=999999 -m32 -std=c99 uni.c -o LC

[ ! -f ./LC-full.js ] && echo "Compiling" && \
emcc -DM=999999 -m32 -std=c99 uni.c -o LC-full.js

[ ! -f ./LC.js ] && echo "Minifying" && \
java -jar compiler.jar --language_in=ECMASCRIPT5 --js LC-full.js --js_output_file LC.js

[ ! -f ./tromp ] && echo "Compiling" && \
clang  -std=c99 -O2 -Wall -W -m32 -DInt=int  -DX=4 -DA=500000 tromp.c -o tromp

[ ! -f ./tromp-full.js ] && echo "Compiling" && \
emcc  -std=c99 -O2 -Wall -W -m32 -DInt=int  -DX=4 -DA=500000 tromp.c -o tromp-full.js

[ ! -f ./tromp.js ] && echo "Minifying" && \
java -jar compiler.jar --language_in=ECMASCRIPT5 --js tromp-full.js --js_output_file tromp.js

