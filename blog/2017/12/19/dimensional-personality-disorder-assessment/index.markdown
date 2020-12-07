---
status: published
title: Dimensional Personality Disorder Assessment
tags:
    - perl
    - psychology
---

![](tim.jpg)
[Timothy W. Butcher](http://obits.oregonlive.com/obituaries/oregon/obituary.aspx?pid=160646732) and I collaborated on a number of diverse projects.  One was a personality disorder quiz that he devised while taking an abnormal psychology university course.

---

Since 1999, when we made it, the quiz and the anonymous data and chart history has been lost to time.  But recently I found and resurrected [the quiz itself](http://dev.ology.net:8050/overview)!

It is **196** questions long - Whew!  But that is what it takes for an accurate questionnaire about multiple personality disorders.

Unfortunately, a number of the questions are difficult in their wording.  I wish Tim was still around to discuss, clarify, and refine them...

Back then, my part was to make it interactive and "on-line."  Briefly, here is how it works, underneath the hood.  (And here is [the code](https://github.com/ology/DPDA).)

For a user interface this time around, I chose [Dancer2](https://metacpan.org/pod/Dancer2) as a web framework.  Also, I need to chart the results and for that I chose to use the [GD::Graph::Data](https://metacpan.org/pod/GD::Graph::Data) module.

There are a few routes ("web addresses that are understood by the app"), but the most important ones are for question/response and final result computation.

To keep track of the question/answer history for a quiz taker, I use a simple cookie.  This allows multiple questionnaires to be running concurrently.  Also, this allows a person to take a break from the quiz (as long as they don't clear their browser cookies).

For the question route, I first get our quiz progress and then handle the history.   This is done by clearing the history **if** we are on question number one, and to transform it into an array and hash reference for later use, otherwise.

Next we load the quiz questions and get a random, unseen one.

Ok.  When a response has been made to a question, by submitting on the web, the quiz route is invoked.

Next, a "question|answer" item added to the history, and the progress is incremented.  If we are past the last question, then go to the finalize chart route, otherwise, ask another question!

And what is that last step?  Well, I defer to the code itself.  Again, if Tim were here, I would ask him for the statistical formulae being used, so that I could say succinctly what is being computed: In the final "/chart" route, the history is handled as above, and the quiz is loaded to access the metadata for each question - "category" and "polarity."  Next, the results are calculated, the categories ordered, the average responses calculated, the "discord" ("dishonesty", "ambivalence") calculated and finally a bar chart is rendered.

Now to test that the quiz results were accurate, I wrote a little [Test::WWW::Mechanize script](https://github.com/ology/DPDA/blob/master/bin/mech-test) to test the boundaries.  You can see the results of having every disorder to having none of the disorders, on the quiz [Sample Results](http://dev.ology.net:8050/sample) page.

