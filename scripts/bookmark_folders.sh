#!/bin/sh
# Print Firefox Bookmarks folder ids

sqlite3 -column -header ~/.mozilla/firefox/*.default/places.sqlite "select b.id,b.title,b.parent,(select b1.title from moz_bookmarks as b1 where b1.id=b.parent) as parent_name,(select count(*) from moz_bookmarks as b2 where b2.type=1 and b2.parent=b.id) as bookmarks_count from moz_bookmarks as b where b.type = 2 and length(parent_name)>0 and  length(title)>0 and b.parent <>4 order by parent,id"
