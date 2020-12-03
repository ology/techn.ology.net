#!/usr/bin/env perl

use Mojolicious::Lite;
use HTML::WikiConverter;
use Text::Unidecode qw(unidecode);

my $wc = HTML::WikiConverter->new(dialect => 'MediaWiki');

plugin wordpress => { base_url => 'http://techn.ology.net/wp-json' };
 
get '/post/:slug' => sub {
  my $c = shift->render_later;
  $c->wp->get_post_p($c->stash('slug'))->then(sub {
    my $post = shift;

#    $c->render(json => $post);

#    my $content = $post->{content}{rendered};
#    $c->render(text => $content);

    my $content = $wc->html2wiki(html => unidecode($post->{content}{rendered}));

    my $file = '/Users/gene/tmp/wpfetch.markdown';
    open(my $fh, '>', $file)
        or die "Can't write $file: $!";
    print $fh $content;

    $c->render(text => '<pre>'.$content.'</pre>');
  });
};

app->start;
