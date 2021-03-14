---
status: published
title: Releasing Perl Modules to CPAN
tags:
  - perl
  - software
---

These steps assume that you do *not* have a local `git` repository for your module yet, *but* that your module and tests are located in `~/sandbox/Your-Module-Name`.

---

* Have the programs `git`, and of course `perl` and friends, installed on your machine.

* Make a [PAUSE account](https://pause.perl.org/pause/query?ACTION=request_id) for uploading to [CPAN](https://www.cpan.org/).

* Make a [github account](https://github.com/join?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home) to house your module(s).

* Make a [github repository](https://github.com/new) for `Your-Module-Name` with a readme file, but without .gitignore or license files.

* Make a local directory for your module.  From your `~` home directory do this:

    mkdir repos;
    cd repos;
    git clone git@github.com:BD3i/Your-Module-Name.git

* Install the necessary Perl modules to build a distribution:

    cpanm Dist::Zilla Dist::Zilla::MintingProfile::Starter Dist::Zilla::Plugin::GithubMeta Dist::Zilla::Plugin::NextRelease Dist::Zilla::Plugin::VersionFromMainModule

* Make a new Dist::Zilla distribution:

    cd # Go back to ~
    dzil setup
    dzil new -P Starter Your::Module::Name

* Move your new distribution to the git directory for `Your-Module-Name`:

    mv Your-Module-Name/* repos/Your-Module-Name/
    rm -rf Your-Module-Name
    cd repos/Your-Module-Name

* Add this as a new `Changes` file:

    Revision history for Your-Module-Name

    {{$NEXT}}
        - Minted by Dist::Zilla.

* Fix-up your `dist.ini` file to look like this:

    name    = Your-Module-Name
    author  = Your Name <you@cpan.org>
    license = Artistic_2_0
    copyright_holder = Your Name
    copyright_year   = 2021

    [VersionFromMainModule]

    [@Starter]
    revision = 5

    [NextRelease]
    format = %v %{yyyy-MM-dd HH:mm:ss}d

    [GithubMeta]

* Generate a license file:

    dzil build
    cp Your-Module-Name/LICENSE .
    dzil clean

* Add your tests:

    cp ~/sandbox/Your-Module-Name/t .

* But if you have none, start with this as `t/01-functions.t` (or `01-methods.t` if OO):

    use Test::More;

    use_ok 'Foo::Bar';

    done_testing();

* Merge your module code with the generated module:

    vimdiff ~/sandbox/Your-Module-Name/lib/Your/Module/Name.pm lib/Your/Module/Name.pm

* Add your files to the `git` repository:

    git add *
    git commit -a -m 'Initial commit'
    git push

* Test your distribution:

    dzil test

* If everything is ok, and if you have recieved confirmation of your PAUSE account, then upload:

    dzil release
    dzil clean

* You will soon get a couple email messages saying that (hopefully) your distribution has been accepted.

* Check [MetaCPAN](https://metacpan.org/recent) for your new release.

