#!/bin/bash

fileExtension=".mp4"
videoCodec="mp4v"
muxCodec="mp4"
# For More Information about VLC Codecs: https://wiki.videolan.org/Codec/

videoBitrate="2500" # for 720p
# videoBitrate="4000" # for 1080p
# For More Information about bitrate: http://www.ezs3.com/public/What_bitrate_should_I_use_when_encoding_my_video_How_do_I_optimize_my_video_for_the_web.cfm

fileLocation="/media/serotonin/SeagateBackup/video/security/"


# kill any recording instances
ps -ef | grep -i vlc | grep -v grep | awk '{print $2}' | xargs kill
# delete old video files
find $fileLocation -name "*$fileExtension" -mtime +3 | xargs rm -f

sleep 5

cvlc v4l2:// :v4l2-dev=/dev/video2 --sout='#transcode{vcodec='$videoCodec', vb='$videoBitrate'}:std{access=file, mux='$muxCodec', dst='$fileLocation$(date --iso-8601=seconds)$fileExtension'}' --no-audio &
