#!/bin/sh
# Generate "Most popular websites" OpenBox dynamic menu

# path to the sqlite3 binary
sqlite_path=`which sqlite3`

# sqlite3 parameters (define separator character)
sqlite_params="-separator ^"

# path to the places.sqlite database
bookmarks_database=`ls ~/.mozilla/firefox/*.default/places.sqlite`

# SQL query 
sql_query="select p.title, p.url from moz_places as p where p.hidden=0 order by frecency desc limit 10"

# browser path
browser_path=`which iceweasel`


# header
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
echo "<openbox_pipe_menu>";

# execute and parse sql query
$sqlite_path $sqlite_params "$bookmarks_database" "$sql_query" | while IFS=^ read title url; do
  # special case for empty title
  if [ -z "$title" ]; then
    title=$url
  fi

  # escape special characters
  title=$(echo $title | sed -e "s/&/\&amp;/g" -e "s/\"/\&quot;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g")
  url=$(echo $url | sed -e "s/&/\&amp;/g" -e "s/\"/\&quot;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g")

  # add missing apostrophes
  title="\"$title\""

  #item
  echo "<item label=$title><action name=\"Execute\"><execute>$browser_path $url</execute></action></item>" 
done

# footer
echo "</openbox_pipe_menu>"
