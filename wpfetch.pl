#!/usr/bin/env perl

use utf8;

use Mojolicious::Lite;
use Mojo::DOM;

plugin wordpress => { base_url => 'http://techn.ology.net/wp-json' };

get '/' => sub { shift->redirect_to('/post/bible-books-cosine-similarity') };
 
get '/post/:slug' => sub {
  my $c = shift->render_later;
  $c->wp->get_post_p($c->stash('slug'))->then(sub {
    my $post = shift;
#    $c->render(json => $post);

    my $dom = Mojo::DOM->new($post->{content}{rendered});
    my $text = $dom->all_text;

    $text =~ s/\r\n/\n/g;
    $text =~ s/\n\n\n/\n\n/g;
    $text =~ s/[“”]/"/g;
    $text =~ s/[‘’]/'/g;
    $text =~ s/[–—]/-/g;
    $text =~ s/…/.../g;

    my $file = '/Users/gene/tmp/wpfetch.txt';
    open(my $fh, '>', $file)
        or die "Can't write $file: $!";
    print $fh $text;

    $c->render(text => $dom);
  });
};

app->start;
