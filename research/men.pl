#!/home/ben/software/install/bin/perl
use warnings;
use strict;
my $dic = '/home/ben/projects/pron-dic-db/spellings.txt';
my @words;
my @men = qw/
abdomen
acumen
afikomen
agnomen
albumen
amen
armen
benjimen
berumen
bitumen
bremen
brisingamen
catechumen
cerumen
clamen
cormen
dahmen
daimen
dammen
dohmen
dolmen
duramen
ehmen
emmen
energumen
examen
gravamen
hegumen
hinmen
holmen
homen
hsiamen
kamen
kelemen
kilolumen
lemen
lemmen
limen
lommen
lumen
mammen
meskimen
newcomen
numen
omen
ommen
praenomen
prenomen
putamen
pyrobitumen
ramen
regimen
rumen
semen
stemen
strommen
tammen
tegmen
thommen
tiananmen
tienanmen
tyumen
uelmen
velamen
vercammen
vesmen
vimen
xiamen
yamen
yemen
/;

my %men;
@men{@men} = @men;
open my $in, "<", $dic or die $!;
while (<$in>) {
    my ($word) = split /\s+/, $_;
    if ($word =~ /men$/) {
	if ($men{$word}) {
	    next;
	}
	my $man = $word;
	$man =~ s/men$/man/;
	print "$word $man\n";
    }
}
close $in or die $!;
