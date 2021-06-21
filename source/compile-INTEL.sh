#!/bin/bash
cd ${DATA_DIR}/corefreq/CoreFreq
make clean
git checkout $1
make MSR_CORE_PERF_UC=MSR_CORE_PERF_FIXED_CTR1 MSR_CORE_PERF_URC=MSR_CORE_PERF_FIXED_CTR2 -j${CPU_COUNT}
cp ${DATA_DIR}/corefreq/CoreFreq/corefreq-cli ${DATA_DIR}/corefreq/CoreFreq/corefreqd ${DATA_DIR}/corefreq/INTEL/usr/bin/
chmod 0755 ${DATA_DIR}/corefreq/INTEL/usr/bin/*
cp ${DATA_DIR}/corefreq/CoreFreq/corefreqk.ko ${DATA_DIR}/corefreq/INTEL/lib/modules/${UNAME}/extra/

#Compress modules
xz --check=crc32 --lzma2 ${DATA_DIR}/corefreq/INTEL/lib/modules/${UNAME}/extra/corefreqk.ko

PLUGIN_NAME="corefreq_INTEL"
BASE_DIR="${DATA_DIR}/corefreq/INTEL"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"

mkdir -p $TMP_DIR/$VERSION
cd $TMP_DIR/$VERSION
cp -R $BASE_DIR/* $TMP_DIR/$VERSION/
mkdir $TMP_DIR/$VERSION/install
tee $TMP_DIR/$VERSION/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
$PLUGIN_NAME: $PLUGIN_NAME for Intel v$1
$PLUGIN_NAME: Source: https://github.com/cyring/CoreFreq
$PLUGIN_NAME:
$PLUGIN_NAME: Custom $PLUGIN_NAME package for Unraid Kernel v${UNAME%%-*} by ich777
$PLUGIN_NAME:
EOF
${DATA_DIR}/bzroot-extracted-$UNAME/sbin/makepkg -l n -c n $TMP_DIR/$PLUGIN_NAME-$1-x86_64-1.txz
md5sum $TMP_DIR/$PLUGIN_NAME-$1-x86_64-1.txz > $TMP_DIR/$PLUGIN_NAME-$1-x86_64-1.txz.md5