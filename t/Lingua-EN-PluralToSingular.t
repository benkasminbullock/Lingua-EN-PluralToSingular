use warnings;
use strict;
use Test::More;
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
dishes dish
misses miss
report's report's
/; 

for my $word (sort keys %words) { 
    my $s = to_singular ($word); 
    is ($s, $words{$word}, "$s == $words{$word}"); 
} 

my %bugs = (qw/
/);

TODO: {
    local $TODO = 'bugs';
    for my $word (sort keys %bugs) { 
        my $s = to_singular ($word); 
        is ($s, $bugs{$word}, "$s == $bugs{$word}"); 
    } 
};

done_testing ();

# Local variables:
# mode: perl
# End:
