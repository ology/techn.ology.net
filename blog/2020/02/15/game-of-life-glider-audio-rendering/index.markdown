---
status: published
title: Game of Life Glider Audio Rendering
tags:
    - perl
    - software
    - MIDI
    - audio
    - automata
---

![](glider.jpg)
Yesterday I became curious about what [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) structures might sound like on a grid of musical notes ("note-space").

---

After thinking a bit, I realized that I could make [a program](https://github.com/ology/Music/blob/master/game-of-life-cluster) that plays the game with the module [Game::Life](https://metacpan.org/pod/Game::Life) and triggers notes using [MIDI](https://metacpan.org/pod/MIDI).

Since I didn't want chromatic cacophony, I used a 7 x 7 playing grid of diatonic notes with lower octaves (starting at 1) on the bottom and higher on the top:

    C7 D7 E7 F7 G7 A7 B7
    C6 D6 E6 F6 G6 A6 B6
    C5 D5 E5 F5 G5 A5 B5
    C4 D4 E4 F4 G4 A4 B4
    C3 D3 E3 F3 G3 A3 B3
    C2 D2 E2 F2 G2 A2 B2
    C1 D1 E1 F1 G1 A1 B1

On this surface I placed a single upward moving [glider](https://www.conwaylife.com/wiki/Glider) at the bottom-right corner:

    . . . . . . .
    . . . . . . .
    . . . . . . .
    . . . . . . .
    . . . . x x x
    . . . . x . .
    . . . . . x .

That makes a note cluster of *G3 A3 B3 G2 A1*.

When the game is started, the glider moves from its position to the top-left, triggering evolving clusters of notes as it goes (for 17 iterations).

So what does it sound like?  This:

[GoL-Cluster.mp3](GoL-Cluster.mp3)

