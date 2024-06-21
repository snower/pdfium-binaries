#!/bin/bash -eux

SOURCE="${PDFium_SOURCE_DIR:-pdfium}"
OS="${PDFium_TARGET_OS:?}"
CPU="${PDFium_TARGET_CPU:?}"

pushd "$SOURCE"

case "$OS" in
  linux)
    case "$CPU" in
      loong64)
        wget -c -O build/linux/debian_bullseye_loong64-sysroot.squashfs  https://github.com/loongson/build-tools/releases/download/2023.08.08/clfs-loongarch64-system-8.1-sysroot.squashfs
        unsquashfs -d build/linux/debian_bullseye_loong64-sysroot -no-xattrs build/linux/debian_bullseye_loong64-sysroot.squashfs usr/bin usr/sbin usr/include usr/lib usr/lib64 usr/share lib lib64 etc debian
        rm -rf build/linux/debian_bullseye_loong64-sysroot.squashfs
        ;;
      *)
        build/linux/sysroot_scripts/install-sysroot.py "--arch=$CPU"
        ;;
    esac

    build/install-build-deps.sh
    gclient runhooks
    ;;
  android)
    build/install-build-deps.sh --android
    gclient runhooks
    ;;
esac

popd
