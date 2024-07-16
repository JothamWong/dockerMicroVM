#!/bin/sh
# Creates the init script
gcc -Wall -o init -static init.c

dockerfile=$1

# Inject init system and extract the filesystem as a tar archive
DOCKER_BUILDKIT=1 docker build -f "${dockerfile}" --output "type=tar,dest=alpine.tar" .
# Create the qcow2 disk image
virt-make-fs --format=qcow2 --size=+200M alpine.tar ${dockerfile}-alpine-large.qcow2
qemu-img convert ${dockerfile}-alpine-large.qcow2 -O qcow2 ${dockerfile}-alpine.qcow2
rm ${dockerfile}-alpine-large.qcow2
# Create the differential disk image
qemu-img create -f qcow2 -b ${dockerfile}-alpine.qcow2 -F qcow2 ${dockerfile}-alpine-diff.qcow2
