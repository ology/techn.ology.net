---
status: published
title: Iterated Prisoner's Dilemma
tags:
    - perl
    - software
    - mathematics
    - game theory
---

![](game-theory.png)
This weekend I watched [Dr Hannah Fry's](http://www.hannahfry.co.uk/) [documentary on game theory](https://www.bbc.co.uk/programmes/b0b9zsfb), and was inspired by her discussion of [Robert Axelrod's](https://en.wikipedia.org/wiki/Robert_Axelrod) tournament to simulate the iterated [prisoner's dilemma](https://en.wikipedia.org/wiki/Prisoner%27s_dilemma) (IPD) for myself.

---

In my version, an initial population of 20 players is used - two of each strategy.  Some are more cooperators, some are definitely defectors but some are a mixture of the two, like the Random strategy: 50-50 chance of either cooperating or defecting.

As with Axelrod, 200 iterations of the game are played for each pair of strategies (among the combinations of all possible pairs).  In order to have strategies play themselves, I made the population have 2 of each player.  That is, two tit-for-tats, two defectors, etc.  So we have tit-for-tat vs tit-for-tat, tit-for-tat vs defector, and defector vs defector among the games.

For the mechanics, I used the perl module [Game::Theory::TwoPersonMatrix](https://metacpan.org/pod/Game::Theory::TwoPersonMatrix) and particularly the latest version of the [tournament program](https://github.com/ology/Game-Theory-TwoPersonMatrix/blob/master/eg/tournament) that it comes with.  There is a bit of logic to wade through to explain and understand game theory and the prisoner's dilemma, not to mention my implementation of it!  So I'm going to leave that as an exercise for the reader and get to the results:

    Wins:
        defector = 2470
        reverse tit-for-tat = 2079
        firm-but-fair = 1980
        random = 1842
        grim = 1567
        aggressive tit-for-tat = 1219
        tit-for-tat = 1100
        generous tit-for-tat = 764
        tit-for-two-tats = 389
        cooperator = 0

    Scores:
        grim = 21086
        generous tit-for-tat = 19090
        tit-for-tat = 18902
        tit-for-two-tats = 18292
        defector = 17480
        aggressive tit-for-tat = 16537
        random = 16504
        reverse tit-for-tat = 16362
        fair-but-firm = 16051
        cooperator = 15546

The numbers by themselves say nothing, but the comparison says everything.  That is, the ["grim"](https://en.wikipedia.org/wiki/Grim_trigger) strategy wins.  (This strategy says to cooperate until defected against, then hold a grudge forever.)  The player who always cooperates is the sucker who loses.  Remember that this is an "adversarial population", where some players will defect.  If grim is removed, the "generous tit-for-tat" strategy is the winner - even in the face of two defectors, etc.

What does this say in the larger context?  To me it says to play the grim strategy if up against a stranger.  If playing with your life partner, then generous tit-for-tat is your best choice to sort out prisoner's dilemma situations.

---

**UPDATE:** I added more strategies to the population, including one called "soft majority" that acts depending on all previous opponent moves.  This strategy actually beats "generous tit-for-tat."  So I have to rethink my conclusions...

For a more thorough treatment of the IPD, see [https://github.com/Axelrod-Python/Axelrod](https://github.com/Axelrod-Python/Axelrod).

