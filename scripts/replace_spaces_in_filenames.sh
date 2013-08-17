#!/bin/bash
# Replace spaces in filenames

ls | grep "\ " | while read item
do
  new=`echo ${item} | tr [:blank:] _`
  old=${item}
  mv "${old}" ${new}
done

