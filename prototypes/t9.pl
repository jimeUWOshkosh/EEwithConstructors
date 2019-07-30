#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';
use Data::Dumper;
use Ouch;
use Try::Tiny;

sub bye          { print 'bye ';       return 99;}
sub love         { say 'love';         return 88;}
sub Location     { say 'Location ', "@_";     return 77;}
sub Substitution { say 'Substitution', "@_"; return 55;}


sub tester {
  my (@steps) = @_;
  my $y = $steps[0][1];
#  say $steps[0][0];
  my $z =$steps[0][2];
  my $rc = $y->(@$z);

  $y = $steps[1][1];
#  say $steps[1][0];
  $z =$steps[1][2];
  $rc = $y->(@$z);

  return;
}

sub wrapper {
  if (0) { return; }

  my @argz0 = (
        [ 'ASSERT', \&Location,     [&bye(1), &bye(), &love(),], ],
#        [ 'ASSERT', \Substitution,  [ bye(1),  bye(),  love(),], ],
        [ 'ASSERT', \&Substitution, [ bye(1),  bye(),  love(),], ],
  );
  tester(@argz0);
}

wrapper();

exit 0;

