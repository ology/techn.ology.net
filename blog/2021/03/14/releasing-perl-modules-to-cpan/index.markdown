---
status: published
title: Releasing Perl Modules to CPAN
tags:
  - perl
  - software
---

These steps assume that your module and tests are located in `~/sandbox/Your-Module-Name` and that you are friends with the command line.

---

Have the programs `git`, and of course `perl` and friends, installed on your machine.

Make a [PAUSE account](https://pause.perl.org/pause/query?ACTION=request_id) for uploading to [CPAN](https://www.cpan.org/).  This is not instant and may take a few days.

Make a [github account](https://github.com/join?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home) to house your module(s).

Make a [github repository](https://github.com/new) for `Your-Module-Name` without readme, .gitignore or license files.

Install the necessary Perl modules to build a distribution:

    cpanm Dist::Zilla Dist::Zilla::MintingProfile::Starter::Git Dist::Zilla::App::Command::installdeps

Make a repository directory for your distribution:

    mkdir ~/repos
    cd ~/repos

Setup [Dist::Zilla](https://metacpan.org/pod/Dist::Zilla) (optionally with your PAUSE id and password):

    dzil setup

Make a new distribution for your module:

    dzil new -P Starter::Git Your::Module::Name
    cd Your-Module-Name

Add this as a `README.md` file:

    # Your-Module-Name
    ---
    The description of your module...

Add this as a new `Changes` file:

    Revision history for Your-Module-Name

    {{$NEXT}}
        - Minted by Dist::Zilla.

Open the `dist.ini` file in your favorite editor, and make it look like this:

    name    = Your-Module-Name
    author  = Your Name <your_pause_id@cpan.org>
    license = Artistic_2_0
    copyright_holder = Your Name
    copyright_year   = 2021

    [@Starter::Git]
    revision = 5
    managed_versions = 1
    regenerate = LICENSE

    [GithubMeta]

    [AutoPrereqs]

Add your module tests:

    cp -R ~/sandbox/Your-Module-Name/t .

Merge your module with the generated one (with an editor like [vim](https://www.vim.org/)):

    vim -O ~/sandbox/Your-Module-Name/lib/Your/Module/Name.pm lib/Your/Module/Name.pm

Install the dependencies for your module:

    dzil installdeps

Generate a license file:

    dzil regenerate

Commit everything to github:

    git add .
    git commit -a -m 'Initial commit'
    git remote add origin git@github.com:your_github_id/Your-Module-Name.git
    git push -u origin main

Test your distribution:

    dzil test

If everything is ok, and if you have recieved confirmation of your PAUSE account, then upload:

    dzil release
    dzil clean

You will soon get a couple email messages (hopefully) saying that your distribution has been accepted.

Check [MetaCPAN](https://metacpan.org/recent) for your new release.

And to know all about it, check out [Dist::Zilla::Starter](https://metacpan.org/pod/Dist::Zilla::Starter) - Thanks [Grinnz](https://metacpan.org/author/DBOOK) :-)

