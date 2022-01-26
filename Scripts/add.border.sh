#!/bin/bash
# -------------------------------------------------------------------------- #
# Create border around an image (jpg, png, tiff)
# -------------------------------------------------------------------------- #
# Syntax  : add.border.sh [options] image
#
# Options                                             - Defaults
#  -o colour      - Set colour for outer border       - #fffff0 (Ivory)
#  -O percentage  - Set width for outer border        - 6%
#  -i colour      - Set colour for inner border       - #000000 (Black)
#  -I percentage  - Set width for inner border        - 0.2%
#                 - Use -I 0 (zero) to fully disable inner border
#  -s size        - Set maximum size (longest side)   - 2560
# -------------------------------------------------------------------------- #
# colour can be set as a:
#
# - Colour name : Ivory
# - HEX value   : #fffff0
# - RGB value   : rgb(255,255,240)  !! No spaces
# - HSL value   : hsl(60,100%,97%)  !! No spaces

# List of colour names : https://www.w3schools.com/colors/colors_names.asp
# List of HEX values   : https://www.w3schools.com/colors/colors_hex.asp
# Colour converter     : https://rgb.to/
# -------------------------------------------------------------------------- #
# Example:
#
# add.border.sh -o black -O 10 -i hsl(0,0%,66%) -I 0.5 -s 2048 image.png
#
# Output file from above example will  be named: image_.png
# -------------------------------------------------------------------------- #
#set -xv
umask 026
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL
# is convert installed
if ! command -v convert &> /dev/null
then
  echo -e "\\n ImageMagick is needed to run this script\\n"
  exit 255
fi
# is input file present
[[ $# -lt 1 ]] && echo -e "\\n  Syntax:\\n  add.border.sh [options] image" && exit 254
set -u
# -------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------ #
# Defaults
InnerBorder="#000000"
OuterBorder="#fffff0"
InnerPercent="0.2"
OuterPercent="6.0"
MaxWidth="2560"
MaxHeight="2560"

# -------------------------------------------------------------------------- #
function _showHelp ()
{
  clear
  echo ""
  echo "Syntax  : add.border.sh [options] image"
  echo ""
  echo "Options                                             - Defaults"
  echo ""
  echo " -o colour      - Set colour for outer border       - #fffff0 (Ivory)"
  echo " -O percentage  - Set width for outer border        - 6%"
  echo ""
  echo " -i colour      - Set colour for inner border       - #000000 (Black)"
  echo " -I percentage  - Set width for inner border        - 0.2%"
  echo "                - Use -I 0 (zero) to disable inner border"
  echo ""
  echo " -s size        - Set maximum size (longest side)   - 2560"
  echo ""
  echo ""
  echo "colour can be set as a:"
  echo ""
  echo "- Colour name : Ivory"
  echo "- HEX value   : #fffff0"
  echo "- RGB value   : rgb(255,255,240)  !! No spaces"
  echo "- HSL value   : hsl(60,100%,97%)  !! No spaces"
  echo ""
  echo "List of colour names : https://www.w3schools.com/colors/colors_names.asp"
  echo "List of HEX values   : https://www.w3schools.com/colors/colors_hex.asp"
  echo "Colour converter     : https://rgb.to/"
  echo ""
  echo "Example:"
  echo ""
  echo "add.border.sh -o black -O 10 -i hsl(0,0%,66%) -I 0.5 -s 2048 image.png"
  echo ""
  echo "Output file from above example will  be named: image_.png"
  echo ""
  exit 0
}
# -------------------------------------------------------------------------- #
# Main
# ------------------------------------------------------------------ #
# parse options
while getopts ":o:O:i:I:s:h" OPTION
do
  case "${OPTION}" in
    i) InnerBorder=$OPTARG;;
    I) InnerPercent=$OPTARG;;
    o) OuterBorder=$OPTARG;;
    O) OuterPercent=$OPTARG;;
    s) MaxWidth=$OPTARG
       MaxHeight=$OPTARG;;
    h) _showHelp;;
    *) _showHelp;;
  esac
done
shift $((OPTIND-1))
# -------------------------------------------------------- #
# set in/out/ext for file
InFile="$1"
OutName="${InFile%.*}_"
OutExt="${InFile##*.}"
InnerPercent="${InnerPercent%\%}"
OuterPercent="${OuterPercent%\%}"
IFrame="-frame x${InnerPercent}%+0+0"
[ "${InnerPercent}" = "0" ] && IFrame=""
# -------------------------------------------------------- #
# Create bordered image:
convert                                                       \
  "$InFile"                                                   \
  -mattecolor "${InnerBorder}" "${IFrame}"                    \
  -mattecolor "${OuterBorder}" -frame "x${OuterPercent}%+0+0" \
  -resize "${MaxWidth}x${MaxHeight}>"                         \
  "${OutName}.${OutExt}"

exit 0
# -------------------------------------------------------------------------- #
# End
