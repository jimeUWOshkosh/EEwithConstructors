package Tweet;

# use strict; Moose brings in strict
# use warnings; Moose brings in warnings

use Moose;
use DateTime;

#use feature 'say';
use namespace::autoclean;

our $VERSION = qw(0.01);

=head1 NAME

Tweet - Pseudo Twitter Tweet Object

=head1 VERSION

version 0.01

=head1 AUTHOR

James Edwards

=head1 SYNOPSIS

 use Tweet;

 my $mesg = Tweet->new( mesg => 'MadMongers rock' );

=head1 DESCRIPTION

An Object to hold info about an individual tweet.

=head1 Accessor(s)

=head2 mesg

  data_type:    Str

=head1 Default Attribute(s)

=head2 dt

  data_type:    DateTime
  value:        local time_zone now

=cut

has 'mesg', is => 'rw', isa => 'Str';

=head1 SUBROUTINES/METHODS


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 LICENSE AND COPYRIGHT

Ya Right

=cut

__PACKAGE__->meta->make_immutable;

1;
