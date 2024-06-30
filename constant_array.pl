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
sub state_variable_array {
    # Horrible workaround
    # See https://stackoverflow.com/questions/6702666/why-cant-we-initialize-state-arrays-hashes-in-list-context
    state @HH = (qw/plants objects things other_thing more_things metadata/);
    @foreachloop = @HH;
}

state_variable();
print "LOOP = ".Dumper(\@foreachloop); use Data::Dumper;

__END__

sub state_variable_arrayref {
    # Horrible workaround
    # See https://stackoverflow.com/questions/6702666/why-cant-we-initialize-state-arrays-hashes-in-list-context
    state $II = [qw/plants objects things other_thing more_things metadata/];
    @foreachloop = @$II;
}

my $code = {
    constant_native     => \&constant_native_array,
    const_fast          => \&const_fast_array,
    constant_readonly   => \&constant_readonly_array,
    state_variable      => \&state_variable,
};

timethese(20_000_000, $code);
