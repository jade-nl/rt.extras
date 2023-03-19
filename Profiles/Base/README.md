## Base profiles

A selection of profiles that can be used when initially loading a RAW file.

---

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
  - Wavelet levels -> 7
  - Edge Performance -> D10 - medium
  - Edge Sharpness -> 4/1.00/9/15 + custom LC curve.
  - Residual Image -> -1/31/2/71/40/3/-.03/1.06/1.51/1.05/0/0/-1
- CIE Colour Appearance Model 2002
  - Complexity -> *Advanced*
  - Cat02/16 Mode -> *Automatic Symmetric*
  - WP Model -> *Free temp + tint + CAT02/16 + output*
  - Illuminant -> *Free*
- Vibrance
  - Saturated Tones -> *13*
  - Pastel Tones -> *6*
  - Pastel/saturated tones threshold -> *20/40*
  - Link pastel and saturated tones -> *Unchecked*
- HSV Equalizer -> Type *equalizer* already set for H, S and V
- Soft Light -> *20*
- RGB Curves -> Type *standard* already selected for R, G and B
- Sharpening
  - Contrast threshold -> *25*
  - Blur   -> *0.20*
  - Radius -> *0.52*
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
  - Strength -> *0.18*
  - Gamma -> *1.15*
  - Edge Stopping -> *1.20*
  - Scale -> *0.40*
- Dynamic Range
  - Amount -> *5*
  - Detail -> *35*
  - Anchor -> *45*
- L\*a\*b Adjustments
  - Type *Control cage* selected for Luminance curve
  - Type *Control cage* selected for Chromaticity by Luminance curve

If you do not have access to the *ProPhotoRGB* profile, which is not provided by RawTherapee, consider using one of Elle Stone's well-behaved ICC profiles. *Rec2020* or *LargeRGB* (version 2 or 4) might be a good alternative.

- [Nine Degrees Below](https://ninedegreesbelow.com/photography/lcms-make-icc-profiles.html)
- [elles_icc_profiles on GitHub](https://github.com/ellelstone/elles_icc_profiles)

---

**playraw.profile.pp3**

This profile is the same as base.profile.pp3 except for the following settings:

- Output Profile -> *RTv4_sRGB*
- Wavelets 
  - Edge Performance -> D4 - standard
  - Contrast -> 24/21/18/13/11/7/4/2
  - Edge Sharpness -> flat equalizer (on 0.5 line)
- Resize
  - Long Edge 2560
- L\*a\*b Adjustments
  - LH, CH and HH equalizer are set.

---

**myBase.pp3**

Andy Astbury's base profile as mentioned in many of his [RawTherapee videos](https://www.youtube.com/playlist?list=PLnIcpm2W3TX_kcxfxeZdfW6R_4FYh-KjS)

---

**old.negative.bw.scan.d750.pp3**

A general use starting point profile for self scanned, B&W negatives.

This profiles (re)sets the following modules:

- Capture Sharpening
  - Turned OFF
- Sharpening
  - Turned ON
  - Contrast Threshold -> 25
  - Blur Radius -> 0.25
  - Radius -> 0.60
  - Threshold -> 50-150----2600-1850
  - Amount 210
- Colour Management
  - Custom -> Nikon D750 Camera Neutral
  - Tone curve ON
  - Look table ON
  - Baseline exposure ON
  - Output Profile -> ProPhotRGB
- White Balance
  - Method -> Solux 4700K (Nat. Gallery)
- Tone Mapping
  - Strength -> 0.33
  - Gamma -> 0.96
  - Edge Stopping -> 0.77
  - Scale -> 0.22
- Soft Light
  - Strength -> 20
- Noise Reduction
  - Luminance Control -> Curve
  - *Curve Point 1*
   - I  -> 0.0
   - O  -> 0.2
   - LT -> 0.35
   - RT -> 0.175
  - *Curve Point 2*
   - I  -> 0.75
   - O  -> 0.0825
   - LT -> 0.275
   - RT -> 0.3.5
  - Detail Recovery -> 50
- Impulse Noise Reduction
  - Threshold -> 40
- Black-and-White
  - Method -> Desaturation
- Film Negative
  - Turned ON

This profile relies on, and needs to be applied on top of, the above mentioned *base.profile.pp3*

As can be seen in the Colour Management section, this one is set for a Nikon D750. Change the *Input Profile* to the appropriate one.

These settings are also influenced by how the initial film scanning is done (colour of the scan light, in-camera White Balance etc.). It should be a reasonable good starting point to use as-is or to create your own sidecar.
