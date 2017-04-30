#!/usr/bin/env bash

LIB_PKGS=libmongo-client-dev,libboost-all-dev,mongodb-dev,libssl-dev

################################################3
# COMMON EDITOR CHOICES
# posix-like ed : ed
# vim : vim-nox
# nano : nano
#
EDITOR=vim-nox

################################################3
# COMMON FETCHER CHOICES
# wget : wget
# curl : curl
# lynx : lynx
#
WEBFETCHER=curl

# Uncomment to debug script
# set -x

# Get script location, resolve if a link.
export SCRIPT_ROOT_ENV_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_ROOT_ENV_SOURCE" ]; do
  export SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$SCRIPT_ROOT_ENV_SOURCE" )" && pwd )"
  export SCRIPT_ROOT_ENV_SOURCE="$(readlink "$SCRIPT_ROOT_ENV_SOURCE")"
  [[ ${SCRIPT_ROOT_ENV_SOURCE} != /* ]] && SCRIPT_ROOT_ENV_SOURCE="$SCRIPT_ROOT_DIR/$SCRIPT_ROOT_ENV_SOURCE"
done
export SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$SCRIPT_ROOT_ENV_SOURCE" )" && pwd )"

pushd "$SCRIPT_ROOT_DIR"

# Pi Environment Variables
RELEASE_NAME=jessie
ARCH=armhf

# Pi Repository Variables
HTTP_BASE=http://mirrordirector.raspbian.org
KEY_PATH="${HTTP_BASE}/raspbian.public.key"
APT_MIRROR="${HTTP_BASE}/raspbian"

# Target Requirements
DEV_PKGS_CSV="${LIB_PKGS},${EDITOR},${WEBFETCHER}"

# Local (Development) Machine Specific
APT_KEYRING=/etc/apt/trusted.gpg
OUT_DIR=./piroot/

# Editing below this line can be dangerous
ABS_OUT_DIR="$SCRIPT_ROOT_DIR/$OUT_DIR"

# Add Raspbian GPG key to Apt
wget -qO - "$KEY_PATH" | apt-key add -

# Install chroot, debootstrap, and the qemu/binfmt support for ARM.
apt-get install debootstrap qemu-user-static binfmt-support schroot
# Enable ARM in the Kernel
update-binfmts --enable qemu-arm
# Start building our PI ROOT
debootstrap  --foreign --keep-debootstrap-dir --arch=$ARCH --keyring="$APT_KEYRING" --verbose --include="${DEV_PKGS_CSV}" --variant=minbase "$RELEASE_NAME" "${OUT_DIR}" "$APT_MIRROR"
# Copy the qemu arm handler in to the chroot
cp /usr/bin/qemu-arm-static "${OUT_DIR}/usr/bin"

# Enter chroot and configure/install the downloaded packages
chroot "$ABS_OUT_DIR" /debootstrap/debootstrap --second-stage

pushd "$ABS_OUT_DIR"

# Replace Debian sources.list with Raspbian
(
cat <<LST
# Raspbian Repo Information (debootstrap does not add this info, so we must do so manually.)
deb $APT_MIRROR $RELEASE_NAME main contrib non-free
deb-src $APT_MIRROR $RELEASE_NAME main contrib non-free
# Normal Debian Sources (from debootstrap)
# deb http://deb.debian.org/debian $RELEASE_NAME main
LST
) > "$ABS_OUT_DIR/etc/apt/sources.list"

# List all absolute links
ABSOLUTE_LINKS=($(find -L "$ABS_OUT_DIR" -xtype l -print0 | xargs -0 ls -l | sed 's/  *\?/\t/g' | cut -f9,11 | tr '\t' ':' | grep -v '\(tmp\|swap\):' | grep ':\/' | tr  '\n' ' ' ))

WHEREAMI=`pwd`

# Make relative
for i in "${ABSOLUTE_LINKS[@]}"
do
  # Make all bootstrap folder links relative.
  IFS=':' read -ra FILE_SET <<< "$i"
  IFS='/' read -ra PATH_COMPS <<< "${FILE_SET[0]}"
  echo in `pwd` ${FILE_SET[0]} points to ${FILE_SET[1]}
   ln -rsf "${WHEREAMI}${FILE_SET[1]}" "${FILE_SET[0]}";
done

popd

popd

# Notify User
echo "The following non-standard Raspbian packages are required to be installed on the target system:"
echo -e "\t${LIB_PKGS}\n\n"