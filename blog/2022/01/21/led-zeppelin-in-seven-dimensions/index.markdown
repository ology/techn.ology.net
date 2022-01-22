---                                                                                                                                                                          
status: published
title: Led Zeppelin in Seven Dimensions
tags:
  - perl
  - software
  - music
---

[Previously](https://ology.github.io/2022/01/20/musical-fingerprints-with-radial-bar-charts/), I figured out how to "fingerprint" songs with radial charts.  But as soon as I did, I wanted to analyze the entire set of tunes by well known bands like Led Zeppelin.

---

As I suspected, this involved picking through [MusicBrainz](https://musicbrainz.org/) in a different way than was done for my music.

Code: [analyze-recordings](https://github.com/ology/Music/blob/master/analyze-recordings)

Example chart that this produces:

![Immigrant Song](Immigrant-Song.png)

The spokes are defined by specific measurements that I chose from those available in the the [AcousticBrainz](https://acousticbrainz.org/) analysis of each tune.  These were the most "meaningful" to me, but I don't know the exact meanings!  Oof.  Anyway, the red line connects measurements of the song in question (like the Immigrant Song). Gray represents the average of all songs.  Also, the spokes are zero at the center and one at the end, with the measurements scaled to that range.

And here is the [zip file](Led-Zeppelin-Charts.zip) of all the charts for every Zeppelin tune.
