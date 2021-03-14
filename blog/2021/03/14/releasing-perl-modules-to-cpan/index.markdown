---
status: published
title: Releasing Perl Modules to CPAN
tags:
  - perl
  - software
---

These steps assume that your module and tests are located in `~/sandbox/Your-Module-Name`.

---

Have the programs `git`, and of course `perl` and friends, installed on your machine.

Make a [PAUSE account](https://pause.perl.org/pause/query?ACTION=request_id) for uploading to [CPAN](https://www.cpan.org/).

Make a [github account](https://github.com/join?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home) to house your module(s).

Make a [github repository](https://github.com/new) for `Your-Module-Name` without readme, .gitignore or license files.

Change to your module directory:

    cd ~/sandbox/Your-Module-Name

Add this single line file as `README.md`:

    # Your-Module-Name

Setup your module for use with `git` (if not already a repository):

    git init -b main
    git add .
    git commit -a -m 'Initial commit'

Setup your repository with github:

    git remote add origin git@github.com:your_github_id/Your-Module-Name.git
    git push origin main

Install the necessary Perl modules to build a distribution:

    cpanm Dist::Zilla Dist::Zilla::MintingProfile::Starter::Git Dist::Zilla::App::Command::installdeps

Make new distribution configuration files:

    dzil setup
    dzil new -P Starter::Git Your::Module::Name
    cp Your-Module-Name/dist.ini .
    cp Your-Module-Name/.gitignore .
    rm -rf Your-Module-Name

Add this as a new `Changes` file:

    Revision history for Your-Module-Name

    {{$NEXT}}
        - Minted by Dist::Zilla.

Open the `dist.ini` file and make it look like this:

    name    = Your-Module-Name
    author  = Your Name <your_pause_id@cpan.org>
    license = Artistic_2_0
    copyright_holder = Your Name
    copyright_year   = 2021

    [@Starter::Git]
    revision = 5
    managed_versions = 1
    regenerate = LICENSE

    [NextRelease]
    format = %v %{yyyy-MM-dd HH:mm:ss}d

    [GithubMeta]

    [AutoPrereqs]

Install the dependencies for your module:

    dzil installdeps

Generate a license file and commit everything to github:

    dzil regenerate

    git add .
    git commit -a -m 'Initial commit'
    git push

Test your distribution:

    dzil test

If everything is ok, and if you have recieved confirmation of your PAUSE account, then upload:

    dzil release
    dzil clean

You will soon get a couple email messages (hopefully) saying that your distribution has been accepted.

Check [MetaCPAN](https://metacpan.org/recent) for your new release.

