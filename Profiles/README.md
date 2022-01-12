## Profiles

**base.profile.jade**

A general use profile with the following settings on top of a neutral profile:

- Demosaicing -> RCD+VNG4
- Chromatic Aberration Correction -> *On*
  - Avoid Colour Shift -> *Off*
- Capture Sharpening -> *On*
- Resize -> Long Edge *2560*
- Profiled Lens Correction -> Automatically Selected
- Sharpening -> *On* (Default settings)
- Noise Reduction -> *On* (Chrominance part only, Luminance part is off)
- Defringe -> *On*

Some other preferences are dailed in as a starting point. These modules are not activated/on by default:

- Wavelet Levels
  - Edge Sharpness
  - Residual Image
- CIE Colour Appearance Model 2002
  - Complexity -> *Advanced*
  - Cat02/16 Mode -> *Automatic Symmetric*
  - WP Model -> *Free temp + tint + CAT02/16 + output*
  - Illuminant -> *Free*
- Vibrance
  - Saturated Tnes -> *-10*
  - Pastel Tones -> *+10*
  - Pastel/saturated tones threshold -> *50/0*
  - Link pastel and saturated tones -> *Unchecked*
- HSV Equalizer -> Type *equalizer* already selected for H, S and V
- Soft Light -> *20*
- RGB Curves -> Type *standard* already selected for R, G and B
- Local Contrast
  - Radius -> *70*
  - Amount -> *17*
- Contrast by Detail Level -> +1 level (Contrast +)
- Haze Removal
  - Strength -> *30*
  - Depth -> *20*
  - Saturation -> *30*
- Tone Mapping
  - Strength -> *0.20*
  - Gamma -> *1.10*
  - Edge Stopping -> *1.25*
- Dynamic Range
  - Amount -> *5*
  - Detail -> *25*
  - Anchor -> *35*
- L\*a\*b Adjustments
  - Type *Control cage* selected for Luminance curve
  - Type *equalizer* already selected for LH, CH and HH

**krita.gimp.profile**

This profile is the same as the *base.profile.jade* profile except for:
 - No resizing is done, image is kept at full, original size.
 - Output Colout profile is set to *ProPhotRGB* (This profile is not provided by RawTherapee!)
