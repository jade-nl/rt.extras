#!/bin/bash
# -------------------------------------------------------------------------- #
# Syntax  : ccps.sh input.tif
# -------------------------------------------------------------------------- #
# !!! ColorChecker Passport (2) specific !!!
# Create a DCP and ICC profiles. For both types the following are created:
# - Gamut compression : adobergb
# - Gamut compression : adobergb-strong
# - Gamut compression : none
# -------------------------------------------------------------------------- #
# The input file needs to be a linear tif made with dcraw or rawtherapee.
# -------------------------------------------------------------------------- #
# Commands and options used are basd on 'Basic workflow for making a DNG
# profile using a test target' section from the dcamprof website.
#
# Some of the opions used below are specific for the Nikon Z6ii I use.
# -------------------------------------------------------------------------- #
# -- Info --
# https://rawtherapee.com/mirror/dcamprof/dcamprof.html
# https://ninedegreesbelow.com/photography/camera-profile-make-target-shot.html
# https://www.cambridgeincolour.com/tutorials/natural-light-photography.htm
# https://www.cambridgeincolour.com/tutorials/digital-camera-sensor-size.htm
# https://aa.usno.navy.mil/data/AltAz  (45 degree for D50/5000K)
# https://discuss.pixls.us/t/the-quest-for-good-color-3-how-close-can-it8-come-to-ssf/18689
# https://www.xrite.com/categories/calibration-profiling/colorchecker-classic-family/colorchecker-passport-photo-2
# -------------------------------------------------------------------------- #
[[ $# -lt 1 ]] && echo -e "\\n  Syntax: ccps.sh infile.tif\\n" && exit 254
rm -f diag.tif
set -u
umask 026
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL
# -------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------ #
inFile="$1"
dtTaken=$(exiftool -s -s -s -DateTimeOriginal -d "%Y%m%d%H%M" "${inFile}")
camModel=$(exiftool -s -s -s -Model "${inFile}")
ti3File="${inFile%%.*}.ti3"
jsonFile="${inFile%%.*}.json"
outAdobeNormalDcp="${inFile%%.*}.adobergb.dcp"
outAdobeStrongDcp="${inFile%%.*}.adobergb-strong.dcp"
outNoneDcp="${inFile%%.*}.none.dcp"
outAdobeNormalIcc="${inFile%%.*}.adobergb.icc"
outAdobeStrongIcc="${inFile%%.*}.adobergb-strong.icc"
outNoneIcc="${inFile%%.*}.none.icc"
# -------------------------------------------------------------------------- #
# Main
# ------------------------------------------------------------------ #
# read patch values
/opt/Argyll_V2.1.2/bin/scanin \
  -v \
  -p \
  -O $ti3File \
  -dipn $inFile \
  /opt/Argyll_V2.1.2/ref/ColorCheckerPassport.cht \
  /home/jade/.local/git/dcamprof/data-examples/cc24_ref-new.cie

# -------------------------------------------------------- #
# ask before continuing
echo ""
read -p " --> Does diag.tif look correct? (Y/y/J/j) :" -n 1 -r
if [[ ! $REPLY =~ ^[YyJj]$ ]]
then
    echo -e "\\n  Creation probably failed, exiting now.\\n"
    exit 254
fi

# -------------------------------------------------------- #
# make native profile.
# The -b D03 option is specific for my setup, remove to fall
# back to the default (= D02)
dcamprof make-profile \
  -n "${camModel} - ${dtTaken}" \
  -i D50 \
  -C \
  -b D03 \
  -s \
  "${ti3File}" \
  "${jsonFile}"

# -------------------------------------------------------- #
# create DCP profiles
# - adobergb gamut compression - includes a tone curve
dcamprof make-dcp \
  -n "${camModel}" \
  -d "${dtTaken} - gamut compression: adobergb" \
  -c "CC BY-NC-SA 4.0" \
  -t acr \
  -g adobergb \
  "${jsonFile}" \
  "${outAdobeNormalDcp}"

# - adobergb-strong gamut compression - includes a tone curve
dcamprof make-dcp \
  -n "${camModel}" \
  -d "${dtTaken} - ganut compression: adobergb-strong" \
  -c "CC BY-NC-SA 4.0" \
  -t acr \
  -g adobergb-strong \
  "${jsonFile}" \
  "${outAdobeStrongDcp}"

# - none gamut compression - needs a linear tone curve
dcamprof make-dcp \
  -n "${camModel}" \
  -d "${dtTaken} - gamut compression: none" \
  -c "CC BY-NC-SA 4.0" \
  -t acr \
  -g none \
  "${jsonFile}" \
  "${outNoneDcp}"

# -------------------------------------------------------- #
# create ICC profiles
# - adobergb
dcamprof make-icc \
  -n "${camModel} - ${dtTaken} - adobergb, linear" \
  -c "CC BY-NC-SA 4.0" \
  -p lablut \
  -t linear \
  -g adobergb \
  "${jsonFile}" \
  "${outAdobeNormalIcc}"

# - adobergb-strong
dcamprof make-icc \
  -n "${camModel} - ${dtTaken} - adobergb-strong, linear" \
  -c "CC BY-NC-SA 4.0" \
  -p lablut \
  -t linear \
  -g adobergb-strong \
  "${jsonFile}" \
  "${outAdobeStrongIcc}"

# - no tone curve
dcamprof make-icc \
  -n "${camModel} - ${dtTaken} - without tone curve or compression" \
  -c "CC BY-NC-SA 4.0" \
  -p lablut \
  -t none \
  "${jsonFile}" \
  "${outNoneIcc}"

exit 0

# -------------------------------------------------------------------------- #
# End
