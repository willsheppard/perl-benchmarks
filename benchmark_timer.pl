# Non-statistical usage
use Benchmark::Timer;
$t = Benchmark::Timer->new(skip => 1);

use constant AAA => 111;

use Const::Fast;
const my $BBB => 222;

use Readonly;
Readonly my $CCC => 333;

my $temp;
for (1 .. 10000) {
    $t->start('tag');
    $temp = AAA ** 100000000;
    print "$temp\n";
    $t->stop('tag');
}
print $t->report;

__END__

# --------------------------------------------------------------------
 
# Statistical usage
use Benchmark::Timer;
$t = Benchmark::Timer->new(skip => 1, confidence => 97.5, error => 2);
 
while($t->need_more_samples('tag')) {
    $t->start('tag');
    &long_running_operation();
    $t->stop('tag');
}
print $t->report;
