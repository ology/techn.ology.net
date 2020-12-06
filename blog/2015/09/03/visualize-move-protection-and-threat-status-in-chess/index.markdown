---
status: published
title: 'Visualize Move, Protection and Threat Status in Chess'
tags:
    - perl
    - software
    - web
---

When I was a kid, my younger brother became a chess master and would regularly thrash me in the game.  Invariably this seemed to be because I would do something dumb like leaving my queen threatened and unattended.

tl;dr: [Chess::Inspector](https://github.com/ology/Chess-Inspector)

---

As with many budding CS students, I devised my own chess playing program, but in this case, it was for the purpose of making me a better player.  In fact I devised a chess program in every language I decided to learn...

Cut to the present and check out my Dancer web-app written in Perl, at the above URL.  Even though its a "web-app" it is most useful (to me) to run on my local machine to study games, rather than on a public server.  But it is built to work in any environment!

Each move may be shown, forward or reverse, with handy "tape recorder" buttons.

[![](https://raw.githubusercontent.com/ology/Chess-Inspector/master/public/images/Chess-Inspector.png)](https://raw.githubusercontent.com/ology/Chess-Inspector/master/public/images/Chess-Inspector.png)

Here are the working parts:

The excellent [Chess::Rep](https://metacpan.org/pod/Chess::Rep) module represents chess positions and generates a list of legal moves for a piece.  This module allows me to compute every possible move for every piece of a chess game.

My handy [Chess::Rep::Coverage](https://metacpan.org/pod/Chess::Rep::Coverage) module computes the potential energy of a chessboard, given by move, threat and protection status.  This is a very tedious process.

The [Chess::Pgn](https://metacpan.org/pod/Chess::Pgn) module for reading and parsing chess "PGN" game file "meta-data" - result, event, date, etc.

Perl [Dancer](https://metacpan.org/pod/Dancer) for UI display and control.

