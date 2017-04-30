#!/usr/bin/env bash

# These variables can be freely edited.
HOST_DEB_RELEASE=stretch
PACKAGE_LIST=(
  'crossbuild-essential-armhf'
  'build-essential'
  'g++-arm-linux-gnueabihf'
)

# Anything edited below this point could cause issues.

# Get script location, resolve if a link.
export SCRIPT_ROOT_ENV_SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SCRIPT_ROOT_ENV_SOURCE" ]; do
  export SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$SCRIPT_ROOT_ENV_SOURCE" )" && pwd )"
  export SCRIPT_ROOT_ENV_SOURCE="$(readlink "$SCRIPT_ROOT_ENV_SOURCE")"
  [[ ${SCRIPT_ROOT_ENV_SOURCE} != /* ]] && SCRIPT_ROOT_ENV_SOURCE="$SCRIPT_ROOT_DIR/$SCRIPT_ROOT_ENV_SOURCE"
done
export SCRIPT_ROOT_DIR="$( cd -P "$( dirname "$SCRIPT_ROOT_ENV_SOURCE" )" && pwd )"

pushd "$SCRIPT_ROOT_DIR"

# ## # DEFAULT VALUES: #############################################################################
#
#    "Dir::State"="var/lib/apt/" \
#    "Dir::State::lists"="lists/" \
#    "Dir::State::cdroms"="cdroms.list" \
#    "Dir::State::mirrors"="mirrors/" \
#    "Dir::Cache"="var/cache/apt/" \
#    "Dir::Cache::archives"="archives/" \
#    "Dir::Cache::srcpkgcache"="srcpkgcache.bin" \
#    "Dir::Cache::pkgcache"="pkgcache.bin" \
#    "Dir::Etc"="etc/apt/" \
#    "Dir::Etc::sourcelist"="sources.list" \
#    "Dir::Etc::sourceparts"="sources.list.d" \
#    "Dir::Etc::vendorlist"="vendors.list" \
#    "Dir::Etc::vendorparts"="vendors.list.d" \
#    "Dir::Etc::main"="apt.conf" \
#    "Dir::Etc::netrc"="auth.conf" \
#    "Dir::Etc::parts"="apt.conf.d" \
#    "Dir::Etc::preferences"="preferences" \
#    "Dir::Etc::preferencesparts"="preferences.d" \
#    "Dir::Etc::trusted"="trusted.gpg" \
#    "Dir::Etc::trustedparts"="trusted.gpg.d" \
#    "Dir::Bin::methods"="/usr/lib/apt/methods" \
#    "Dir::Bin::solvers::"="/usr/lib/apt/solvers" \
#    "Dir::Media::MountPath"="/media/apt" \
#    "Dir::Log"="var/log/apt" \
#    "Dir::Log::Terminal"="term.log" \
#    "Dir::Log::History"="history.log" \
#
####################################################################################################

APT_BASE="$SCRIPT_ROOT_DIR/apt-base/"
PINS_FILE=preferences.d/Raspbian
SRCS_FILE=sources.list

mkdir -p "$APT_BASE"

DIRECTORIES=('var/lib/apt' 'var/cache/apt' 'etc/apt' 'var/log/apt')

SDRY_DIRS=("${DIRECTORIES[0]}/lists/partial" "${DIRECTORIES[2]}/sources.list.d" "${DIRECTORIES[2]}/trusted.gpg.d" "var/lib/dpkg")
#SDRY_FILES=()

APT_ETC="$APT_BASE/${DIRECTORIES[2]}"

STD_OPTS=(
    -o "Dir::State"="$APT_BASE/${DIRECTORIES[0]}"
    -o "Dir::Cache"="$APT_BASE/${DIRECTORIES[1]}"
    -o "Dir::Etc::sourcelist"="$APT_ETC/sources.list"
    -o "Dir::Etc::sourceparts"="$APT_ETC/sources.list.d"
    -o "Dir::State::status"="/var/lib/dpkg/status"
    -o "Dir::Log"="$APT_BASE/${DIRECTORIES[3]}"
    -o "Debug::pkgProblemResolver"="yes"
	  #-o "Acquire::Check-Valid-Until"="false" # incase you need to hit up a debian snapshot source.
)

for DIR in ${DIRECTORIES[@]}; do
    mkdir -p "$APT_BASE/$DIR"
done
for DIR in ${SDRY_DIRS[@]}; do
    mkdir -p "$APT_BASE/$DIR"
done

mkdir -p `dirname "$APT_ETC/$SRCS_FILE"`
mkdir -p `dirname "$APT_ETC/$PINS_FILE"`

cp /etc/apt/trusted.gpg.d/*  "$APT_ETC/trusted.gpg.d/"
cp /etc/apt/trusted.gpg  "$APT_ETC/"
cp /etc/apt/sources.list.d/*  "$APT_ETC/sources.list.d/"

cat /etc/apt/listchanges.conf > "$APT_ETC/listchanges.conf"
cat /etc/apt/sources.list > "$APT_ETC/$SRCS_FILE"

(
cat <<LST
# Normal Sources
deb http://http.us.debian.org/debian/ $HOST_DEB_RELEASE main
deb-src http://http.us.debian.org/debian/ $HOST_DEB_RELEASE main
deb http://security.debian.org/ $HOST_DEB_RELEASE/updates main
deb-src http://security.debian.org/ $HOST_DEB_RELEASE/updates main
deb http://http.us.debian.org/debian unstable main
deb http://http.us.debian.org/debian testing main
LST
) >> "$APT_ETC/$SRCS_FILE"

(
cat <<'LST'
Package: *
Pin: release a=stable
Pin-Priority: 503

Package: *
Pin: release a=testing
Pin-Priority: 502

Package: *
Pin: release a=unstable
Pin-Priority: 501
LST
) > "$APT_BASE/${DIRECTORIES[2]}/$PINS_FILE"

chmod -R 755 "$APT_BASE"
chown -R root:root "$APT_BASE"

echo apt-get update  ${STD_OPTS[@]}
apt-get update  ${STD_OPTS[@]}

echo apt-get install ${PACKAGE_LIST[@]}  ${STD_OPTS[@]} -f
apt-get install ${PACKAGE_LIST[@]}  ${STD_OPTS[@]} -f
apt-get update

popd
