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

gitBsDir="/home/jade/.local/git"
gitRtDir="${gitBsDir}/RawTherapee"

localTrgtDir="$HOME/.local/rt.dvlp"

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
  echo " --- ----- ---"
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
  # Merge some goodies - from github.com/Beep6581/RawTherapee
  # -------------------------------------------------------- #
  # Improvements to histogram #5904
  echo " --- #5904 ---"
  git checkout histogram-improved
  git pull origin histogram-improved
  git checkout dev
  git merge -m "Improvements to histogram #5904" histogram-improved
  git merge --no-edit histogram-improved
  
  # -------------------------------------------------------- #
  # Poor men's dehaze #5769
  echo " --- #5769 ---"
  git checkout poor_man_dehaze
  git pull origin poor_man_dehaze
  git checkout dev
  git merge -m "Poor man dehaze #5769" poor_man_dehaze
  git merge --no-edit poor_man_dehaze
  
  # -------------------------------------------------------- #
  # Multiple External Editors #6299 - does not build
  #  echo " --- #6299 ---"
  #  git checkout multi-external-editor
  #  git pull origin multi-external-editor
  #  git checkout dev
  #  git merge --no-edit multi-external-editor
  
  # -------------------------------------------------------- #
  #  LA - new tool - Color appearance (Cam16 & JzCzHz) #6377 
  echo " --- #6377 ---"
  git checkout lagamciemask2
  git pull origin lagamciemask2
  git checkout dev
  git merge -m "Colour Appearance" lagamciemask2
  git merge --no-edit lagamciemask2
  
  # -------------------------------------------------------- #
  #   Favorites preferences #6383 
  echo " --- #6383 ---"
  git checkout favorites-gui
  git pull origin favorites-gui
  git checkout dev
  git merge -m "Favorites preferences" favorites-gui
  git merge --no-edit favorites-gui
  
  # -------------------------------------------------------- #
  #  Experimental/Development 
  # -------------------------------------------------------- #
  
  # -------------------------------------------------------- #
  # Merge external branche - not from github.com/Beep6581/RawTherapee
  # -------------------------------------------------------- #
  #  Add default spot size control #6371 (EXTERNAL)
  #  git remote add rtfuture "https://github.com/jonathanBieler/RawTherapee"
  #  git remote update
  #  git branch spot_size_control
  #  git checkout spot_size_control
  #  git merge -m "merging" --allow-unrelated-histories "rtfuture/spot_size_control"
  #  git checkout dev
  #  git merge -m "future" spot_size_control
}

# -------------------------------------------------------------------------- #
# git pull RT
function _gitRtPull ()
{
  # -------------------------------------------------------- #
  # pull
  echo " --- ----- ---"
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
  echo " --- ----- ---"
  echo " --- building"
  # -------------------------------------------------------- #
  # set language to use
  if [ "${optAltLang}" -eq "1" ]
  then
  echo " --- ----- ---"
  echo " --- using clang"
    export CC=clang
    export CXX=clang++
  fi
  
  # -------------------------------------------------------- #
  # set up a clean build
  echo " --- ----- ---"
  echo " --- clean build"
  cd "${gitRtDir}" || exit 253
  rm -rf build || exit 252
  mkdir build || exit 251
  cd build || exit 250

  # -------------------------------------------------------- #
  # configure
  echo " --- ----- ---"
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
  echo " --- ----- ---"
  echo " --- compiling"
  [[ $(nproc) -ge 4 ]] && CORES="$(($(nproc)-2))" || CORES=$(nproc)
  make --jobs=$CORES || exit 248

}

# -------------------------------------------------------------------------- #
# install RT
function _gitRtInstall ()
{
  # -------------------------------------------------------- #
  # install
  echo " --- ----- ---"
  echo " --- installing"
  rm -rf "${localTrgtDir}" || exit 247
  cd "${gitRtDir}/build"
  make install || exit 246
}

# -------------------------------------------------------------------------- #
# process options
# are any options given
if [ "$#" -eq "0" ]
then
  # no options given
  optPull="1"
  optBuild="1"
  optInstall="1"
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
    esac
  done
fi

curVrsn=$( ${localTrgtDir}/rawtherapee -v | awk '{ print $3 }' )

# -------------------------------------------------------- #
# act on actions
[ "${optClone}"   = "1" ] && _gitRtClone
[ "${optPull}"    = "1" ] && _gitRtPull
[ "${optBuild}"   = "1" ] && _gitRtBuild
[ "${optInstall}" = "1" ] && _gitRtInstall

exit 0

# -------------------------------------------------------------------------- #
# End
