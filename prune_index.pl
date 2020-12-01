#!/usr/bin/env perl
use strict;
use warnings;

use File::Basename qw(dirname);
use File::Find::Rule;
use File::Copy qw(move);
use YAML::XS qw(LoadFile);

# This divides the beginning of the post from the "meat"
my $marker = qr|<p>~</p>|;

my $conf = LoadFile('site.yml');

my @files = File::Find::Rule->file()
    ->name('*.html')
    ->in("$conf->{deploy}{path}/blog/page");

unshift @files, "$conf->{deploy}{path}/index.html";

for my $source (@files) {
    my $dir = dirname($source);
    my $dest = "$dir/pruned.html";

    open(my $in, '<', $source)
        or die "Can't read $source: $!";
    open(my $out, '>', $dest)
        or die "Can't write $dest: $!";

    while (my $line = readline($in)) {
        if ($line =~ $marker) {
            while (my $temp = readline($in)) {
                if ($temp =~ m|</article>|) {
                    print $out $temp;
                    last;
                }
            }
        }
        print $out $line
            unless $line =~ $marker;
    }

    close $in
        or die "Can't close $source: $!";
    close $out
        or die "Can't close $dest: $!";

    move($dest, $source)
        or die "Move of $dest to $source failed: $!";
}
