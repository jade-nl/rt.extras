# rt.extras -> Scripts

### rt.bldr.sh

Simple but flexible script to locally build RawTherapee's latest development version.

It can Clone, Pull, Build and Install using either GCC or CLANG. There's also a section that makes it possible to include non-merged PRs.

Make sure to change **gitBsDir** and **localTrgtDir** to reflect your situation. The rest of the settings are sane/safe to use out-of-the-box, but do have a look at the *configure* and the *set defaults* sections.

### rtsm.sh

A script that makes it possible to move the position of the created Local Adjustment spots.

At the moment it is not possible to rearrange the spot order once they are created. There's an outstanding FR ([#6359](https://github.com/Beep6581/RawTherapee/issues/6359)) to get this implemented. This script fills that need for the time being.
