#!/bin/bash
# -------------------------------------------------------------------------- #
# Create border around an image (jpg, png, tiff)
# -------------------------------------------------------------------------- #
# Syntax  : add.border.sh [options] image
#
# Options                                             - Defaults
#  -o colour      - Set colour for outer border       - #f8f8f7
#  -O percentage  - Set width for outer border        - 10%
#  -i colour      - Set colour for inner border       - #000000 (Black)
#  -I percentage  - Set width for inner border        - 0.5%
#                 - Use -I 0 (zero) to fully disable inner border
#  -s size        - Set maximum size (longest side)   - 2560
#                 - Using -s 0 (zero) keeps original image size
# -------------------------------------------------------------------------- #
# colour can be set as a:
#
# - HEX value   : #fafaf5
# - RGB value   : rgb(255,255,240)  !! No spaces
# - HSL value   : hsl(60,100%,97%)  !! No spaces
# -------------------------------------------------------------------------- #
# Example:
#
# add.border.sh -o black -O 10 -i hsl(0,0%,66%) -I 0.5 -s 2048 image.png
#
# -------------------------------------------------------------------------- #
#set -xv
umask 026
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL
# is convert installed
if ! command -v magick &> /dev/null
then
  echo -e "\\n ImageMagick (7+) is needed to run this script\\n"
  exit 255
fi
# is an input file present
[[ $# -lt 1 ]] && echo -e "\\n  Syntax:\\n  add.border.sh [options] image" && exit 254
set -u
# -------------------------------------------------------------------------- #
# Variables
# ------------------------------------------------------------------ #
# Set defaults
InnBrdClr="#000000"
OutBrdrClr="#f8f8f7"
InnPct="0.5"
OutPct="10.0"
MaxSize="2560"

# -------------------------------------------------------------------------- #
function _showHelp ()
{
  clear
  echo ""
  echo "Syntax  : add.border.sh [options] image"
  echo ""
  echo "Options                                             - Defaults"
  echo ""
  echo " -o colour      - Set colour for outer border       - #f8f8f7"
  echo " -O percentage  - Set width for outer border        - 10%"
  echo ""
  echo " -i colour      - Set colour for inner border       - #000000"
  echo " -I percentage  - Set width for inner border        - 0.5%"
  echo "                - Use -I 0 (zero) to disable inner border"
  echo ""
  echo " -s size        - Set maximum size (longest side)   - 2560"
  echo "                - Using -s 0 (zero) keeps original image size"
  echo ""
  echo "colour can be set as a:"
  echo ""
  echo "- Colour name : Ivory"
  echo "- HEX value   : #fbfbf4"
  echo "- RGB value   : rgb(255,255,240)  !! No spaces"
  echo "- HSL value   : hsl(60,100%,97%)  !! No spaces"
  echo ""
  echo ""
  echo "Examples:"
  echo ""
  echo "add.border.sh -o black -O 10 -i hsl(0,0%,66%) -I 0.5 -s 2048 image.png"
  echo "add.border.sh -o \"#000000\" -i grey image.png"
  echo "add.border.sh -o \"#767676\" image.tiff       --> 'ISO 12646:2008'"
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
    i) InnBrdClr=$OPTARG;;
    I) InnPct=$OPTARG;;
    o) OutBrdrClr=$OPTARG;;
    O) OutPct=$OPTARG;;
    s) MaxSize=$OPTARG;;
    h) _showHelp;;
    *) _showHelp;;
  esac
done
shift $((OPTIND-1))

# -------------------------------------------------------- #
# Create bordered and resized image:
InFile="$1"
OutName="${InFile%.*}_"
OutExt="${InFile##*.}"
InnPct="${InnPct%\%}"
Dvsr="$(magick "${InFile}" -format "%[fx:w/h]" info:)"
OutPctY="${OutPct%\%}"
OutPctX=$(echo "scale=3; $OutPctY / $Dvsr" | bc -l)
IFrame="-frame x${InnPct}%+0+0"
RSize="-resize ${MaxSize}x${MaxSize}>"
[ "${InnPct}" = "0" ]   && IFrame=""
[ "${MaxSize}" = "0" ] && RSize=""

magick                                                             \
  "$InFile"                                                        \
  -mattecolor "${InnBrdClr}" ${IFrame}                             \
  -mattecolor "${OutBrdrClr}" -frame "${OutPctX}%x${OutPctY}%+0+0" \
  ${RSize}                                                         \
  "${OutName}.${OutExt}"

exit 0
# -------------------------------------------------------------------------- #
# End
