# rt.extras -> Scripts

Scripts that are RawTherapee related. These provide functionality that RawTherapee does not provide, temporary fix to an outstanding PR.

---

### rt.bldr.sh

Simple but flexible script to locally build RawTherapee's latest development version.

It can Clone, Pull, Build and Install using either GCC or CLANG. There's also a section that makes it possible to include non-merged PRs.

Make sure to change **gitBsDir** and **localTrgtDir** to reflect your situation. The rest of the settings are sane/safe to use out-of-the-box, but do have a look at the *configure* and the *set defaults* sections.

### rtsm.sh

A script that makes it possible to move the position of the created Local Adjustment spots.

At the moment it is not possible to rearrange the spot order once they are created. There's an outstanding FR ([#6359](https://github.com/Beep6581/RawTherapee/issues/6359)) to get this implemented. This script fills that need for the time being.

### add.border.sh

This is a general, lightweight and flexible script that can add a border to an exported image (jpg, png or tiff). It is fully independent of RawTherapee, which can not do this natively yet. A possible lightweight alternative to GIMP, Krita, Photoshop, IrfanView etc.

The following can be, independently, set: 
- Inner border colour,
- Outer border colour,
- Inner border width,
- Outer border width,
- Maximum size (longest side and scaled down only).

This Linux script is written with *magick*, from ImageMagick 7, at its base.

### ccps.sh

A ColorChecker Passport (v2) specific script to create DCP and ICC profiles. Roughly based on [this workflow](https://discuss.pixls.us/t/warning-auto-selected-neutral-patch-d02/25538/17). The *Creating the 16 bit linear tif* needs to be done by hand, the script takes it from there, starting with *Read patches*

This script needs *dcamprof* and the *Argyll* suite to be installed.

**Heads-up**: This is geared towards my setup and some stuff is/needs to be hard-coded for the moment. Make sure to check and change paths where needed (*ccps.sh* and *rt.bldr.sh*).
