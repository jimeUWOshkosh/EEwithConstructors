package Asset::Event;
use feature 'say';
use Moose;
use experimental 'signatures';
no warnings qw(experimental::signatures);
use namespace::autoclean;
use English;
use Carp 'croak';
use Ouch;

has 'subject' => (
    is  => 'ro',
    isa => 'Object',
);
has 'verb' => (
    is  => 'ro',
    isa => 'Str',
);
has 'object' => (
    is  => 'ro',
    isa => 'Str',
);
has 'arg_text' => (
    is  => 'rw',
    isa => 'Str',
);
has 'rc' => (
    is  => 'rw',
    isa => 'Int',
    default => 0,
);

around BUILDARGS => sub {
    my $orig    = shift;
    my $class   = shift;
    my $perform = shift;
    my ($obj, $rc);
    eval { 
        if      ((scalar(@_) == 1) and (ref $_[0])) {
            ouch 'Bad SVO syntax', 'Bad SVO syntax';
        } elsif ( scalar(@_) == 3 ) {
            my ($subject,$verb,$object) = @_;
            my $str = 'Event ( ' .  blessed($subject)  .  ' => '      .  $verb .
                      ' => '     .  $object            .  " ),\n";
            $rc = ($perform) ? process() : 0;
            $obj = $class->$orig( subject => $subject, verb     => $verb, 
                                  object  => $object,  arg_text => $str,
			          rc      => $rc );
        } else {
            ouch 'Bad number of arguments', 'Bad number of arguments';
        }
        1;
    } or do {
        croak $EVAL_ERROR;
    };
    return $obj;
};

sub BUILD {
    my $self = shift;
    return;
}

sub process ($obj) {
    say __PACKAGE__, ':process';
    $obj->rc = 1;
    return;
};

__PACKAGE__->meta->make_immutable;
1;
