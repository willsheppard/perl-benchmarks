=pod

This module seems the most up-to-date
and advanced, but I don't fully understand
the reports

=cut

use Dumbbench;
 
# Setup
my $bench = Dumbbench->new(
  target_rel_precision => 0.005, # seek ~0.5%
  initial_runs         => 20,    # the higher the more reliable
);
my $iterations = 10000;

# Functions to compare
my $factorial = sub {
    for (1 .. $iterations) {
	my $n = 1000;
	my $f = 1;
	my $i = 1;
	$f *= ++$i while $i < $n;
	#print "$n! = $f\n";
    }
};


# Run
$bench->add_instances(
    #Dumbbench::Instance::Cmd->new(command => [qw(perl -e 'something')]),
    #Dumbbench::Instance::PerlEval->new(code => 'for(1..1e7){something}'),
  Dumbbench::Instance::PerlSub->new(code => $factorial),
);
# (Note: Comparing the run of externals commands with
#  evals/subs probably isn't reliable)
$bench->run;
$bench->report;
#eval { $bench->box_plot->show; }

