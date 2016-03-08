#!/bin/sh
# Clone git repository, build and publish Jekyll blog

# git repository
repo="/home/blogger/git/blog.sleeplessbeastie.eu.git"

# temporary directory
temp_dir="/tmp/$(date +"%d%m%Y_%H%M")"

# destination directory
dest_dir="/var/www/blog.sleeplessbeastie.eu"

# path to jekyll executable
jekyll="/usr/local/bin/jekyll"

# clone repository
git clone $repo $temp_dir

# build jekyll web-site
LC_ALL=C.UTF-8 $jekyll build --lsi -s $temp_dir -d ${temp_dir}/_site

# fix permissions
chown -R www-data:www-data ${temp_dir}/_site

# publish web-site
rsync -r --delete ${temp_dir}/_site/ $dest_dir

# remove temporary directory
rm -r $temp_dir
