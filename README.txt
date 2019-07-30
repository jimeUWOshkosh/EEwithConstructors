# Economic Exchange For Everyone Else

Proof of concept of Business State Machine for Transactions

Please review the mdp presentation EEv4.mdp

A 'proof of concept' on Ovid's Declarative Perl Transaction syntax

  Declarative Perl
    Series of Steps in Subject Verb Object Structure
      Iterates over each of the steps in succession, and if any of them fail, 
      all changes are discarded and the failed transaction is logged. If all 
      of the steps succeed, every object which was updated is then stored in 
      the database and we log a successful transaction.

    sub purchase_clone {
       my ($self) = @_;
       ...
       my $succeeded = $self->new_exchange(
            slug            => 'purchase-clone',
            success_message => 'You have purchased a new clone',
            failure_message => 'You could not purchase a new clone',
            Steps(
                      Location( $self      => is_in_area   => 'clonevat'              ),
                      Wallet(   $self      => pay          => $self->price('cloning') ),
                      Clone(    $self      => gestate      => $self->station_area     ),
             FAILURE( Wallet(   $character => remove       => $bet_amount ) ),
             ALWAYS( Wallet( $character => show_balance ) ),
          ),
       );
       ...
    }


1. I used a source filter, "Filter::Util::Call", lib/myfilter.pm 
   Each step must be on a single line!!!
   If you desire something more accommodating, consider yourself to be
   empowered. This is only a proof of concept.

run.pl is a sample program ( $ perl run.pl )

To see filter output
$ perl -d run.pl

Note: That if a step has a subroutine as an argument, it is executed only when 
      the current step/state is under consideration.

main::(run.pl:6):	my $clone = PurchaseClones->new;
  DB<1> n
main::(run.pl:7):	$clone->purchase_clone;
DB<2> s
list the code of the lib/PurchaseClones.pm your favorite way
DB<3> | l 1-300
