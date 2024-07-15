#!/bin/sh
# Creates the init script
gcc -Wall -o init -static init.c
# Inject init system and extract the filesystem as a tar archive
DOCKER_BUILDKIT=1 docker build -f alpine.docker --output "type=tar,dest=alpine.tar" .
# Create the qcow2 disk image
virt-make-fs --format=qcow2 --size=+200M alpine.tar alpine-large.qcow2
qemu-img convert alpine-large.qcow2 -O qcow2 alpine.qcow2
rm alpine-large.qcow2
# Create the differential disk image
qemu-img create -f qcow2 -b alpine.qcow2 -F qcow2 alpine-diff.qcow2
