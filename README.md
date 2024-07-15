# Running docker containers in a QEMU microVM

## Linux kernel

First clone linux kernel or download it here

```bash
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.10.tar.xz
tar -xf linux-5.12.10.tar.xz
```


## defconfig

A simple kernel config
Replace the linux config with this

```bash
cd linux-5.12.10/
cp ../defconfig .config
make olddefconfig
make -j$(nproc)
```

## init.c

This is a self written init system which basically functions the same as docker when starting a container.
/bin/sh is hardcoded as an entrypoint.
The init application is replaced with /bin/sh using execle, if the application does not wait for child processes, zombie processes may be spawned.

Compiled with 
```bash
gcc -Wall -o init -static init.c
```

