#!/bin/bash

echo "running distclean command..."
make distclean

echo "cloning aurora theme repo..."
cd ./package
rm -rf ./luci-app-aurora-config/
rm -rf ./luci-theme-aurora/
git clone https://github.com/eamonxg/luci-theme-aurora.git
git clone https://github.com/eamonxg/luci-app-aurora-config.git
cd ..

echo "Updating package feeds..."
./scripts/feeds update -a

echo "Installing package..."
./scripts/feeds install -a

echo "Copying config..."
cp viettel.config .config
make defconfig

echo "Downloading resources..."
make download -j$(nproc) V=s

echo "Building toolchains..."
make tools/install -j$(nproc) V=s
make toolchain/install -j$(nproc) V=s

echo "Pre-compiling BL2 & BL31..."
make package/boot/uboot-mediatek/compile -j$(nproc) V=s

echo "Building firmware..."
make -j$(nproc) V=s || make -j1 V=s
