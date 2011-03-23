#!/bin/bash
#title: This is a bash script to set up apple time machine syncing to a Windows NFS
#author: Qasim Shahid qasim@qasimshahid.com
#comments:I created this in order to assist those who aren't technically saavy to do all this stuff.

#set apple time machine to show unsupported volumes in time machine
defaults write com.apple.systempreferences TMShowUnsupportedNetworkVolumes 1
#find the mac address of en0
MAC_ADDY=`ifconfig en0 | grep ether | awk '{print $2;}' | awk -F ":" '{print $1 $2 $3 $4 $5 $6;}'`
#find computers hostname
HOST_NAME=`hostname | awk -F "." '{print $1;}'`
#find NFS with the most space
NFS_SHARE_MOUNT=`df | grep Volumes| awk 'BEGIN {max=0; NFS_SHARE=0;} {if ($2>max) { max=$2; NFS_SHARE=$6}} END {print NFS_SHARE}'`
SPARSE_BUNDLE=.sparsebundle
SEPERATOR=_
#echo $HOST_NAME$SEPERATOR$MAC_ADDY$SPARSE_BUNDLE
#echo $NFS_SHARE_MOUNT
#build sparse image locally
hdiutil create -size 500g -fs HFS+J -volname "TimeMachine "$HOST_NAME -verbose $HOST_NAME$SEPERATOR$MAC_ADDY$SPARSE_BUNDLE
#copy sparse image to network share
cp -R $HOST_NAME$SEPERATOR$MAC_ADDY$SPARSE_BUNDLE $NFS_SHARE_MOUNT$HOST_NAME$SEPERATOR$MAC_ADDY$SPARSE_BUNDLE
echo "Image created @ "$NFS_SHARE_MOUNT$HOST_NAME$SEPERATOR$MAC_ADDY$SPARSE_BUNDLE
