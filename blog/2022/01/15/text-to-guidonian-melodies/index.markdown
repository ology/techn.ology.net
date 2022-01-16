---                                                                                                                                                                          
status: published
title: Text to Guidonian Melodies
tags:
  - perl
  - music
  - software
---

I'm a programming musician. Maybe that's "musical programmer."  But it's an exciting Saturday night in Geekville. What to do?  Hmmm...

tl;dr: [guidonian](https://github.com/ology/Music/blob/master/guidonian)

---

While browsing through [CPAN](https://metacpan.org/), I noticed JMATES' curious module [Music::Guidonian](https://metacpan.org/pod/Music::Guidonian) and thought I'd puzzle it out.

Seems that "In Medieval music, the Guidonian hand was a mnemonic device used to assist singers in learning to sight-sing" (from [wikipedia](https://en.wikipedia.org/wiki/Guidonian_hand)).

For the module, and the purposes of the this program, pitches are basically assigned to elements of text - for instance the vowels.

On with the show!

This program uses the venerable [Getopt::Long](https://metacpan.org/pod/Getopt::Long) module to allow your code to easily consume command-line arguments.  For musical things, Music::Guidonian, [Music::Scales](https://metacpan.org/pod/Music::Scales), and [MIDI::Util](https://metacpan.org/pod/MIDI::Util) are used.  If a text file is given, instead of a string of text, [Mojo::File](https://metacpan.org/pod/Mojo::File) comes into action.

The program accepts a number of command-line arguments, all of which have a default set (except for the "--file", which is undef).

One of these is either the name of the scale to use, or a number for random intervals of half-steps.  So the next thing the program does is either compute the size of the intervals between scale degrees OR get a list of seven random integer interval numbers:

if ($opts{rand}) { 
    # Get random intervals
    @intervals = map { int(rand $opts{rand}) + 1 } 1 .. 7;
}
else { 
    # Get the named scale intervals
    my @scale  = (get_scale_nums($opts{scale}), 12);
    @intervals = map { $scale[$_ + 1] - $scale[$_]} 0 .. $#scale - 1;
}

This is then used in the next step, which is to instantiate a new Music::Guidonian object:

    my $mg = Music::Guidonian->new(
      key_set => {
        intervals => \@intervals,
        keys      => [ split //, $opts{regex} ],
        min       => $opts{min},
        max       => $opts{max},
      }
    );

If we are given a file, reassign the text to its contents:

    if ($opts{file}) {
        my $file = Mojo::File->new($opts{file});
        $opts{text} = $file->slurp;
    }

Extract the vowels:

    $opts{text} =~ s/([$opts{regex}])[$opts{regex}]/$1/g;                                                                                                                        
    my @vowels = lc($opts{text}) =~ m/([$opts{regex}])/g;

Create and call a Music::Guidonian iterator:

    my $iter = $mg->iterator(\@vowels);
    my $phrase = $iter->();

Create a MIDI score, add the notes of the phrase to it, and play each as a quarter-note:

    my $score = setup_score(bpm => $opts{bpm}, patch => $opts{patch}, volume => $opts{vol});

    for (1 .. $opts{num}) {
        $score->n('qn', $_) for @$phrase;
    }

    $score->write_score("$0.mid");

So what does this sound like?

    perl guidonian -s minor -t 'Lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua'

[guidonian.mp3](guidonian.mp3)
