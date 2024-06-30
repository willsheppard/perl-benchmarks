=pod

Different ways to look up a list

=cut

use strict;
use warnings;

use Benchmark ':hireswallclock';
use Readonly;
use Time::HiRes;

my @foreachloop;

use constant EE => (qw/plants objects things other_thing more_things metadata/);
sub constant_native_array { @foreachloop = EE }

use Const::Fast;
const my @FF => (qw/plants objects things other_thing more_things metadata/);
sub const_fast_array { @foreachloop = @FF }

use Readonly;
Readonly my @GG => (qw/plants objects things other_thing more_things metadata/);
sub constant_readonly_array { @foreachloop = @FF }

use feature 'state';
sub state_array_inside {
    # Horrible workaround
    # See https://stackoverflow.com/questions/6702666/why-cant-we-initialize-state-arrays-hashes-in-list-context
    #state @HH = (qw/plants objects things other_thing more_things metadata/);
    state @HH;
    state $array_is_initialized;
    if (! $array_is_initialized) {
        $array_is_initialized = 1;
        @HH = (qw/plants objects things other_thing more_things metadata/);
    }
    @foreachloop = @HH;
}

# Setup HH2
state @HH2;
state $HH2_is_initialized;
if (! $HH2_is_initialized) {
    $HH2_is_initialized = 1;
    @HH2 = (qw/plants objects things other_thing more_things metadata/);
}
sub state_array_outside {
    # Horrible workaround for the fact that you can't do list assignment initialisation of state variables
    # See https://stackoverflow.com/questions/6702666/why-cant-we-initialize-state-arrays-hashes-in-list-context
    #state @HH = (qw/plants objects things other_thing more_things metadata/);
    @foreachloop = @HH2;
}

sub state_arrayref_inside {
    state $II = [qw/plants objects things other_thing more_things metadata/];
    @foreachloop = @$II;
}

state $II2 = [qw/plants objects things other_thing more_things metadata/];
sub state_arrayref_outside {
    @foreachloop = @$II2;
}

# Sanity test for correct values. TODO: Automate this check
#state_arrayref_outside();
#print "LOOP = ".Dumper(\@foreachloop); use Data::Dumper;
#__END__

my $code = {
    constant_native_array     => \&constant_native_array,
    const_fast_array          => \&const_fast_array,
    constant_readonly_array   => \&constant_readonly_array,
    state_array_inside  => \&state_array_inside,
    state_array_outside => \&state_array_outside,
    state_arrayref_inside  => \&state_arrayref_inside,
    state_arrayref_outside => \&state_arrayref_outside,
};

timethese(20_000_000, $code);

__DATA__
const_fast_array:           15.3594 wallclock secs (15.35 usr +  0.00 sys = 15.35 CPU) @ 1302931.60/s (n=20000000)
constant_native_array:      40.9162 wallclock secs (40.91 usr +  0.00 sys = 40.91 CPU) @ 488878.02/s (n=20000000)
constant_readonly_array:    15.8882 wallclock secs (15.89 usr +  0.00 sys = 15.89 CPU) @ 1258653.24/s (n=20000000)
state_array_inside:         16.2704 wallclock secs (16.27 usr +  0.00 sys = 16.27 CPU) @ 1229256.30/s (n=20000000)
state_array_outside:        15.2003 wallclock secs (15.20 usr +  0.00 sys = 15.20 CPU) @ 1315789.47/s (n=20000000)
state_arrayref_inside:      26.1554 wallclock secs (26.15 usr +  0.00 sys = 26.15 CPU) @ 764818.36/s (n=20000000)
state_arrayref_outside:     25.4062 wallclock secs (25.39 usr +  0.02 sys = 25.41 CPU) @ 787091.70/s (n=20000000)

