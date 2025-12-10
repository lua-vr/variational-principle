while inotifywait -r --exclude "./_out/" -e close_write .; do
    lake exe blueprint;
    curl -X POST localhost:8000/api-reloadserver/trigger-reload;
done &
(cd _out/html-multi/ && uvx reloadserver -w)
