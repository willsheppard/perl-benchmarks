use strict;
use warnings;

use Benchmark qw(
  cmpthese
  timethese
);

my $str = 'plant_series';

my $results = timethese(
    -1, # Seconds to run
    {
	regex => sub {
	    $str =~ /(.+)_series/;
	},
	substr => sub {
	    substr($str, -7);
	},
    }
);
cmpthese( $results );
