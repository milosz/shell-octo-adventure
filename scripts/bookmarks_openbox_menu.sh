#!/bin/sh
# Generate "Bookmarks" OpenBox dynamic menu

# path to the sqlite3 binary
sqlite_path=`which sqlite3`

# sqlite3 parameters (define separator character)
sqlite_params="-separator ^"

# path to the places.sqlite database
bookmarks_database=`ls ~/.mozilla/firefox/*.default/places.sqlite`

# SQL query 
sql_query="select p.title, p.url from moz_places as p where p.hidden=0 order by last_visit_date desc limit 10"

# browser path
browser_path=`which iceweasel`

# root element
root_element="(select folder_id from moz_bookmarks_roots where root_name='menu')"

# process bookmarks
process_bookmarks(){
  # SQL query - bookmarks
  sql_bookmarks_query="select b.title, p.url from moz_bookmarks as b left outer join moz_places as p on b.fk=p.id where b.type = 1 and p.hidden=0 and b.title not null and parent=$1"
  $sqlite_path $sqlite_params "$bookmarks_database" "$sql_bookmarks_query" | while IFS=^ read title url; do
    # special case for empty title
    if [ -z "$title" ]; then
      title=$url
    fi

    # escape special characters
    title=$(echo $title | sed -e "s/&/\&amp;/g" -e "s/\"/\&quot;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g")
    url=$(echo $url | sed -e "s/&/\&amp;/g" -e "s/\"/\&quot;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g")

    # add missing apostrophes
    title="\"$title\""

    echo "<item label=$title><action name=\"Execute\"><execute>$browser_path $url</execute></action></item>"
  done
}

# process the folders function
process_folders(){
  # execute only when there is an axactly one parameter
  if [ "$#" = 1 ]; then
    # SQL query - folders
    sql_folder_query="select id, title from moz_bookmarks where parent=$1 and type=2 and (select count(*) from moz_bookmarks as b2 where b2.parent=moz_bookmarks.id)>0"

    # process folders
    $sqlite_path $sqlite_params "$bookmarks_database" "$sql_folder_query" | while IFS=^ read id title; do
      # special case for empty title
      if [ -z "$title" ]; then
        title="(no title)"
      fi

      # escape special characters
      title=$(echo $title | sed -e "s/&/\&amp;/g" -e "s/\"/\&quot;/g" -e "s/</\&lt;/g" -e "s/>/\&gt;/g")

      # add missing apostrophes
      title="\"$title\""

      # create new menu for folder
      echo "<menu id=\"ff-bookmarks-folder-$id\" label=$title>";
    
      # process folders inside
      process_folders $id
      
      # process bookmarks in current folder
      process_bookmarks $id 
     
      echo "</menu>"
    done
  fi
}


# header
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
echo "<openbox_pipe_menu>";

# process folders 
process_folders "$root_element"

# process bookmarks for root element
process_bookmarks "$root_element"

# footer
echo "</openbox_pipe_menu>"
