#!/bin/sh
dockerfile=$1
bash create_disk.sh $1 
bash run_qemu.sh $1