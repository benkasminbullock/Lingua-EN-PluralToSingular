use warnings;
use strict;
use Test::More tests => 17;
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
toes toe
potatoes potato
lies lie
flies fly
wolves wolf
knives knife
lives life
geese goose
/; 

for my $word (sort keys %words) { 
    my $s = to_singular ($word); 
    ok ($s eq $words{$word}, "$s == $words{$word}"); 
} 

# Local variables:
# mode: perl
# End:
