#!/usr/bin/env perl
use strict;
use warnings;

use File::Basename qw(dirname);
use File::Find::Rule;
use File::Copy qw(move);
use YAML::XS qw(LoadFile);

my $conf = LoadFile('site.yml');

my @files = File::Find::Rule->file()
    ->name('*.html')
    ->in($conf->{deploy}{path});

for my $source (@files) {
    my $dir = dirname($source);
    my $dest = "$dir/pruned.html";

    open(my $in, '<', $source)
        or die "Can't read $source: $!";
    open(my $out, '>', $dest)
        or die "Can't write $dest: $!";

    while (my $line = readline($in)) {
        if ($line =~ qr|<p><a href="(.*?\.mp3)">.*?\.mp3</a></p>|) {
            $line = qq|<p><audio controls="controls"><source type="audio/mp3" src="$1"></source></p>\n|;
        }
        print $out $line;
    }

    close $in
        or die "Can't close $source: $!";
    close $out
        or die "Can't close $dest: $!";

    move($dest, $source)
        or die "Move of $dest to $source failed: $!";
}
