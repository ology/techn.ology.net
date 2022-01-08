---                                                                                                                                                                          
status: published
title: Git Status Over a Repository Sandbox
tags:
  - perl
  - software
---

Do you want to have a birds-eye view of an entire directory of repositories?

tl;dr: [gitstat](https://github.com/ology/Miscellaneous/blob/master/gitstat)

---

I have a sandbox with over a hundred repositories.  This is probably small compared to many uber-geeks.  But anyway, I made an app that does that!  And here it is...

The standard perl preamble:

    #!/usr/bin/env perl
    use strict;
    use warnings;

Imports that the program depends upon:

    use File::Find::Rule ();
    use IO::Prompt qw(prompt);
    use List::Util qw(any);
    use DateTime ();
    use DateTime::Format::DateParse ();
    use Time::Ago ();

Accept program arguments for either quick summary or interactive view, and the location of the repositories:

    my $summary = shift // 0;
    my $path = shift || $ENV{HOME} . '/sandbox';

Ok. First-up, we get a list of the possible repositories:

    my @repos = File::Find::Rule
      ->maxdepth(1)
      ->directory
      ->not(File::Find::Rule->new->name(qr/^\./)) # Skip .dot dirs
      ->in($path);

Next is the loop over these in ASCII-betical order, skipping any without a ".git" directory.  For each that *is* a repo, change to that directory and get the branch name.  Then we either print a quick summary, or switch to interactive mode.

    REPO: for my $repo (sort @repos) {
        ...

If we choose to show a summary (with a "1" as the first program argument), an optional "DIRTY" flag is printed with the time since the last commit.  Here is the code for that:

    my $git = qx{ git diff --stat };
    print ' - DIRTY' if $git;
    print "\n";

    $git = qx{ git log -1 --format=%cd };
    chomp $git;
    my $last = DateTime::Format::DateParse->parse_datetime($git, 'local');
    my $duration = $now->subtract_datetime_absolute($last);
    $git = Time::Ago->in_words($duration->seconds);
    print "\tLast commit $git ago\n";

Interactively:

    while (1) {
      printf "\n%0*d. %s (%s)", $width, $i, $repo, $branch;

      my $git = qx{ git diff --stat };
      print ' - DIRTY' if $git;
      print "\n";

      my $response = prompt 'Enter=next q=quit s=status p=pull f=prune: ';

      if ($response eq 'q') {
        last REPO;
      }

Ok. We prompt the user for their choice. If this is "q", we bail-out of the program.  The other 4 conditions are as follows:

      elsif ($response eq 's') {
        my $git = qx{ git status --untracked-files=no };
        $git =~ s/^On branch [\w\-\/]+//;
        $git =~ s/\s*\(.+?\)//gm;
        $git =~ s/\n+/\n/gm;
        print $git;

        $git = qx{ git branch -a };
        print "\n$git";

        $git = qx{ git log -1 --format=%cd };
        print "\nLast commit on $git";
      }

This performs a git status, prints out the branches of the repository, and then prints out how long it was since the last commit.

      elsif ($response eq 'p') {
        my $git = qx{ git pull };
        print "\n$git";
      }

Sometimes I want to pull.  Some people abhor pulling... Fortunately, this program is open source!

      elsif ($response eq 'f') {
        my $git = qx{ git fetch --prune };
        $git =~ s/\n+/\n/gm;
        print $git;
      }

Sometimes I want to fetch everything *and* get rid of the branches that have been deleted.

The final condition is just to skip to the next repo with:

      else {
        next REPO;
      }

I run this in the shell by putting this in my ~/bin directory, making it executable, then saying:

    $ gitstat 1

And look for DIRTY repos.  Or interactively, for instance:

    $ gitstat 0 ~/repos

Anyway, the point is that you can execute any git shell commands with the perl "qx" operator and a bit of tweezing!

-Peace-
