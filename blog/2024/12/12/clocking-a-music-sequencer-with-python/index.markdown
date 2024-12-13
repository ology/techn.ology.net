---                                                                                                                                                                          
status: published
title: Clocking a Music Sequencer with Python
tags:
  - Python
  - MIDI
---

So, I got tired of starting up my bloated music app (i.e. "LogicPro X", the industrial strength DAW), which is made for recording and mastering, just to fool with my synths, and using my own timing systems. Since I'm a programmer, naturally I made a python MIDI program! tl;dr: [clock-it.py](https://github.com/ology/Music/blob/master/clock-it.py)

---

For the record, I can play the keyboard. And, my eurorack can "play itself" - e.g. evolving, ambient things. No, what I needed was a MIDI "clock" to tell my sequencer about the timing to use.

"Why do you need that?", you ask. Strictly, I don't. Music is not mission critical. Haha. But sequencers can (often) be driven externally, by a periodic MIDI clock signal. My Intellijel "Metropolix" can, at least... (And yes, my fellow eurorack friends, you can definitely buy a Pamela's Workout to do many more clock things all at once. I have one, and it is amazing.)

Anyway, this signal doesn't have to be regular at all! It can be completely random, or Euclidean, or whatever. (And yes, the Metropolix module can be programmed to do many more things, like with probability, ratcheting, accumulations, etc. etc.) I wanted to just send a clock, mostly because I am a curious cat.

Anyway, on with the code!

First up, we import the functionality we will be using:

    import mido
    import time

Next we define our single subroutine:

    def send_clock(outport, bpm=120):
        # Calculate the time between clock messages (24 PPQN per beat)
        interval = 60 / (bpm * 24)
        try:
            while True:
                outport.send(mido.Message('clock'))
                time.sleep(interval)
        except KeyboardInterrupt:
            outport.send(mido.Message('stop'))
            outport.close()
            print("\nExiting...")

Lastly, we define the MIDI port to output to. For me, that is my cheap USB interface cable. Next, we tell that port we are ready to start, and then call our clock subroutine:

    if __name__ == "__main__":
        with mido.open_output('USB MIDI Interface') as outport:
            outport.send(mido.Message('start'))
            send_clock(outport, bpm=100)

Pretty simple!
