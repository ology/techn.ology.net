---                                                                                                                                                                          
status: published
title: Querying a Music Theory Database
tags:
  - perl
  - prolog
  - MIDI
  - music
  - analysis
  - software
---

For a long time, I have wondered how to easily know what chords have a diatonic function in two different keys (modes). This is known as a ["common"](https://en.wikipedia.org/wiki/Common_chord_(music)) or "pivot" chord. Naturally, being a software engineer, I wrote a program to answer this for me! (tl;dr: the [mode-pivot](https://github.com/ology/Music-ModalFunction/blob/main/eg/mode-pivot) program)

---

For our purposes, the essential question is this: "Can a chord in one key function in a second?" Any parts of this open-ended question may be unbound, thereby resulting in all possible truths.

How are "all possible truths" determined? Well the short answer is "With Prolog!" What does "unbound" mean here? Well, that's another Prolog concept, and I will explain briefly: Basically in Prolog there are only atoms and facts, rules and variables. The atoms are literals. Facts are relations between atoms. Rules are compound statements about facts with variables standing for atoms that make the rule true. Truth or falsehood is the essential result of any Prolog query. "Bound" variables are those associated with a particular atom or series of atoms. "Unbound" variables are not literally associated, but rather stand in place of atoms that would make the query true. (Whew! Confused yet? Haha.)

So in Prolog, with [this program](https://github.com/ology/Prolog-Study/blob/master/KBPFMR.pl), I was able to ask questions like, "In what mode(s) can a Gmaj chord function as a subdominant pivot chord?" Or, "In what mode(s) can a Gmaj chord function as a pivot chord with any function?" The first question has six answers. The second has 18 results. A query with no atoms (literals) and **all** variables can return an large number of alternate true results.

This was a breakthrough for me. I could finally know what pivot chords function in what modes. But this was still a **manual** thing. That is, I had to type in my full question and interact with the Prolog interpreter. This was not going to scale and would not suffice for automation.

Enter Perl!

With the excellent [Music::Scales](https://metacpan.org/pod/Music::Scales) module and mode properties data-structure (shown below), I was able to generate every single fact about every single note of every single mode, on the fly, and save this in a Prolog database.

This is done with a data structure holding every mode (7) and every property (also 7 of them) of that mode. Example:

%= highlight Perl => begin
    ionian => [
        { chord => 'maj', roman => 'r_I',   function => 'tonic' },
        { chord => 'min', roman => 'r_ii',  function => 'supertonic' },
        { chord => 'min', roman => 'r_iii', function => 'mediant' },
        { chord => 'maj', roman => 'r_IV',  function => 'subdominant' },
        { chord => 'maj', roman => 'r_V',   function => 'dominant' },
        { chord => 'min', roman => 'r_vi',  function => 'submediant' },
        { chord => 'dim', roman => 'r_vii', function => 'leading_tone' }
    ],
    etc.
%end

Next, I literally append the single rule about pivot chords and what modes/keys and diatonic functions they are in. That rule looks like this:

%= highlight Prolog => begin
    pivot_chord_keys(ChordNote, Chord, Key1Note, Key1, Key1Function, Key1Roman, Key2Note, Key2, Key2Function, Key2Roman) :-
        chord_key(ChordNote, Chord, Key1Note, Key1, Key1Function, Key1Roman),
        chord_key(ChordNote, Chord, Key2Note, Key2, Key2Function, Key2Roman),
        Key1Function \= Key2Function.
%end

This associates a chord, the "source" mode (key) that it functions in, and the "destination" mode (key) that we pivot to.

And that's it really! Prolog is "declarative." That is, you don't tell it the steps to take to evaluate things. You just tell it the facts and rules that determine the evaluation of what is true.

So with the [Music::ModalFunction](https://metacpan.org/dist/Music-ModalFunction) module, you can define the database and ask questions of it, in an automated fashion. For instance, consider the example Perl program, "mode-pivot", that comes with the distribution. It generates a chord progression that changes keys, based on the final chord in a section (of four whole note measures). This chord acts as the pivot between the original mode and the new mode. And the new mode is determined by 1) querying the database, 2) getting the results, and 3) selecting one at random:

%= highlight Perl => begin
    # ...
    my $m = Music::ModalFunction->new(
        chord_note => lc($modal_pitch),
        chord      => $chord,
        mode_note  => $last_pitch,
        mode       => $last_scale,
    );
    my $query = $m->pivot_chord_keys;
    last unless @$query;
    my $result = $query->[ int rand @$query ];
    # ...
%end

Here is a run with verbose output:

    Graph: 1-1,1-2,1-3,1-4,1-5,1-6,2-3,2-4,2-5,3-1,3-2,3-4,3-6,4-1,4-3,4-5,4-6,5-1,5-4,5-6,6-1,6-2,6-4,6-5
    Progression: [ 1, 2, 4, 6 ]
    Chord map: [ '', 'm', 'm', '', '', 'm', 'dim' ]
    Ionian scale: [ 'C', 'D', 'E', 'F', 'G', 'A', 'B' ]
    Phrase: [ 'C', 'Dm', 'F', 'Am' ]
    Chords: [
      [ 'C4', 'E4', 'G4' ], [ 'D4', 'F4', 'A4' ], [ 'F4', 'A4', 'C5' ], [ 'A4', 'C5', 'E5' ],
    ]
    Graph: 1-1,1-2,1-3,1-4,1-5,1-6,2-3,2-4,2-5,3-1,3-2,3-4,3-6,4-1,4-3,4-5,4-6,5-1,5-4,5-6,6-1,6-2,6-4,6-5
    Progression: [ 1, 3, 4, 1 ]
    Chord map: [ 'm', 'm', '', '', 'm', 'dim', '' ]
    Dorian scale: [ 'G', 'A', 'Bb', 'C', 'D', 'E', 'F' ]
    Phrase: [ 'Gm', 'Bb', 'C', 'Gm' ]
    Chords: [
      [ 'G4', 'Bb4', 'D5' ], [ 'Bb4', 'D5', 'F5' ], [ 'C4', 'E4', 'G4' ], [ 'G4', 'Bb4', 'D5' ],
    ]
    Graph: 1-1,1-2,1-3,1-4,1-5,1-6,2-3,2-4,2-5,3-1,3-2,3-4,3-6,4-1,4-3,4-5,4-6,5-1,5-4,5-6,6-1,6-2,6-4,6-5
    Progression: [ 1, 4, 5, 4 ]
    Chord map: [ '', 'm', 'm', '', '', 'm', 'dim' ]
    Ionian scale: [ 'Eb', 'F', 'G', 'Ab', 'Bb', 'C', 'D' ]
    Phrase: [ 'Eb', 'Ab', 'Bb', 'Ab' ]
    Chords: [
      [ 'Eb4', 'G4', 'Bb4' ], [ 'Ab4', 'C5', 'Eb5' ], [ 'Bb4', 'D5', 'F5' ], [ 'Ab4', 'C5', 'Eb5' ],
    ]
    Graph: 1-1,1-2,1-3,1-4,1-5,1-6,2-3,2-4,2-5,3-1,3-2,3-4,3-6,4-1,4-3,4-5,4-6,5-1,5-4,5-6,6-1,6-2,6-4,6-5
    Progression: [ 1, 6, 1, 4 ]
    Chord map: [ '', '', 'm', 'dim', '', 'm', 'm' ]
    Lydian scale: [ 'Gb', 'Ab', 'Bb', 'C', 'Db', 'Eb', 'F' ]
    Phrase: [ 'Gb', 'Ebm', 'Gb', 'Cdim' ]
    Chords: [
      [ 'Gb4', 'Bb4', 'Db5' ], [ 'Eb4', 'Gb4', 'Bb4' ], [ 'Gb4', 'Bb4', 'Db5' ], [ 'C4', 'Eb4', 'Gb4' ],
    ]

You can see the progress of what is going on under the hood. Initially we are in C major (Ionian). This four bar progression ends with an A minor chord. The program decides that this chord functions in G Dorian, and generates the second four bar phrase in that mode. The last chord is used to determine the next key modulation. Rinse, repeat...

Each chord progression (generated by [Music::Chord::Progression](https://metacpan.org/dist/Music-Chord-Progression) and [Music::ModalFunction](https://metacpan.org/dist/Music-ModalFunction)) is scored and saved in a MIDI file that you can play with (for instance) [Timidity++](https://timidity.sourceforge.net/).

Voila!
