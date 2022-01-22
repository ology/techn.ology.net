---                                                                                                                                                                          
status: published
title: Musical Fingerprints with Radial Bar Charts
tags:
  - perl
  - software
  - music
---

[![radial-nyt-sm.png](radial-nyt-sm.png)](radial-nyt.png)
I stumbled across [this link](https://www.nytimes.com/2019/04/04/learning/whats-going-on-in-this-graph-april-10-2019.html) with this cool chart.

---

Naturally I wondered if I could replicate this and analyze some music like ...my own!  My last release, ["X"](https://musicbrainz.org/release/4e559959-0392-4297-92e9-76a2d8f2cb2e) is on MusicBrainz.  So lets see...

Code: [analyze-low-level](https://github.com/ology/Music/blob/master/analyze-low-level)

The code uses a number of libraries to get the job done:

[GD::Chart::Radial](https://metacpan.org/pod/GD::Chart::Radial),
[Math::Utils](https://metacpan.org/pod/Math::Utils),
[Mojo::File](https://metacpan.org/pod/Mojo::File),
[Statistics::Basic](https://metacpan.org/pod/Statistics::Basic),
[WebService::AcousticBrainz](https://metacpan.org/pod/WebService::AcousticBrainz), and
[WebService::MusicBrainz](https://metacpan.org/pod/WebService::MusicBrainz)

It's small but handy!  Please see the code link above for the exciting details.  But these types of images are what it produces:

![XYZ](radial/XYZ.png)

As you can see, this is not the sexiest chart.  There are many many other libraries out there, but the one I chose was the simplest at the time.  The red polygon represents the song in question ("XYZ" in the above case).  Grey is for the average of all 26 tunes.

Anyway, here are the rest of the charts for the tunes from my last release, "X" (audio located on [my YouTube channel](https://www.youtube.com/channel/UCHTS8kJCGNo_4d5x6POCTVw)): [Tune Charts](charts.html)

As expected, my ambient tunes like Lush and Sol have smaller fingerprints, because they change the least in every way.

As an exercise for the reader, analyze [Led Zeppelin](https://musicbrainz.org/artist/678d88b2-87b0-403b-b63d-5da7465aecc3) or [Frank Sinatra](https://musicbrainz.org/artist/197450cd-0124-4164-b723-3c22dd16494d) or whoever, with this technique.  Just input their musicbrainz artist id, instead of mine.  Might take a bit of tweaking of the code to filter the recordings.  Also: Might take a while... Fun times!

~

**UPDATE**: [Led Zeppelin in Seven Dimensions](https://ology.github.io/2022/01/21/led-zeppelin-in-seven-dimensions/)
