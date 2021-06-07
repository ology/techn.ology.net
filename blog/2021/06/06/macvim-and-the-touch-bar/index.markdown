---                                                                                                                                                                          
status: published
title: MacVim and the Apple Touch Bar
tags:
  - software
---

You can add custom buttons to the [Apple Touch Bar](https://support.apple.com/guide/mac-help/touch-bar-mchlbfd5b039/mac) when using [MacVim](https://github.com/macvim-dev/macvim#readme).

---

From [this gist](https://gist.github.com/0x4a616e/31f58e02ffd5d49bb0865c3dce0b5a08), I learned about how to customize the touch bar in vim.  This is something that I have desired for, forever - i.e. having my own, personal vim buttons.  You can do this with gamer keypads, even foot pedals, etc.

Anyway, just add a line like this to your .vimrc file:

    an icon=NSTouchBarComposeTemplate TouchBar.NewBuf :e .<CR>

This adds a touchbar button that opens the "vim buffer explorer."

Save and reopen MacVim. Voila!

(By the way, I don't think you can remove the MacVim "Fullscreen" button.)
