#!/usr/bin/env perl
use strict; use warnings;
use feature 'say';

sub bye          { print 'bye '; return 99; }
sub love         { say 'love';   return 88; }
sub one          { say 'one';    return 77; }
sub two          { say 'two';    return 66; }
sub Steps {
   say 'Steps';
   say "@_";
   return 55;
}


Steps(
    one(bye(), bye(), love()),
    two(bye(), bye(), love()),
);

exit 0;

