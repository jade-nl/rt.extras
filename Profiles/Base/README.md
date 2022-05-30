## Base profiles

**base.profile.pp3**

A general use starting profile. Can be used as a static or as a base for a [dynamic profile](https://rawpedia.rawtherapee.com/Dynamic_processing_profiles).

This profile consists of the following settings on top of a neutral profile:

- Demosaicing -> RCD+VNG4
- Chromatic Aberration Correction -> *On*
  - Avoid Colour Shift -> *Off*
- Capture Sharpening -> *On*
- Profiled Lens Correction -> Automatically Selected
- Noise Reduction -> *On* (Chrominance part only, Luminance part is off)
- Defringe -> *On*
- Output Profile -> *ProPhotoRGB*

Some other preferences are dialled in as a starting point, these are not activated/on by default:

- Wavelet Levels
  - Edge Sharpness
  - Residual Image
- CIE Colour Appearance Model 2002
  - Complexity -> *Advanced*
  - Cat02/16 Mode -> *Automatic Symmetric*
  - WP Model -> *Free temp + tint + CAT02/16 + output*
  - Illuminant -> *Free*
- Vibrance
  - Saturated Tones -> *-10*
  - Pastel Tones -> *+10*
  - Pastel/saturated tones threshold -> *50/0*
  - Link pastel and saturated tones -> *Unchecked*
- HSV Equalizer -> Type *equalizer* already selected for H, S and V
- Soft Light -> *20*
- RGB Curves -> Type *standard* already selected for R, G and B
- Sharpening
  - Contrast threshold -> *25*
  - Radius -> *0.53*
  - Amount -> *207*
- Local Contrast
  - Radius -> *70*
  - Amount -> *17*
- Contrast by Detail Level -> +1 level (Contrast +)
- Haze Removal
  - Strength -> *30*
  - Depth -> *20*
  - Saturation -> *30*
- Tone Mapping
  - Strength -> *0.35*
  - Gamma -> *1.10*
  - Edge Stopping -> *1.30*
  - Scale -> *0.50*
- Dynamic Range
  - Amount -> *5*
  - Detail -> *25*
  - Anchor -> *35*
- L\*a\*b Adjustments
  - Type *Control cage* selected for Luminance curve

If you do not have access to the *ProPhotoRGB* profile, which is not provided by RawTherapee, consider using one of Elle Stone's well-behaved ICC profiles. *Rec2020* or *LargeRGB* (version 2 or 4 with g18) might be a good alternative.

- [Nine Degrees Below](https://ninedegreesbelow.com/photography/lcms-make-icc-profiles.html)
- [elles_icc_profiles on GitHub](https://github.com/ellelstone/elles_icc_profiles)

