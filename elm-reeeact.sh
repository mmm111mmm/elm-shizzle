inotifywait -e modify -m . Views/* Updaters/* | while read file; do elm-make Main.elm --output ~/public_html/main.js && cp -r index.html res/ ~/public_html/; done
