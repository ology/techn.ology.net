---                                                                                                                                                                          
status: published
title: An Image Collage of CPAN Authors
tags:
  - perl
  - software
---

![Collage](collage-2x2.jpg)
It's a lazy Sunday, so I thought I'd resurrect a clunky program I wrote a while back, and fix it up...

tl;dr: [cpan-avatars](https://github.com/ology/Modules/blob/master/cpan-avatars)

---

The standard perl preamble:

    #!/usr/bin/env perl
    use strict;
    use warnings;

The imports that the program depends upon:

    use HTTP::Simple qw(get getstore);
    use Imager;
    use List::SomeUtils 'first_index';
    use List::Util 'shuffle';
    use Mojo::DOM;
    use Mojo::File;
    use Parse::CPAN::Authors;

The program parameters, i.e. variables that define the bounds and behavior:

    my $side  = shift || 3;
    my $start = shift // 0;
    my $path  = shift || $ENV{HOME} . '/tmp/avatars/';

    my $width = 130;            # Fixed avatar side pixel size
    my $size  = $width * $side; # The width of the collage
    my $max   = $side * $side;  # Number of avatars to fetch

    my $base = 'https://metacpan.org/author/';
    my $cpan = 'http://www.cpan.org/authors/';
    my $file = '01mailrc.txt.gz';

    my %authors;

Now we get to the actual functionality of the program:

    $path = Mojo::File->new($path);
    unless (-d $path) { 
        $path->make_path;                                                                                                                                                        
    }

    get_file($cpan . $file, $file, "Saved $file");

    my $pca = Parse::CPAN::Authors->new($file);

    for my $author ($pca->authors) {
        $authors{ $author->pauseid } = $base . $author->pauseid;
    }

This makes sure there is a place on the file system for the avatars and collage files, then fetches *all* the [CPAN](https://metacpan.org/) authors. Finally, the code populates the list of authors with their CPAN author url.

Next, if not asking for a random selection, and if the "start" argument has been given as an author name (not a numeric id), find the index of "start" in the sorted list of authors:

    if ($start ne '-1' && $start =~ /[A-Za-z]/) {
        my $author = $start;
        $start = first_index { CORE::fc($_) eq CORE::fc($author) } sort keys %authors;
        die "Author '$author' not found\n"
            if $start < 0;
    }

Now the actual avatar image files are downloaded until the maximum is reached:

    my $i = 0;

    my @displayed; # Bucket for the displayed authors

    for my $author ($start == -1 ? shuffle keys %authors : sort keys %authors) { 
        $i++;

        next if $start > -1 && ($i - 1) < $start;

        sleep 4 if @displayed; # play nice

        my $content = get($authors{$author});
        my $dom = Mojo::DOM->new($content);
        my $img = $dom->find('img[alt="Author image"]')->[0]->attr('src');
        my $img_file = $path->child($author);
        get_file($img, $img_file, "$i. Saved $img_file");

        push @displayed, $author;

        last if @displayed >= $max;
    }

Next up is to build an HTML image map.  I'll leave-out the HTML markup, but the logic is thus:

    my $html = <<'HTML';
    ...

    my $collage = Imager->new(xsize => $size, ysize => $size)
        or die "Can't create image: ", Imager->errstr;

    $i = 0; # reset the incrementer
    my $x = 0;
    my $y = 0;

    for my $author (sort @displayed) {
        my $img_file = $path->child($author);
        next unless -e $img_file;

        my $img = Imager->new;
        $img->read(file => $img_file)
            or die "Can't read $img_file: ", $img->errstr;

        unlink $img_file;

        if ($x >= $side) {
            $x = 0;
            $y++;
        }
        my $x0 = $x * $width;
        my $x1 = $x0 + $width;
        my $y0 = $y * $width;
        my $y1 = $y0 + $width;

        $html .= qq|<area shape="rect" coords="$x0,$y0,$x1,$y1" alt="$author" href="$base$author" title="$author">\n|;

        $collage->paste(left => $x0, top => $y0, img => $img);

        $i++;
        $x++;

        last if $i >= $max;
    }

Finally, the collage image and HTML files are saved:

    $file = $path->child('collage.jpg');
    $collage->write(file => $file) or
        die "Can't write to $file: ", $collage->errstr;
    print "Saved $file\n";

    $html .= <<'HTML';
    ...

    $file = $path->child('collage.html');
    write_text($file, $html);
    print "Saved $file\n";

So, running this command:

    $ perl cpan-avatars 6 gene

Creates this [web page/image map](collage.html).

Voila!
:D
