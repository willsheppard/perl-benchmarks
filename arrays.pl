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

# Workaround for the fact that you can't do list assignment initialisation of state variables
# See https://stackoverflow.com/questions/6702666/why-cant-we-initialize-state-arrays-hashes-in-list-context
state @HH2;
state $HH2_is_initialized;
if (! $HH2_is_initialized) {
    $HH2_is_initialized = 1;
    @HH2 = (qw/plants objects things other_thing more_things metadata/);
}
sub state_array_outside {
    @foreachloop = @HH2;
}

# This is how EPSI does it (June 2024), it is significantly slower than others
sub state_arrayref_inside {
    state $II = [qw/plants objects things other_thing more_things metadata/];
    @foreachloop = @$II;
}

state $II2 = [qw/plants objects things other_thing more_things metadata/];
sub state_arrayref_outside {
    @foreachloop = @$II2;
}

our @JJ = (qw/plants objects things other_thing more_things metadata/);
sub our_array {
    @foreachloop = @JJ;
}

our $JJ2 = [qw/plants objects things other_thing more_things metadata/];
sub our_arrayref {
    @foreachloop = @$JJ2;
}

# Sanity test for correct values. TODO: Automate this check
#our_arrayref();
#print "LOOP = ".Dumper(\@foreachloop); use Data::Dumper;
#__END__

my $code = {
    # Alphabetically sorted, as that's how the results come out
    const_fast_array        => \&const_fast_array,          # Fast
    constant_native_array   => \&constant_native_array,     # Very slow
    constant_readonly_array => \&constant_readonly_array,   # Fast
    our_array               => \&our_array,                 # Fast
    our_arrayref            => \&our_arrayref,              # Slow
    state_array_inside      => \&state_array_inside,        # Fast-ish
    state_array_outside     => \&state_array_outside,       # Fast
    state_arrayref_inside   => \&state_arrayref_inside,     # Slow
    state_arrayref_outside  => \&state_arrayref_outside,    # Slow
};

timethese(20_000_000, $code);

__END__

Results:
          const_fast_array: 15.5332 wallclock secs (15.53 usr +  0.00 sys = 15.53 CPU) @ 1287830.01/s (n=20000000)
     constant_native_array: 40.5338 wallclock secs (40.52 usr +  0.01 sys = 40.53 CPU) @ 493461.63/s (n=20000000)
   constant_readonly_array: 15.339  wallclock secs (15.33 usr +  0.00 sys = 15.33 CPU) @ 1304631.44/s (n=20000000)
                 our_array: 15.5363 wallclock secs (15.53 usr +  0.00 sys = 15.53 CPU) @ 1287830.01/s (n=20000000)
              our_arrayref: 25.3385 wallclock secs (25.33 usr +  0.00 sys = 25.33 CPU) @ 789577.58/s (n=20000000)
        state_array_inside: 16.0206 wallclock secs (16.02 usr +  0.00 sys = 16.02 CPU) @ 1248439.45/s (n=20000000)
       state_array_outside: 15.3056 wallclock secs (15.30 usr +  0.00 sys = 15.30 CPU) @ 1307189.54/s (n=20000000)
     state_arrayref_inside: 26.0376 wallclock secs (26.04 usr +  0.00 sys = 26.04 CPU) @ 768049.16/s (n=20000000)
    state_arrayref_outside: 25.4501 wallclock secs (25.42 usr +  0.03 sys = 25.45 CPU) @ 785854.62/s (n=20000000)
