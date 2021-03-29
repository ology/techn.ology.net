---
status: published
title: 'Fibonacci v Primes: Cage Match!'
tags:
    - perl
    - R
    - software
    - mathematics
    - prime numbers
---

[![](plot-200-31-sm.png)](plot-200-31.png)
Today I decided to more deeply investigate this curious math thing I discovered (for myself) - Plotting the Fibonacci numbers by Prime numbers each by a given modulo.  "Fibo-what? Mod-what? So what!", you say. *:p*

tldr code: [slice-seq](https://github.com/ology/Math/blob/master/slice-seq) and [slice-seq.R](https://github.com/ology/Math/blob/master/slice-seq.R)

---

For the mechanics, I use Perl to produce the data and R to visualize it.

The first is the Fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...  The primes are of course: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, ...  If you plot them on a graph, each sky-rockets because they are both sequences of bigger and bigger numbers.

What I have been interested in is "boxing in" an infinitely long sequence.

I use modulo (or "clock") arithmetic to keep all numbers within a given range.  For example, the friendly 12 hour clock has a "range" of 12, so "13 o'clock" is equal to 1 o'clock and 23:00 == 11PM, etc.  My clocks are rectangular...

So for each prime number p(n), I find where it would be on the clock, and then do the same for the Fibonacci number **of** that prime, F(p(n)).  Then I make a point and connect it to the previous point.  This makes a pattern that grows inside the clock-face box.  Some are crazy and random; some are curiously predictable.

Here are the first number pattern pictures, for modulo 2 through 10, with primes below 100 (i.e. 25 primes) plotted:

[![](plot-100-02-sm.png)](plot-100-02.png)
[![](plot-100-03-sm.png)](plot-100-03.png)
[![](plot-100-04-sm.png)](plot-100-04.png)
[![](plot-100-05-sm.png)](plot-100-05.png)
[![](plot-100-06-sm.png)](plot-100-06.png)
[![](plot-100-07-sm.png)](plot-100-07.png)
[![](plot-100-08-sm.png)](plot-100-08.png)
[![](plot-100-09-sm.png)](plot-100-09.png)
[![](plot-100-10-sm.png)](plot-100-10.png)

Here are a few pattern pictures where the modulo is *only* the prime number 31.  Each chart shows the "primes below" an increasingly higher number.  The first shows primes below 10, then 20, 30, 40, 50, 1000 and the last chart shows primes below 10,000.

[![](plot-010-31-sm.png)](plot-010-31.png)
[![](plot-020-31-sm.png)](plot-020-31.png)
[![](plot-030-31-sm.png)](plot-030-31.png)
[![](plot-040-31-sm.png)](plot-040-31.png)
[![](plot-050-31-sm.png)](plot-050-31.png)
[![](plot-1000-31-sm.png)](plot-1000-31.png)
[![](plot-10000-31-sm.png)](plot-10000-31.png)

These might make a cool "flip-book" PNG animation for math geeks.  Maybe I'll do that...

**UPDATE**

Here is an animated gif of the above:

![animated-fib-primes.gif](animated-fib-primes.gif)

And [here is a table of images](http://www.ology.net/dev/slice-seq/) showing the x-axis: prime limit up to 100, by 10's, and the y-axis: modulo 2 to 31.

And [here is the companion table of images](http://www.ology.net/dev/slice-seq-to-1000/) showing the x-axis: prime limit up to 1000, by 100's, and the same y-axis: modulo 2 to 31.

Fascinating.

