#!/bin/bash
# Display recent repository changes using dokuwiki syntax
#
# Source: https://blog.sleeplessbeastie.eu/2017/02/13/how-to-display-git-commits-on-dokuwiki-page/
#

# number of recent changes
n_changes=6

# git repository
git_repository="/opt/repositories/website-blog.git/"

# output directory and filename
output_dir="/opt/wiki/data/pages/external"
output_file="git_blog_log.txt"
output="${output_dir}/${output_file}"

# header title
header_title="Recent changes"

echo "==== ${header_title} ====" | tee $output >/dev/null
git --git-dir="${git_repository}" log --max-count="${n_changes}"  --date=short --pretty=format:"  * **%h** **%ad** \\\\  //%s//" | tee -a $output >/dev/null
