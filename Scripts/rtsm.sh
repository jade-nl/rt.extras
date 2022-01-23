#!/bin/bash
# -------------------------------------------------------------------------- #
# Syntax  : rtsm.sh [/path/to/]name.pp3
# -------------------------------------------------------------------------- #
# Change the order of the Local Adjustment spots.
# -------------------------------------------------------------------------- #
# Mini Howto:
#
# 1) Save the profile from within RawTherapee.
#    A full profile can be used or just the full Local Adjustment section
#    using the *ctrl-click* facility.
#    Do this manually. Do not count on the profile that RawTherapee writes
#    on-the-fly to be up-to-date.
# 2) Start the script with the saved profile as input file.
# 3) Select which spot to move.
# 4) Select new location of this spot.
#    -repeat steps 3 and 4 if wanted/needed-
# 5) press *x* when satisfied or *q* to abandon/quit.
# 6) Load created profile in RawTherapee.
# -------------------------------------------------------------------------- #
# The first number (under *CL*) reflects the spot location, this is followed
# by the spot name and (under *OL*) the original spot location (in case the
# spot names are still the default *New Spot*).
#
# The script will not point out wrong choices, it will keep asking for
# input until it is satisfied.
#
# If *x* was chosen then the script will create a new file, with only the
# reordered Local Adjustment section present. This file can be imported
# into RawTherapee. Do make sure that the *Preserve* mode is set.
# 
# If *q* was chosen the script will stop running without doing anything.
#
# There's no need to quit RawTherapee while doing this, so the history will
# not be lost and there's the possibility to undo by stepping back in the
# history panel.
#
# The exported file and the newly created file are not removed by the script,
# this needs to be done by the user.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!! There is a an issue that does not load a partial Local Adjustment  !!!
# !!! profile as would be expected. An extra step is needed until this   !!!
# !!! is fixed: Remove the spots that are present before loading the new !!!
# !!! profile:                                                           !!!
# !!! 6) Delete all existing spots,                                      !!!
# !!! 7) Load created profile in RawTherapee.                            !!!
# !!!                                                                    !!!
# !!! Bug report number: #6411 (current behaviour is "as-intended" and   !!!
# !!! might be fixed/changed once 5.9 has rolled out)                    !!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# -------------------------------------------------------------------------- #
#set -xv
set -u
umask 026
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL
# -------------------------------------------------------------------------- #
# input present
[[ ! $# -eq 1 ]] && echo -e "\\n  Syntax -> rtsm.sh [/path/to/]file.pp3\\n" && exit 255
# enough spots present
spotCount=$(grep -Ecs "Name_[0-9]" "$1")
if [ "${spotCount}" -le "1" ]
then
  echo ""
  echo "  Not enough Local Adjustment spots found to continue."
  echo ""
  echo "   - A minimum of 2 spots is required."
  echo ""
  exit 254
fi

# -------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------ #
inFile="$1"
outFile="${inFile%.*}.la.pp3"
tmpDir=$(mktemp -d -t rtsm-XXXXXXXXXX)
declare -A manipArray
declare -A spotsArray
lglInSrc='^[1-9xq][0-9]*$'
lglInTrgt='^[1-9][0-9]*$'
cntr=""
finalize="f"
sptNumb=1
tmpOne=""
tmpTwo=""
lngDev="# -------------------------------------------------------------------------- #"

# -------------------------------------------------------------------------- #
# Functions
# ------------------------------------------------------------------ #
function _prtHeader ()
{
clear
echo "${lngDev}"
echo "#                   RawTherapee Local Adjustment spot mover                  #"
echo "${lngDev}"
}

function _prtFooter ()
{
echo "# ${outFile} has been created."
echo "# "
echo "${lngDev}"
}

function _doMoves ()
{
while true
do
  _prtHeader
  # -------------------------------------------------------- #
  # print spots
  cntr=1
  echo "# CL : Spot Name                                                         OL  #"
  echo "${lngDev}"
  until [ $cntr -gt "$spotCount" ]
  do
    printf "# %2s : %3s\\n" "$cntr" "${spotsArray[${manipArray[$cntr]}]}"
    (( cntr++ ))
  done
  echo "#"
  
  # -------------------------------------------------------- #
  # get spot to move
  while read -rp "# Select a spot [1-${spotCount}xq] : " srcSpot
  do
    if [ "${srcSpot}" = "x" ]
    then
      finalize="t"
      echo -en "\\033[1A\\033[2K"
      break
    elif [ "${srcSpot}" = "q" ]
    then
      echo -en "\\033[1A\\033[2K"
      echo "# -- quiting now."
      echo "# -- changes are discarded, no output generated."
      echo "# "
      echo "${lngDev}"
      rm -rf "${tmpDir}"
      exit 0
    fi
    if ! [[ "${srcSpot}" =~  ${lglInSrc} ]]    || \
         [[ "${srcSpot}" -lt 1 ]]              || \
         [[ "${srcSpot}" -gt "${spotCount}" ]] 
    then
      echo -en "\\033[1A\\033[2K"
    else
      break
    fi
  done

  # -------------------------------------------------------- #
  # are we done moving
  [ "${finalize}" = "t" ] && break
  
  # -------------------------------------------------------- #
  # get location to move to
  while read -rp "# Move to spot [0-${spotCount}] : " trgtSpot
  do
    if ! [[ "${trgtSpot}" =~  ${lglInTrgt} ]] || \
         [[ "${trgtSpot}" -lt 0 ]]            || \
         [[ "${trgtSpot}" -eq ${srcSpot} ]]
    then
      echo -en "\\033[1A\\033[2K"
    else
      break
    fi
  done

  # -------------------------------------------------------- #
  # update manipArray to new situation
  if [[ "${srcSpot}" -lt "${trgtSpot}" ]]
  then
    # old spot < new spot
    tmpOne="${manipArray[$srcSpot]}"
    for (( tllr = srcSpot; tllr < trgtSpot; tllr++ ))
    do
      tmpTwo=$((tllr+1))
      manipArray[$tllr]=${manipArray[$tmpTwo]}
    done
    manipArray[$trgtSpot]="$tmpOne"
  else
    # old spot > new spot
    tmpOne="${manipArray[$srcSpot]}"
    for (( tllr = srcSpot; tllr > trgtSpot; tllr-- ))
    do
      tmpTwo=$((tllr-1))
      manipArray[$tllr]=${manipArray[$tmpTwo]}
    done
    manipArray[$trgtSpot]="$tmpOne"
  fi
done
}

function _reConstruct ()
{
  # -------------------------------------------------------- #
  # recreate Locallab header
  # set correct Selspot
  selSpot=$( awk -F"=" '/Selspot/{ print $2}' "${tmpDir}/spot_0" )
  (( csSpot = selSpot + 1 ))
  for (( sp = 1; sp <= ${#manipArray[*]} ; sp++ ))
  do
    if [ "${manipArray[$sp]}" = ${csSpot} ]
    then 
      (( nsp = sp - 1 ))
      sed 's/Selspot='"${selSpot}"'/Selspot='${nsp}'/' \
        "${tmpDir}/spot_0" > "${outFile}" 
    fi
  done
  # -------------------------------------------------------- #
  # create Locallab spots
  for (( sp = 1; sp <= ${#manipArray[*]} ; sp++ ))
  do
    (( nsp = sp - 1 ))
    sed 's/_[0-9][0-9]*=/_'"${nsp}"'=/' \
      "${tmpDir}/spot_${manipArray[$sp]}" >> "${outFile}"
  done
}

# -------------------------------------------------------------------------- #
# Main
# ------------------------------------------------------------------ #
# split LA section into singular spots
awk -v tmpDir="${tmpDir}" '
BEGIN { FS = "=" ; sptCntr = 0 }
/\[Locallab\]/,/^$/ { 
  if ( $1 ~ "Name_" ) { sptCntr++ }
  { print >> tmpDir"/spot_"sptCntr }
}
' "${inFile}"

# -------------------------------------------------------- #
# fill arrays with initial data
while read -r SPOT
do
  sptNAME="${SPOT#*=}"
  formOut=$(printf "%-65s %02d" "$sptNAME" "$sptNumb")
  spotsArray[${sptNumb}]="${formOut}"
  manipArray[${sptNumb}]="${sptNumb}"
  (( sptNumb++ ))
done < <( sed -n '/Name_/p' "${inFile}" )

_doMoves

_reConstruct

_prtFooter

# -------------------------------------------------------------------------- #
# Cleanup
rm -rf "${tmpDir}"

exit 0

# -------------------------------------------------------------------------- #
# End
