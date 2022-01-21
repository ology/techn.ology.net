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

Naturally I wondered if I could replicate this and analyze my own music, as my latest release, ["X"](https://musicbrainz.org/release/4e559959-0392-4297-92e9-76a2d8f2cb2e) is on MusicBrainz.

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

Anyway, here are the rest of the tunes from my last release, "X", located on [my YouTube page](https://www.youtube.com/channel/UCHTS8kJCGNo_4d5x6POCTVw):

[Attenuation](radial/Attenuation.png),
[Beneath](radial/Beneath.png),
[Beyond](radial/Beyond.png),
[Clubster](radial/Clubster.png),
[Complexity](radial/Complexity.png),
[Composure](radial/Composure.png),
[Dignified](radial/Dignified.png),
[Dusk](radial/Dusk.png),
[Echolocation](radial/Echolocation.png),
[Emergent](radial/Emergent.png),
[Gondwana](radial/Gondwana.png),
[Lakeside](radial/Lakeside.png),
[Lush](radial/Lush.png),
[Magical](radial/Magical.png),
[Manifest](radial/Manifest.png),
[Ocean](radial/Ocean.png),
[Overlap](radial/Overlap.png),
[Puzzlement](radial/Puzzlement.png),
[Romantics](radial/Romantics.png),
[Serene](radial/Serene.png),
[Soliton](radial/Soliton.png),
[Sol](radial/Sol.png),
[Urgent](radial/Urgent.png),
[Vignette II](radial/Vignette-II.png),
[Voss Alteration](radial/Voss-Alteration.png)

As expected, my ambient tunes like Lush and Sol, etc. all have smaller fingerprints, because they all change the least in every way.
