package Steps;
use feature 'say';
use feature qw(signatures);
no warnings qw(experimental::signatures);
use Moose;
use namespace::autoclean;
use lib 'lib';
use Ouch;
use Asset::Area;
use Asset::Clone;
use Asset::Event;
use Asset::Inventory;
use Asset::Location;
use Asset::Stats;
use Asset::Wallet;

use Exporter qw(import);

our @EXPORT = qw(Area Clone Event Inventory Location Stats Wallet);

has 'rc' => (
    is  => 'rw',
    isa => 'Int',
);
has 'trans_mesg' => (
    is  => 'rw',
    isa => 'Str',
);

my @procedures; # steps to be performed
my @touched;    # steps that have been attempted
my $perform = 1;

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    my ($obj,$rc);

    if ( @_ == 1 && ! ref $_[0] ) {
        $obj = $class->$orig();
    }
    else {
#        my $bogus_key = shift;
        @procedures = @_;
        $rc = _steps(@procedures);
        $obj = $class->$orig( rc => $rc, trans_mesg => join('',@touched), );
    }

    # gather messages
    return $obj;
};

sub BUILD {
    my $self = shift;
}

sub begin_trans {return 1;}
sub end_trans   {return 1;}
sub roll_back   {return 1;}


sub Area      { return Asset::Area->     new($perform, @_); }
sub Clone     { return Asset::Clone->    new($perform, @_); }
sub Event     { return Asset::Event->    new($perform, @_); }
sub Inventory { return Asset::Inventory->new($perform, @_); }
sub Location  { return Asset::Location-> new($perform, @_); }
sub Stats     { return Asset::Stats->    new($perform, @_); }
sub Wallet    { return Asset::Wallet->   new($perform, @_); }

sub _steps {
   my (@steps) = @_;
   my $pos1 = 0;
   my $obj;
   eval {
     begin_trans();
     my $rc = 1;
     # do ASSERTs, always on top
     while (my ($j,$step) = each @steps) {
       $pos1 = $j;
       last if (not((defined($step->[0])) and ($step->[0] eq 'ASSERT')));
#       say $step->[0]; 
       $obj = $step->[1]();
       # an ASSERT w/ FALSE return code.
       ouch 'No object returned', 'No object returned' if (not $obj);
       $ touched[$pos1]=$obj->arg_text;

       # get out, No more behaviors, create log
       ouch 'Bad ASSERT', 'Bad ASSERT' if (not ($obj->rc));
     }
     my $pos2;
     # do NO or ALWAYS Behaviors
     for my $j ($pos1..$#steps) {
       $pos2 = $j;
       if ( ( not (defined($steps[$j][0])) )  or ($steps[$j][0] eq 'ALWAYS')) {
         $obj = $steps[$j][1]();
         ouch 'No object returned', 'No object returned' if (not $obj);
         $touched[$pos2]=$obj->arg_text;

         # Cleanup, do FAILURE behaviors
         last if (not ($obj->rc));
       }
     }
     # have a FALSE return code
     if (not ($obj->rc)) {
       # hit all FAILUREs, starting where ASSERTs left off
       for my $j ($pos1..$#steps) {
         next if ($touched[$j]);
         if ((defined($steps[$j][0])) and 
             ( ($steps[$j][1] eq 'FAILURE') or ($steps[$j][1] eq 'ALWAYS'))
            ) {
           $obj = $steps[$j][1]();
           ouch 'No object returned', 'No object returned' if (not $obj);
           # what do you do with a bad return code??
           $touched[$pos2]=$obj->arg_text;
           ouch 'Bad Cleanup', 'Bad Cleanup' if (not ($obj->rc));
         }
       }
     }
     # FAILURES need to be logged
     $perform=0;
     while (my ($j,$step) = each @steps) {
       next if ($touched[$j]);
       $obj = $step->[1]();
       ouch 'No object returned', 'No object returned' if (not $obj);
       $touched[$j]=$obj->arg_text;
     }
     $perform=1;
     end_trans();
     1;
   } or do {
     roll_back();
     if (kiss('Bad ASSERT') or kiss('Bad Cleanup')) {
       # We need to log the failed Economic Exchange
       # No need to check the object's return code
       $perform=0;
       while (my ($j,$step) = each @steps) {
         next if ($touched[$j]);
         $obj = $step->[1]();
         ouch 'No object returned', 'No object returned' if (not $obj);
         $touched[$j]=$obj->arg_text;
       }
     } else {
       die $@; # rethrow
     }
   };
   return $perform;
} 

__PACKAGE__->meta->make_immutable;
1;
