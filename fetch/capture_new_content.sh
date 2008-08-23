#!/usr/bin/env bash
DPATH=/home/mat/ruby/rss/prod
cd $DPATH
while true; do
 DTS=`date +%Y%m`
 ./display_new_content.rb $DPATH/data/headings.$DTS >>$DPATH/data/info.$DTS 2>>$DPATH/data/errs.$DTS
 sleep 2h
done
