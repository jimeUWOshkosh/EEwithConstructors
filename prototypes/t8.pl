#!/usr/bin/env perl
use strict; use warnings;
use Perl6::Say;
use Data::Dumper;
use Ouch;
use Try::Tiny;

sub bye      { say 'bye'; return 99;}
sub Location { say 'Location'; return 55;}


my @argz0 = (
        [ 'ASSERT', (sub {Location(bye(1))} ), ],
);
sub testee {
  my (@steps) = @_;
  say $steps[0][0];
  my $rc = $steps[0][1]();
}

testee(@argz0);

exit 0;

