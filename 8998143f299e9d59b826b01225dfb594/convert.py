import feedparser
import time
import re
import urllib
import os
from pprint import pprint
import dateutil.parser
import subprocess

# this script takes the data driven security podcast feed,
# stores a local copy of the m4a files, extracts the chapter
# marker info for each episode then builds Pelican-style
# Markdown files for each episode which are then processed
# through a custom 'podcast' pelican static theme

ddsec = feedparser.parse("http://podcast.datadrivensecurity.info/feed/ddsec-feed.xml")

# save metadata just in case future versions of this script want to sue it
meta_data = ddsec["feed"]

for e in ddsec["entries"]:

  # extract audio file info

  audio_url = e["links"][1]['href']
  audio_file = "content/episodes/" + audio_url.split('/')[-1]
  ep_num = audio_url.split('/')[-1].split('.')[0]

  # only download new files

  if not os.path.exists(audio_file):
    print "Downloading: " + audio_url
    urllib.urlretrieve(audio_url, audio_file )
  else:
    print "Skipping: " + audio_url + " as file already exists"

  # extract chapter data

  subprocess.call(['/usr/bin/mp4chaps', '-x', '-o', '-q', '-C', audio_file ])

  # read in chapter data

  markers = {}

  f = open("content/episodes/" + ep_num + ".chapters.txt")
  for marker in f:
    ch_info = marker.rstrip().split("=")
    markers[ch_info[0]] = ch_info[1]
  f.close()

  slug = re.sub('\s+', '-', e["title"].lower()).replace("---","-")

  # create markdown files

  f = open('content/%s.md' % (slug).encode('utf-8',errors='replace'), 'w')
  f.write("Title: %s\n" % (e["title"]))
  f.write("Date: %s\n" % (dateutil.parser.parse(e["published"]).strftime('%Y-%m-%d %H:%M')))
  f.write("Category: Episodes\n")
  f.write("Author: Jay Jacobs and Bob Rudis\n")
  f.write("Summary: %s\n" % (e["subtitle_detail"]["value"]).encode('utf-8',errors='replace'))
  f.write("Slug: %s\n" % (slug).encode('utf-8',errors='replace'))
  f.write("Length: %s\n" % (e["itunes_duration"]))
  f.write("Audio: %s\n" % (e["links"][1]['href'].replace("m4a", "mp3")))
  f.write("\n")
  f.write(e["subtitle_detail"]["value"].encode('utf-8',errors='replace'))
  f.write(e["description"].encode('utf-8',errors='replace'))
  f.write("""
<div id="chapters">
<h3>In This Episode</h3>
<table id="chapterlist">
<thead><tr><td>Time Index</td><td>Title</td></tr></thead>
""")

  for i in range(0,len(markers)/2):
    chapter_mark = "CHAPTER%02d" % (i+1)
    chapter_name = "CHAPTER%02dNAME" % (i+1)
    f.write("""
<tr><td><div class="time">%s</div></td><td><div class="name">%s</div></td></tr>
""" % (markers[chapter_mark][0:8], markers[chapter_name]))

  f.write("""
</table>
</div>
""")
  f.close()