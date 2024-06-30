=pod

See also benchmark.pl in Readonly package

=cut

use strict;
use warnings;

use Benchmark ':hireswallclock';
use Readonly;
use Time::HiRes;

my $feedme;

# Baseline
use constant AA => "I'm not crazy, my mother had me tested.";
sub constant_native { $feedme = AA }

# As fast as 'use constant'
use Const::Fast;
const my $BB => "I'm not crazy, my mother had me tested.";
sub const_fast { $feedme = $BB }

# Very slow
use Readonly;
Readonly my $CC => "I'm not crazy, my mother had me tested.";
sub constant_readonly { $feedme = $CC }

# A bit slower than Const::Fast
use feature 'state';
sub state_variable {
    state $DD = "I'm not crazy, my mother had me tested.";
    $feedme = $DD;
}

my $code = {
    constant_native     => \&constant_native,
    const_fast          => \&const_fast,
    constant_readonly   => \&constant_readonly,
    state_variable	=> \&state_variable,
};

timethese(20_000_000, $code);
