while inotifywait -r -e close_write .; do lake exe blueprint; done &
(cd _out/html-multi/ && uvx reloadserver)
