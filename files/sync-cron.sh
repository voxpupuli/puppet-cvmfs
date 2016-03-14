#!/bin/bash

for r in $(cd /srv/cvmfs ; echo *.*)
do 
 (echo ""
  echo "Starting $r at $(date)"
  cvmfs_server snapshot -t $r || echo  "ERROR from cvmfs_server"
  echo "Finished $r at $(date)"
  ) >> /var/log/cvmfs/$r.log 2>&1 &
done

wait
