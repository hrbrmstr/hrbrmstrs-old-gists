Hit up https://github.com/ddsbook for blog source content.

It’s just Pelican blog with a custom theme, so grab pelican and use that content.

There _is_ a thin helper script based on <https://github.com/logsol/Github-Auto-Deploy> that listens on 
a port for github post-hook events and calls the pelican builder but that's literally one configuration 
line in the Github-Auto-Deploy script.

The podcast content is generated dynamically. The HTML/markdown pelican template for it is (IMO) terrible 
(I wrote it, so I'm not smacking anyone else :-). The equally terrible `convert.py` script here transforms
the podcast RSS feed XML into something pelican can work with (it also extracts the mp3 chapter info from
the podcast files and auto-formats that into something pelican can use). 

If you really do want the incredibly poorly constructed HTML/markdown template for the podcast I can sync 
it to the https://github.com/ddsbook repo.