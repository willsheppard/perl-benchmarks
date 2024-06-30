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
sub constant_perl { $feedme = AA }

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
    # Alphabetically sorted, as that's how the results come out
    const_fast          => \&const_fast,        # Very fast -- fastest
    constant_perl       => \&constant_perl,     # Fast
    constant_readonly   => \&constant_readonly, # Very slow
    state_variable      => \&state_variable,    # Fast-ish
};

timethese(50_000_000, $code);

__END__

Results:
Benchmark: timing 50000000 iterations of const_fast, constant_perl, constant_readonly, state_variable...
       const_fast: 1.618   wallclock secs ( 1.62 usr +  0.00 sys =  1.62 CPU) @ 30864197.53/s (n=50000000)
    constant_perl: 1.8117  wallclock secs ( 1.81 usr +  0.00 sys =  1.81 CPU) @ 27624309.39/s (n=50000000)
constant_readonly: 39.0081 wallclock secs (39.00 usr +  0.00 sys = 39.00 CPU) @ 1282051.28/s (n=50000000)
   state_variable: 2.60289 wallclock secs ( 2.61 usr +  0.00 sys =  2.61 CPU) @ 19157088.12/s (n=50000000)
