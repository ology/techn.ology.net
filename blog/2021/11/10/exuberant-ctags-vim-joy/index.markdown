---
status: published
title: Exuberant Ctags + vim = Joy
tags:
    - software
---
There are a couple thousand posts on how cool [Exuberant Ctags](http://ctags.sourceforge.net/) is... This is another!

---
I am a programmer and use ctags for a couple perl things:

* To index every perl package - core and from CPAN.

* To index the perl packages under the `lib` and `t` directories.

I will only cover the second.  (The first is easy if you understand the second.)

So first is to install Exuberant Ctags.  For my mac, that's just `brew install ctags`.  On my Ubuntu linux box, that's: `sudo apt-get install exuberant-ctags`.

I use a custom `~/.ctags` file with directives that tells ctags to parse perl packages only.  This is:

    --recurse=yes
     
    --exclude=.git
    --exclude="*.txt"
    --exclude="*.md"
    --exclude="*.log"
    --exclude="*.out"
    --exclude="*.yml"
    --exclude="*.conf"
    --exclude="*.json"
    --exclude="*.js"
    --exclude="cpanfile"
     
    --extra=+q
     
    --langmap=perl:.pm
     
    --regex-perl=/with[ \t]+([^;]+)[ \t]*?;/\1/w,role,roles/
    --regex-perl=/extends[ \t]+['"]([^'"]+)['"][ \t]*?;/\1/e,extends/
    --regex-perl=/^[ \t]*?use[ \t]+base[ \t]+['"]([^'"]+)['"][ \t]*?;/\1/e,extends/
    --regex-perl=/^[ \t]*?use[ \t]+parent[ \t]+['"]([^'"]+)['"][ \t]*?;/\1/e,extends/
    --regex-perl=/^[ \t]*?use[ \t]+Mojo::Base[ \t]+['"]([^'"]+)['"][ \t]*?;/\1/e,extends/
    --regex-perl=/^[ \t]*?use[ \t]+([^;]+)[ \t]*?;/\1/u,use,uses/
    --regex-perl=/^[ \t]*?require[ \t]+((\w|\:)+)/\1/r,require,requires/
    --regex-perl=/^[ \t]*?has[ \t]+['"]?(\w+)['"]?/\1/a,property,properties/
    --regex-perl=/^[ \t]*?\*(\w+)[ \t]*?=/\1/b,alias,aliases/
    --regex-perl=/->helper\([ \t]?['"]?(\w+)['"]?/\1/h,helper,helpers/
    --regex-perl=/^[ \t]*?our[ \t]*?[\$@%](\w+)/\1/o,our,ours/
    --regex-perl=/^[ \t]*?my[ \t]*?(\$\w+)[ \t]*?=[ \t]*?sub/\1/s,private subroutine,private subroutines/

I stitched this together from a couple places.  One being [kberov/ctags](https://github.com/kberov/ctags) on github.

Next for me is to add a bash alias for making the `tags` files that are constantly re-created (when there are new bits pulled from git origin):

    alias retag='cd lib; ctags -R; cd -; cd t; ctags -R; cd -'

Lastly, a ctags directive is needed in the `~/.vimrc` file.  This needs to point to a few places: 1. the core and cpan perl (an absolute directory that is not covered here) and 2. the relative directories to lib and t.  And what is that directive?

    set tags=lib/tags,t/tags

Now when you are in a script.pl perl file, you position the cursor over a subroutine or module name and key CTRL+].  This jumps you to the subroutine definition or top of the module, respectively.

To return to the previous position, key CTRL+o.

Voila!
