=pod

See also benchmark.pl in Readonly package

=cut

use strict;
use warnings;

use Benchmark ':hireswallclock';
use Readonly;
use Time::HiRes;

my $feedme;
my $test_string = "I'm not crazy, my mother had me tested.";

use constant AA => "I'm not crazy, my mother had me tested.";

use Const::Fast;
const my $BB => $test_string;

use Readonly;
Readonly my $CC => $test_string;

die AA;

my $code = {const     => \&const,
            literal   => \&literal,
            tglob     => \&tglob,
            normal    => \&normal,
            ro        => \&ro,
            ro_simple => \&ro_simple,
            rotie     => \&rotie,
};

timethese(20_000_000, $code);
