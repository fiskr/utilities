#!/bin/bash

fileExtension=".mp4"
videoCodec="mp4v"
muxCodec="mp4"
# For More Information about VLC Codecs: https://wiki.videolan.org/Codec/

videoBitrate="2500" # for 720p
# videoBitrate="4000" # for 1080p
# For More Information about bitrate: http://www.ezs3.com/public/What_bitrate_should_I_use_when_encoding_my_video_How_do_I_optimize_my_video_for_the_web.cfm

fileLocation="/media/serotonin/SeagateBackup/video/security/"
videoDevice="/dev/video0"

function killVlcInstances() {
  if [[ $(ps -ef | grep -i vlc | grep -v grep | wc -l) != 0 ]]; then

    ps -ef | grep -i vlc | grep -v grep | awk '{print $2}' | xargs kill

    sleep 10

    killVlcInstances
  fi
}

# delete old video files
find $fileLocation -type f -mtime +3 | xargs rm -f

# stop recording
killVlcInstances

echo "" 2>&1
echo "" 2>&1
echo "Beginning of Recording: $(date --iso-8601=minutes)" 2>&1

export DISPLAY=:0; cvlc v4l2:// :v4l2-dev=$videoDevice --sout='#transcode{vcodec='$videoCodec', vb='$videoBitrate'}:std{access=file, mux='$muxCodec', dst='$fileLocation$(date --iso-8601=seconds)$fileExtension'}' --no-audio &
