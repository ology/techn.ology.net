---
status: published
title: Using WWW::Spotify
tags:
  - perl
  - software
---

Last year, I wrote a [music player](https://github.com/ology/audio-player) for myself that fetches and displays cover art. This weekend I added artist image and genres via the excellent [WWW::Spotify](https://metacpan.org/pod/WWW::Spotify) module. Here's how:

---

In order to get this working, you have to have a [Spotify developer account](https://developer.spotify.com/dashboard/). Once you have this, add the bits to a `settings.yml` file, like:

    oauth_client_id: abcdefghijklmnopqrstuvwxyz
    oauth_client_secret: 12345678901234567890

Ok, on with the show!  First is the standard perl preamble:

    #!/usr/bin/env perl
    use strict;
    use warnings;

Next are the modules to use (with the specific functions declared):

    use Data::Dumper::Compact qw(ddc);
    use Getopt::Long qw(GetOptions);
    use WWW::Spotify;
    use YAML::XS qw(LoadFile);

This program is a command-line script that takes the following arguments:

    my %opts = (
        artist => undef,
        album  => undef,
        track  => undef,
        config => 'settings.yml',
        limit  => 10,
        max    => 50,
    );
    GetOptions( \%opts,
        'config=s',
        'artist=s',
        'album=s',
        'track=s',
        'limit=i',
        'max=i',
    );

But in order to do anything, we must have an **artist** name. Then the program will use either a **track** or an **album** if provided. If neither are given, the artist is looked up. Also an alternate configureation file, Spotify batch size (**limit**), and the Spotify **max**imum number of records to fetch, may be given.

    die qq/Usage: perl $0 artist="Gene Boggs" [album="X"|track="Clubster"] [config="settings.yml"]\n/
        unless $opts{artist};

Load up the configuration file bits:

    my $cfg = LoadFile($opts{config});

And now create a new, authorized WWW::Spotify instance, that returns search results as a perl hash reference:

    my $spotify = WWW::Spotify->new;
    $spotify->oauth_client_id($cfg->{oauth_client_id});
    $spotify->oauth_client_secret($cfg->{oauth_client_secret});
    $spotify->force_client_auth(1);
    $spotify->auto_json_decode(1);

Construct our Spotify query based on the given **track**, **album**, or **artist**:

    my $key   = $opts{track} ? 'track' : $opts{album} ? 'album' : 'artist';
    my $keys  = $key . 's';
    my @query = ($opts{$key}, $key);

Assign a couple of handy variables for our Sportify search bounds:

    my ($limit, $max) = @opts{ qw(limit max) };

And then use those bounds to compute the loop that grabs batches of Spotify results:

    BATCH: for (my $i = 0; $i <= $max; $i += $limit) {
        my $batch = $max - $i < $limit ? $max - $i + 1 : $limit;
        warn "offset=$i, limit=$batch\n";

Ok, now actually fetch the results from Spotify:

        my $result = $spotify->search(
            @query,
            { limit => $batch, offset => $i }
        );

Then inspect each of the items returnd, if any:

        for my $item ($result->{$keys}{items}->@*) {

If we are searching for an artist, check the name of the item, and if it matches __exactly__, then print out the artist's genres, second image, and bail out of the batch search entirely:

            if ($key eq 'artist' && $item->{name} eq $opts{artist}) {
                print 'Genres: ', join(', ', $item->{genres}->@*), "\n",
                    "Image: $item->{images}[1]{url}\n";
                last BATCH;
            }

Why the second image and not the first? Because for my purposes, the first image is generally too large. YMMV!

If we are searching for an album or track, check that the name of the item __begins__ with the right name. If so, print out second image, and bail out of the batch search entirely:

            elsif ($item->{name} =~ /^$opts{$key}\b/
                && defined $item->{artists}[0]{name}
                && $item->{artists}[0]{name} eq $opts{artist}
            ) {
                my $val = $key eq 'track'
                    ? $item->{album}{images}[1]{url}
                    : $item->{images}[1]{url};
                print "Image: $val\n";
                last BATCH;
            }

Why do we check that the name begins with rather than is exactly the same? Because some tracks have, for example the phrase " (Remastered)" appended.

        } # End of items
    } # End of batch

And that's it!

Here are a couple runs:

    > perl www-spotify --artist='KISS'
    Genres: album rock, glam rock, hard rock, metal, rock
    Image: https://i.scdn.co/image/ab676161000051744e85269a1f35917eddeadefd

    > perl www-spotify --artist='KISS' --track='Firehouse'
    Image: https://i.scdn.co/image/ab67616d00001e025621f132b6d5ce5254b5aa2a

    > perl www-spotify --artist='KISS' --album='Destroyer'
    Image: https://i.scdn.co/image/ab67616d00001e029309dd399ed75be936b8c1b6

