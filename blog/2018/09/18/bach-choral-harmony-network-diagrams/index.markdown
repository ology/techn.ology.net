---
status: published
title: Bach Choral Harmony Network Diagrams
tags:
    - perl
    - software
    - music
    - data
    - analysis
---

Today I decided to revisit the [Bach Choral Harmony data set](https://archive.ics.uci.edu/ml/datasets/Bach+Choral+Harmony) and look at chord progression transitions.

In order to do this I wrote a small program that tallies the movement from one chord to another, and then outputs a [Graphviz](https://graphviz.org/) dot file that can be turned into an image.

---

The [code for this](https://github.com/ology/Music/blob/master/bach-choral-network) is on github.  It accepts an identifier for a song (as given by the UCI dataset) to diagram.  The association between UCI ids and Bach BWV numbers can be looked-up in this file: [titles.txt](titles.txt).

![](bach-choral-network.png)

The shown song diagram is for BWV 17.7 "Nun lob, mein Seel, den Herren."  For reference, here is the MIDI file: [BWV-17.7.mid](BWV-17.7_001707b_.mid) and here is the transcription: [BWV-17.7.pdf](BWV-17.7_001707.pdf)  Also, I have rendered the transitions of this piece, as a meditation, to audio [on youtube](https://www.youtube.com/watch?v=01fAE1GqW1Q).

**UPDATE:** I have made a web GUI for displaying these diagrams for the chorales at UCI - [https://github.com/ology/Bach-Chorales](https://github.com/ology/Bach-Chorales) - Woo!

**UPDATE:** I have made a module to compartmentalize the parsing of the UCI Bach data set at [Music::BachChoralHarmony](https://metacpan.org/pod/Music::BachChoralHarmony).

