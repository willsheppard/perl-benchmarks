=pod

See also benchmark.pl in Readonly package

=cut

use strict;
use warnings;

use Benchmark ':hireswallclock';
use Readonly;
use Time::HiRes;

my $feedme;

use constant AA => "I'm not crazy, my mother had me tested.";
sub constant_native { $feedme = AA }

use Const::Fast;
const my $BB => "I'm not crazy, my mother had me tested.";
sub const_fast { $feedme = $BB }

use Readonly;
Readonly my $CC => "I'm not crazy, my mother had me tested.";
sub constant_readonly { $feedme = $CC }

my $code = {
    constant_native     => &constant_native,
    const_fast          => &const_fast,
    constant_readonly   => &constant_readonly,
};

timethese(20_000_000, $code);
