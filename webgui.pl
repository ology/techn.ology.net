#!/usr/bin/env perl

use Mojolicious::Lite -signatures;
use File::Find::Rule;
use Mojo::File;

get '/' => sub ($c) {
  my @files = File::Find::Rule->file()->name('*.markdown')->in('blog');
  my %posts;
  for my $file (@files) {
    if ($file =~ m|^blog/([\d/]+)/([\w-]+)/index.markdown$|) {
      my $date = $1;
      my $slug = $2;
      $posts{$slug} = {
        date => $date,
        title => titleize($slug),
      };
    }
  }
  $c->render(
    template => 'index',
    posts => \%posts,
  );
};

get '/edit' => sub ($c) {
  my $date = $c->param('date');
  my $slug = $c->param('slug');
  my $file = Mojo::File->new('blog/' . $date . '/' . $slug . '/index.markdown');
  $c->render(
    template => 'edit',
    date => $date,
    slug => $slug,
    title => titleize($slug),
    content => $file->slurp,
  );
} => 'view';

post '/edit' => sub ($c) {
  my $date = $c->param('date');
  my $slug = $c->param('slug');
  my $content = $c->param('content');
  $content =~ s/\r\n/\n/g;
  my $file = Mojo::File->new('blog/' . $date . '/' . $slug . '/index.markdown');
  $file->spurt($content);
  $c->redirect_to($c->url_for('view')->query(date => $date, slug => $slug));
} => 'edit';

sub titleize {
  my ($slug) = @_;
  (my $title = $slug) =~ s/[_-]/ /g;
  $title =~ s/([\w']+)/\u\L$1/g; # Capitalize every word
  return $title;
}

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Statocles UI Posts';
<h2>Posts</h1>
% for my $slug (sort { $posts->{$b}{date} cmp $posts->{$a}{date} } keys %$posts) {
<p><%= $posts->{$slug}{date} %>: <a href="<%= url_for('view')->query(date => $posts->{$slug}{date}, slug => $slug) %>"><%= $posts->{$slug}{title} %></a></p>
% }

@@ edit.html.ep
% layout 'default';
% title 'Statocles UI Post';
<h1><%= $title %></h1>
<h4><%= $date %></h4>
<p></p>
<form method="post">
<input type="hidden" name="date" value="<%= $date %>"/>
<input type="hidden" name="slug" value="<%= $slug %>"/>
<textarea name="content" rows="20" cols="100"><%= $content %></textarea>
<p></p>
<input type="submit" value="Submit"/>
</form>
<p><a href="/">Back to Posts</a></p>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>
