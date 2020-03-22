#!/bin/bash

apt install -y musl-dev

rm -rf firecracker firectl jailer

[[ -e sources ]] || mkdir sources
cd sources
[[ -e firecracker ]] || git clone -q https://github.com/firecracker-microvm/firecracker
cd firecracker
go clean
./tools/devtool build -l musl --release
cp build/cargo_target/x86*-linux-musl/release/firecracker ../../
cp build/cargo_target/x86*-linux-musl/release/jailer ../../

cd ..
[[ -e firectl ]] || git clone -q https://github.com/firecracker-microvm/firectl
cd firectl
make clean
make
cp firectl ../../

cd ../../
[[ -e images ]] || mkdir images
cd images

[[ -e alpine.ext4 ]] || curl -fsSL --progress-bar -o alpine.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/minimal/fsfiles/boottime-rootfs.ext4
[[ -e alpine-vmlinuz.bin ]] || curl -fsSL --progress-bar -o alpine-vmlinuz.bin https://s3.amazonaws.com/spec.ccfc.min/img/minimal/kernel/vmlinux.bin

[[ -e debian.ext4 ]] || curl -fsSL --progress-bar -o debian.ext4 https://s3.amazonaws.com/spec.ccfc.min/img/x86_64/debian_with_ssh_and_balloon/fsfiles/debian.rootfs.ext4
[[ -e debian-vmlinuz.bin ]] || curl -fsSL --progress-bar -o debian-vmlinuz.bin https://s3.amazonaws.com/spec.ccfc.min/img/x86_64/debian_with_ssh_and_balloon/kernel/vmlinux.bin

# amazon image
arch=`uname -m`
dest_kernel="hello-vmlinux.bin"
dest_rootfs="hello-rootfs.ext4"
image_bucket_url="https://s3.amazonaws.com/spec.ccfc.min/img"

if [ ${arch} = "x86_64" ]; then
        kernel="${image_bucket_url}/hello/kernel/hello-vmlinux.bin"
        rootfs="${image_bucket_url}/hello/fsfiles/hello-rootfs.ext4"
elif [ ${arch} = "aarch64" ]; then
        kernel="${image_bucket_url}/aarch64/ubuntu_with_ssh/kernel/vmlinux.bin"
        rootfs="${image_bucket_url}/aarch64/ubuntu_with_ssh/fsfiles/xenial.rootfs.ext4"
else
        echo "Cannot run firecracker on $arch architecture!"
        exit 1
fi

[[ -e hello-rootfs.ext4 ]] || curl -fsSL --progress-bar -o $dest_rootfs $rootfs
[[ -e hello-vmlinux.bin ]] || curl -fsSL --progress-bar -o $dest_kernel $kernel

cd ..
