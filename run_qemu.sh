#!/bin/sh
file=$1
sudo qemu-system-x86_64 -M microvm,x-option-roms=off,isa-serial=off,rtc=off \
    -no-acpi \
    -enable-kvm \
    -cpu host \
    -nodefaults \
    -no-user-config \
    -nographic \
    -no-reboot \
    -device virtio-serial-device \
    -chardev stdio,id=virtiocon0 \
    -device virtconsole,chardev=virtiocon0 \
    -drive id=root,file=${file}-alpine-diff.qcow2,format=qcow2,if=none \
    -device virtio-blk-device,drive=root \
    -device virtio-rng-device \
    -kernel linux-5.12.10/arch/x86_64/boot/bzImage \
    -fsdev local,path=www,security_model=none,id=www,readonly \
    -device virtio-9p-device,fsdev=www,mount_tag=hostfiles \
    -append "console=hvc0 root=/dev/vda rw acpi=off reboot=t panic=-1" \
    -m 512 \
    -smp 2 \
    -netdev user,id=mynet0,hostfwd=tcp:127.0.0.1:8080-:8000 \
    -device virtio-net-device,netdev=mynet0
