cd src && inotifywait -e modify -m . */* | while read file; do elm-make Main.elm --output ~/public_html/main.js && cp -r ../index.html ../res/ ~/public_html/; done
