package PurchaseClones;
use feature 'say';
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Moose;
use lib 'lib';
use myfilter;
use Steps qw(Area Clone Event Inventory Location Stats Wallet);
use Tweet;

has key => (
   is      => 'rw',
   default => undef,
);

sub new_exchange {
   my ($slug,        $slugtxt, 
       $successmsg,  $successmsgtxt,
       $failuresmsg, $failuresmsgtxt,
       $steps) = @_;
   say $steps->rc;

# to work in cohort with Steps::$TESTING
#
#   say $steps->trans_mesg
#

   return PurchaseClones->new();
}

sub price { say "\t\t\tPurchaseClones price"; 1 }

sub station_area { say "\t\t\tPurchaseClones station_area"; 1 }

sub attempt { say "\t\t\tAttempt: finish"; 1 }

sub purchase_clone {
   say 'purchase_clone2';
   my ($self) = @_;
   my $character = Tweet->new( mesg => 'and Irvine');
   my $bet_amount = 1_000_006;
   my $exchange = new_exchange(
      slug            => 'purchase-clone',
      success_message => 'You have purchased a new clone',
      failure_message => 'You could not purchase a new clone',
      Steps(
                  Location( $self      => is_in_area  => 'clonevat'              ),
                  Wallet(   $self      => pay         => $self->price('cloning') ),
                  Clone(    $self      => gestate     => $self->station_area     ),
         FAILURE( Wallet(   $character => remove      => $bet_amount ) ),
         ALWAYS(  Wallet(   $character => 'show_balance') ),
      ),
   );
}


1;
