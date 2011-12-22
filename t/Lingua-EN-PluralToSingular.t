use warnings;
use strict;
use Test::More tests => 10;
BEGIN { use_ok('Lingua::EN::PluralToSingular', 'to_singular') };

my %words = qw/ 
bogus bogus 
citrus citrus 
menus menu 
species species 
flies fly 
monkeys monkey 
children child 
women woman 
mice mouse 
/; 

for my $word (sort keys %words) { 
    my $s = to_singular ($word); 
    ok ($s eq $words{$word}, "$s == $words{$word}"); 
} 

# Local variables:
# mode: perl
# End:
