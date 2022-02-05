## Styles

### General

These are some styles that can be put on top of a technically corrected edit.

- rgb_lab_exp.base.01.pp3

  Baseline style using *RGB Curves*, *L\*a\*b Adjustments* and *Exposure*

- rgb_wavelet.exp.base.01.pp3

  Baseline style using *RGB Curves*, *Wavelet Levels* and *Exposure*

The above styles are starting points and need to be tuned/adjusted after applying them. Best results are reached if the RAW is first edited to be technically correct. So make sure that, among other things, at least the exposure is set and the WB is set to as neutral as possible.

Minimal way to apply one of the above Styles would be:
- Load RAW,
- Apply base.profile.pp3 (assuming this isn't done automatically),
- Set exposure,
- Set Whit Balance,
- Apply style,
- Adjust to your liking.

### B&W

These 2 are a more dramatic and a softer looking starting point. The wl versions add a little extra contrast if needed, these do need to be adjusted to accommodate your camera.

* bw.01_lab_cm.pp3
* bw.01_lab_cm_tm.pp3
* bw.01.wl-add_on.wl.pp3 - Single module wavelet add on.

* bw.02_ct.pp3
* bw.02_ct_tm.pp3
* bw.02.wl-add_on.pp3 - Single module wavelet add on.

These 3 are skin oriented. First one is blue based and although somewhat harsher might be a good starting point for a low(er) key edit. The third one is red based and a good starting point for high(er) key edits. The middle (neutral) one has a Wavelets add-on, make sure to adjust this to accommodate your camera if used.

* bw.skin_01.harsher.pp3
* bw.skin_02.neutral.pp3
* bw.skin_02.wl-add_on.pp3 - Single module wavelet add on.
* bw.skin_03.softer.pp3

As with all profiles, or styles if you want, these need to be tuned in to the image they are applied to. This is true in general but especially so for the wl versions.

```
bw  -> Black-and-White
cm  -> Channel Mixer
ct  -> Colour Toning
lab -> L*a*b Adjustments
sl  -> Soft Light
tm  -> Tone Mapping
wl  -> Wavelet Levels
```
