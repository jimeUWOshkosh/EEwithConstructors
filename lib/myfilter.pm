package myfilter;
use strict; use warnings;

use Filter::Util::Call;


sub import {
  my ($self,)=@_;
  my ($found)=0;
  my $i=0;
  my $first_in_group;
  my $stepsp=0;
  my @behaves;

  filter_add( 
    sub {
      my ($status) ;

      if (($status = filter_read()) > 0) {
        if ($found == 0 and /Steps\(/) { 
          $found = 1; 
          $first_in_group = $i;
        }
        if ($found) {
          if (/Steps\(/) {
            my $string;
	    if (/=\s*Steps\(/) {
              s/Steps\(//;
	      chomp;
	      $stepsp = 1;
	      $string = $_;
	    } else {
	      $string = '';
	    }
#==============================================================================
            my $stuff0 = <<"STUFF0";
  Steps->new(
STUFF0
	     $_ = $string . $stuff0;
#==============================================================================
	  } elsif (/;\s*\z/) {
            $found = 0;
            my $save = $_;
            my @sublist = @behaves[$first_in_group..($i-1)];
            my $str;
            for my $l (@sublist) {
              if (not(defined($l))) { $str .= 'undef, '; } 
              else { $str .= "'$l', "; }
            }

            my $k = $i-1;
#==============================================================================
            my $stuff1 = <<"STUFF1";
) 
STUFF1
	     $_ = $stuff1;
#==============================================================================

	    if ($stepsp) {
	      $_ .= ";\n";
	      $stepsp = 0;
	    } else {
	      $_ .= ",\n$save\n";
	    }
          } elsif (/(?<post_trans>FAILURE|ALWAYS|ASSERT)(\()\s+(?<rest>\N.*)(\))\s*,\s*\z/) {
#==============================================================================
	    my $str2 = $+{rest};
            my $stuff2 = <<"STUFF2";
  [ '$+{post_trans}', sub { Steps::${str2} }, ],
STUFF2
             $_ = $stuff2;
#==============================================================================
            $i++;
          } elsif (/\(.*(\))\s*,\s*\z/) {
            s/^\s+//;
            s/,\Z//;
            chomp;
            my $temp = $_;
	    $temp  =~ s/^\s+//;
#==============================================================================
             my $stuff3 = <<"STUFF3";
  [ undef, sub { Steps::$temp }, ],
STUFF3
	     $_ = $stuff3;
#==============================================================================
            $behaves[$i] = undef;
            $i++;
          } else {
            if (/\s*\),\s*\z/) {
              $_ = "\n";
             }
          }
        }
        if ($found == 0 and /\A1;/) { 
        }
      }
      $status;  # return status;
    } 
 )
}
1;
