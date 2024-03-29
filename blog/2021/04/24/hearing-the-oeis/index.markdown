---
status: published
title: Hearing the OEIS
tags:
  - perl
  - software
  - MIDI
  - audio
---

![oeis-logo.jpg](oeis-logo.jpg)
What does a number sequence "sound like"?

---

Let's join [MIDI-Perl](https://metacpan.org/release/MIDI-Perl) with the [OEIS module](https://metacpan.org/release/OEIS)!

[MIDI](https://www.midi.org/) stands for "Musical Instrument Digital Interface."  [Perl](https://www.perl.org/) is, of course a computer language.  And the [OEIS](https://oeis.org/) is the venerable, On-Line Encyclopedia of Integer Sequences.

Let's get to it.  The code is super simple:

<%= highlight perl => begin %>
#!/usr/bin/env perl
use strict;
use warnings;
<% end %>

Declare the modules and functions to use:

<%= highlight perl => begin %>
use MIDI::Util qw(setup_score);
use Music::Scales qw(get_scale_MIDI);
use OEIS qw(oeis);
<% end %>

Declare and assign the program parameters (which can be given as command-line arguments):

<%= highlight perl => begin %>
my $oeis   = shift || die "Usage: perl $0 oeis-number [how-many scale bpm patch octave]\n";
my $limit  = shift || 64;
my $scale  = shift || 'major';
my $bpm    = shift || 300;
my $patch  = shift || 0;
my $octave = shift || 4;
<% end %>

We will need a MIDI score and a scale of notes:

<%= highlight perl => begin %>
my $score = setup_score(bpm => $bpm, patch => $patch);
my @scale = get_scale_MIDI('C', $octave, $scale);
<% end %>

Inspect each term of the OEIS sequence.  Find the modulo between this term and the size of the scale.  (This keeps the values in the audible range.)  Add this value as a note to the growing score:

<%= highlight perl => begin %>
my $i = 0;
for my $n (oeis($oeis, $limit)) {
    my $mod = $n % @scale;
    my $note = $scale[$mod];
    printf "%d. n: %d, mod %d: %d, note: %d\n",
        ++$i, $n, scalar(@scale), $mod, $note;
    $score->n('qn', $note);
}
<% end %>

Finally, write the score to a MIDI file, named after the program:

<%= highlight perl => begin %>
$score->write_score("$0.mid");
<% end %>

And what does this sound like?  Well here are the 58 prime numbers in the sequence [OEIS A000040](https://oeis.org/A000040):

[oeis-40.mp3](oeis-40.mp3)

And here are the first 64 Fibonacci numbers ([OEIS A000045](https://oeis.org/A000045)):

[oeis-45.mp3](oeis-45.mp3)

Woo!

