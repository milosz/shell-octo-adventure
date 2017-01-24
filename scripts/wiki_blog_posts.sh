#!/bin/bash
# Display scheduled Jekyll blog posts using dokuwiki syntax
#
# Source: https://blog.sleeplessbeastie.eu/2017/02/27/how-to-display-to-display-scheduled-jekyll-blog-posts-on-dokuwiki-page/
#

# git repository
git_repository="/opt/repositories/blog.git/"

# output directory and filename
output_dir="/opt/wiki/data/pages/external"
output_file="git_blog_scheduled.txt"
output="${output_dir}/${output_file}"

# header title
header_title="Scheduled blog posts"

# limit the number of posts to check to a third for increased performance
n_posts=$(git --git-dir="${git_repository}" ls-tree HEAD _posts --name-only -r | wc -l)
n_posts_to_check=$(( n_posts / 3 ))

echo "==== ${header_title} ====" | tee $output >/dev/null
posts=$(git --git-dir="${git_repository}" ls-tree HEAD _posts --name-only -r | sort | tail -${n_posts_to_check})
for post in $posts; do
  date=$(echo $post | sed "s/\_posts\/\([0-9]*\).\([0-9]*\).\([0-9]*\).*/\1-\2-\3/")
  date_s=$(date -d ${date} +%s)
  now_s=$(date -d now +%s)
  date_diff=$(( (date_s - now_s) / 86400 ))
  if [ "$date_diff" -ge "0" ]; then
    title=$(git --git-dir="${git_repository}" show HEAD:${post} | grep ^title: |  awk -F ": " '{print $2}')
    echo "  * **$date** \\\\  //$title//" | tee -a $output >/dev/null
  fi
done
