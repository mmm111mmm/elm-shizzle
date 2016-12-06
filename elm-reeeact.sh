cd src && inotifywait -e modify -m . */* | while read file; do bash elm-compile.sh ; done
