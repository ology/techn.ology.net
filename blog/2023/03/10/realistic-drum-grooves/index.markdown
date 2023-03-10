---                                                                                                                                                                          
status: published
title: Realistic Drum Grooves
tags:
  - perl
  - software
  - MIDI
  - generative
  - music
---

I finally have the tools to create realistic drum grooves! (tl;dr: [figured-syncopation](https://github.com/ology/Music/blob/master/figured-syncopation) & mp3s below)

---

"What are these 'tools'?", you ask. Well let me elucidate...

Enter [Perl](https://www.perl.org/) and these programming modules:

[MIDI::Drummer::Tiny](https://metacpan.org/dist/MIDI-Drummer-Tiny) and
[MIDI::Util](https://metacpan.org/dist/MIDI-Util) and
[Music::CreatingRhythms](https://metacpan.org/dist/Music-CreatingRhythms) and
[Music::Duration::Partition](https://metacpan.org/dist/Music-Duration-Partition) and
[Music::Scales](https://metacpan.org/dist/Music-Scales) and
[Music::VoiceGen](https://metacpan.org/dist/Music-VoiceGen)

Each provides crucial music or MIDI functionality.

MIDI::Drummer::Tiny is at the core of what is needed. It sets MIDI parameters like tempo and filename. It also gives us a MIDI **score** object, which is used to change channels and patches, etc. The module object is also what is used to fire-off different drummer-oriented methods.

    my $d = MIDI::Drummer::Tiny->new(
        file    => "$0.mid",
        bpm     => $bpm,
        verbose => 1,
    );

Speaking of changing channels and patches, that is actually done with MIDI::Util and the `set_chan_patch` function.

Anyway, each part is both **similar** in basic structure and **random** (i.e. "generative") in the changing syncopation and fill that is added.

The `part` routine synchronizes twice: First are three measures of straight-ahead groove (with Euclidean onsets) and figured bass. Second is a single measure of an ending fill with figured bass.

The fill is actually a slightly complicated bit under the hood. It takes two arguments: one for the number of snare onsets and another for the kick onsets. These are for the continued groove that has been established in the previous three bars. For the fill itself, which occurs at the **end** of the bar, a random Euclidean bitstring is also computed. This is assigned to the snare. (The fill is only snare at the moment. No cymbals or toms yet...)

For musical context, this program optionally generates a randomzed, figured bassline. Actually it generates a few for each run. And this is also a complicated bit that uses a couple different tools.

The Music::Duration::Partition module is used to create a couple different three-beat figures (i.e. "phrases", "motifs"). Why three? Because we add a rest on the fourth beat, so that the phrases don't run together.

    my $mdp1 = Music::Duration::Partition->new(
        size => $size,
        pool => [qw/qn en sn/],
    );
    my $motif1 = $mdp1->motif;

The Music::Scales module is used to get a set of pitches to use, based on a given base note and scale name.

    my @pitches = get_scale_MIDI($note, 1, $scale);

The Music::VoiceGen module uses those pitches and a set of allowed intervals to create notes to go along with our motifs.

    my $voice = Music::VoiceGen->new(
        pitches   => \@pitches,
        intervals => [qw/-4 -3 -2 2 3 4/],
    );
    my @notes1 = map { $voice->rand } @$motif1;

Finally, these computed notes and phrases are added to the score. For musical context and variation, these are added in an alternating fashion.

    for my $i (1 .. $bars) {
        if ($i % 2) {
            $mdp1->add_to_score($d->score, $motif1, \@notes1);
        }
        else {
            my @notes2 = map { $voice->rand } @$motif2;
            $mdp2->add_to_score($d->score, $motif2, \@notes2);
        }

        $d->rest($d->quarter);
    }

And here are a few runs with syncopated snare and kick onsets:

[figured-syncopation-05.mp3](figured-syncopation-05.mp3)

[figured-syncopation-06.mp3](figured-syncopation-06.mp3)

[figured-syncopation-07.mp3](figured-syncopation-07.mp3)

[figured-syncopation-08.mp3](figured-syncopation-08.mp3)

