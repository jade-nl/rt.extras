## Toning

Colour Toning, more specifically the *Colour correction regions* method, starting point profiles.

These don't make any changes when initially loaded or activated. They set up multiple instances in the Colour Toning module. These instances have pre dialled-in masks that target a specific colour or luminosity.

*  ct.base.smh.pp3 [S]

This profile sets up 5 instances that make it easier to target shadows, lower mid tones, upper mid tones and highlights. There's also an overall instance that uses the Luminance mask to exclude the extremer shadows and highlights. All instances use a mask blur.

Can be used with both colour and b&w edits.

* ct.base.rgb.pp3 [R]

This profile sets up 4 instances that makes it easier to target the reds, greens and blues. The Hue and Luminance masks are used to select the reds, greens and clues parts. There's also an overall instance that uses the Luminance mask to exclude the extremer shadows and highlights. All instances use a mask blur.

The red, green and blue instance work on all channels when loaded. Switching to the accompanying colour channel will make it possible to influence the colour itself.

Can only be used with colour edits.

* ct.base.all.pp3 [A]

This profiles combines the above 2 profiles to give you 8 instances to work with.

Can only be used with colour edits.

---

The Colour Toning module does not have the options to name the instances and uses a numbered sequences instead. Here's the order used in the above profiles:

* **S R A**
* **1 _ 1** : shadows
* **2 _ 2** : lower mid tones
* **3 _ 3** : upper mid tones
* **4 _ 4** : highlights
* **_ 1 5** : reds
* **_ 2 6** : greens
* **_ 3 7** : blues
* **5 4 8** : overall

---

* ct.base.all.v2.pp3

A slightly simpler, 7 instance  version of *ct.base.all.pp3*. The the double mid-tone entries are merged in this one.

