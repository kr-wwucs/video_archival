#!/usr/local/bin/bash
######################################################################
#
# Script to backup video from cameras in Computer Science Department.
#
# Written By: Kyle Ricks
# Date: 20150505
#
######################################################################
#
# To call: navigate to script and use 
# 'sudo ./archive.sh /path/to/videos/'
#
#
# Steps
# 0) Arguments
# 1) Delete non-avi
# 2) Create Archive File
# 3a) Add each file older than 90 days to Archive
# 3b) Remove each file after being added to the archive
# 4) Compress archive with bzip2
#
######################################################################
#
# Arguments
#
######################################################################

video_dir=$1
DATE=$(date "+%Y-%m-%d")

archivefile=video_archive.${DATE}.tar

######################################################################
#
# Main Body
#
######################################################################

# Delete all .jpg
echo "Deleting all .jpg files in" $video_dir
find $video_dir -name "*.jpg" -delete

# Create Archive
echo "Creating" $archivefile
touch $video_dir/start.txt
tar -cf $video_dir/$archivefile $video_dir/start.txt && /bin/rm $video_dir/start.txt

# Append files to the archive
echo "Adding video files to" $archivefile
find $video_dir -type f -mtime +90 -exec /usr/bin/tar -rf $video_dir/$archivefile {} \; -exec /bin/rm {} \;

# Bzip2 the Tar File
echo "Compressing" $archivefile "with Bzip2.  This will take some time."
bzip2 -9 $video_dir/$archivefile
