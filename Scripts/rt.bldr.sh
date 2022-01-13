#!/bin/bash
# -------------------------------------------------------------------------- #
# Syntax  : rt.bldr.sh <options>
# -------------------------------------------------------------------------- #
# build rawtherapee's latest developemt version locally
# 
# -------------------------------------------------------------------------- #
# - c : clone
# - p : pull
# - b : build
# - i : install
# - a : use clang instead of gcc
# -------------------------------------------------------------------------- #
#set -xv
set -u
umask 026
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL

# -------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------ #
gitVrsn="n/a"
curVrsn="n/a"

optClone="0"
optPull="0"
optBuild="0"
optInstall="0"
optAltLang="0"

# -------------------------------------------------------------------------- #
# !! change these to the appropriate locations !!
gitBsDir="/home/jade/.local/git"    # location of git base directory
localTrgtDir="$HOME/.local/rt.dvlp" # install location for local RawTherapee
# -------------------------------------------------------------------------- #

gitRtDir="${gitBsDir}/RawTherapee"

export CC=gcc
export CXX=g++

# -------------------------------------------------------------------------- #
# Main
# ------------------------------------------------------------------ #
clear

# -------------------------------------------------------------------------- #
# git clone RT
# also merge branches of interest
function _gitRtClone ()
{
  echo " --- cloning repository"
  # --------------------------------------------------- #
  # force clone
  cd "${gitBsDir}" || exit 128
  rm -rf RawTherapee
  git clone https://github.com/Beep6581/RawTherapee.git || exit 127
  cd "${gitRtDir}" || exit 126
  # Use the development version
  git checkout dev || exit 125
  
  # -------------------------------------------------------- #
  # Merge some goodies - A Template
  # -------------------------------------------------------- #
  # Name/Number PR
#  echo " --- #NUMBER ---"
#  git checkout BRANCH_NAME
#  git pull origin BRANCH_NAME
#  git checkout dev
#  git merge -m "Description and number" BRANCH_NAME
#  git merge --no-edit BRANCH_NAME
  
  # -------------------------------------------------------- #
  # Merge external branche - not from github.com/Beep6581/RawTherapee
  # -------------------------------------------------------- #
  #  Name/Number PR
#  git remote add rtfuture "URL_to_Remote_Repo"
#  git remote update
#  git branch BRANCH_NAME
#  git checkout BRANCH_NAME
#  git merge -m "merging" --allow-unrelated-histories "rtfuture/BRANCH_NAME"
#  git checkout dev
#  git merge -m "future" BRANCH_NAME
 
}

# -------------------------------------------------------------------------- #
# git pull RT
function _gitRtPull ()
{
  # -------------------------------------------------------- #
  # pull
  echo " --- pulling repository"
  cd "${gitRtDir}" || exit 255
  git pull --no-edit || exit 254

  # no need to continue if local and remote are the same version
  gitVrsn=$( git describe | sed -e 's/release-//' -e 's/[~+]/-/g' )
  if [[ "${curVrsn}" == "${gitVrsn}" ]]
  then
    optBuild="0"
    optInstall="0"
  fi
}

# -------------------------------------------------------------------------- #
# configure/build/compile RT
function _gitRtBuild ()
{
  echo " --- building"
  # -------------------------------------------------------- #
  # set language to use
  if [ "${optAltLang}" -eq "1" ]
  then
  echo " --- using clang"
    export CC=clang
    export CXX=clang++
  fi
  
  # -------------------------------------------------------- #
  # set up a clean build
  echo " --- cleaning build"
  cd "${gitRtDir}" || exit 253
  rm -rf build || exit 252
  mkdir build || exit 251
  cd build || exit 250

  # -------------------------------------------------------- #
  # configure
  # Reference: https://rawpedia.rawtherapee.com/Linux
  echo " --- cmake"
  cmake \
      -DBUNDLE_BASE_INSTALL_DIR="${localTrgtDir}" \
      -DBUILD_BUNDLE="ON" \
      -DCACHE_NAME_SUFFIX="5-dev" \
      -DCMAKE_BUILD_TYPE="release"  \
      -DPROC_TARGET_NUMBER="2" \
      -DOPTION_OMP="ON" \
      -DBUILD_SHARED="OFF" \
      -DWITH_LTO="FF" \
      -DWITH_BENCHMARK="OFF" \
      -DWITH_PROF="OFF" \
      -DWITH_SAN="OFF" \
      -DWITH_SYSTEM_KLT="OFF" \
      -DCMAKE_CXX_FLAGS="-Wno-maybe-uninitialized" \
      .. || exit 249
  
  #    -DCMAKE_BUILD_TYPE="release"  \
  #    -DCMAKE_BUILD_TYPE="relwithdebinfo"  \
  #    -DCMAKE_BUILD_TYPE="debug"  \
  #    -DWITH_LTO default to OFF   <--- ON will prevent CLANG from configuring

  # -------------------------------------------------------- #
  # compile
  echo " --- compiling"
  [[ $(nproc) -ge 4 ]] && CORES="$(($(nproc)-2))" || CORES=$(nproc)
  make --jobs="$CORES" || exit 248

}

# -------------------------------------------------------------------------- #
# install RT
function _gitRtInstall ()
{
  # -------------------------------------------------------- #
  # install
  echo " --- installing"
  rm -rf "${localTrgtDir}" || exit 247
  cd "${gitRtDir}/build" || exit 246
  make install || exit 245
}

# -------------------------------------------------------------------------- #
# process options
# are any options given
if [ "$#" -eq "0" ]
then
  # no options given
  # set defaults
  optAltLang="0"        # do not use clang
  optClone="0"          # do not clone
  optPull="1"           # do     pull
  optBuild="1"          # do     build
  optInstall="1"        # do     install
else
  # parse options
  while getopts ":abcip" OPTION
  do
    case "${OPTION}" in
      a) optAltLang="1" ;;
      p) optPull="1" ;;
      c) optClone="1" ; optPull="0" ;;
      b) optBuild="1" ;;
      i) optInstall="1" ;;
      *) echo -e "\\nOptions that can be used are: a, b, c, i and p\\n" ; 
         exit 244 ;;
    esac
  done
fi

curVrsn=$( "${localTrgtDir}"/rawtherapee -v | awk '{ print $3 }' )

# -------------------------------------------------------- #
# act on actions
[ "${optClone}"   = "1" ] && _gitRtClone
[ "${optPull}"    = "1" ] && _gitRtPull
[ "${optBuild}"   = "1" ] && _gitRtBuild
[ "${optInstall}" = "1" ] && _gitRtInstall

exit 0

# -------------------------------------------------------------------------- #
# End
