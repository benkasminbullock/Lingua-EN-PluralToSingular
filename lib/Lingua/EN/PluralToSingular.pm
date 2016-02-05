package Lingua::EN::PluralToSingular;
use warnings;
use strict;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/to_singular is_plural/;
our $VERSION = '0.17';

# Irregular plurals.

# References:
# http://www.macmillandictionary.com/thesaurus-category/british/Irregular-plurals
# http://web2.uvcs.uvic.ca/elc/studyzone/330/grammar/irrplu.htm
# http://www.scribd.com/doc/3271143/List-of-100-Irregular-Plural-Nouns-in-English

# This mixes latin/greek plurals and anglo-saxon together. It may be
# desirable to split things like corpora and genera from "feet" and
# "geese" at some point.

my %irregular = (qw/
    analyses analysis
    brethren brother
    children child
    corpora corpus
    craftsmen craftsman
    crises crisis
    criteria criterion
    curricula curriculum
    feet foot
    fungi fungus
    geese goose
    genera genus
    indices index
    lice louse
    matrices matrix
    memoranda memorandum
    men man
    mice mouse
    monies money
    neuroses neurosis
    nuclei nucleus
    oases oasis
    oxen ox
    pence penny
    people person
    phenomena phenomenon
    quanta quantum
    strata stratum
    teeth tooth
    testes testis
    these this
    theses thesis
    those that
    women woman
/);

# Words ending in ves need care, since the ves may become "f" or "fe".

# References:
# http://www.macmillandictionary.com/thesaurus-category/british/Irregular-plurals

my %ves = (qw/
    calves calf
    dwarves dwarf
    elves elf
    halves half
    knives knife
    leaves leaf
    lives life
    loaves loaf
    scarves scarf
    sheaves sheaf
    shelves shelf
    wharves wharf 
    wives wife
    wolves wolf
/);

# A dictionary of plurals.

my %plural = (
    # Words ending in "us" which are plural, in contrast to words like
    # "citrus" or "bogus".
    'menus' => 'menu',
    'buses' => 'bus',
    %ves,
    %irregular,
);

# A store of words which are the same in both singular and plural.

my @no_change = qw/
                      deer
                      ides
                      fish
                      means
                      offspring
                      series
                      sheep
                      species
                  /;

@plural{@no_change} = @no_change;

# A store of words which look like plurals but are not.

# References:

# http://wiki.answers.com/Q/What_are_some_examples_of_singular_nouns_ending_in_S
# http://virtuallinguist.typepad.com/the_virtual_linguist/2009/10/singular-nouns-ending-in-s.html

my @not_plural = (qw/
Aries
Charles
Gonzales 
Hades 
Hercules 
Hermes 
Holmes 
Hughes 
Ives 
Jacques 
James 
Keyes 
Mercedes 
Naples 
Oates 
Raines 
Texas
athletics
bogus
bus
cactus
cannabis
caries
chaos
citrus
clothes
corps
corpus
devious
dias
facies
famous
hippopotamus
homunculus
iris
lens
mathematics
metaphysics
metropolis
mews
minus
miscellaneous
molasses
mrs
narcissus
news
octopus
ourselves
papyrus
perhaps
physics
platypus
plus
previous
pus
rabies
scabies
sometimes
stylus
themselves
this
thus
various
yes
/);

my %not_plural;

@not_plural{@not_plural} = (1) x @not_plural;

# A store of words which end in "oe" and whose plural ends in "oes".

# References
# http://www.scrabblefinder.com/ends-with/oe/

# Also used

# perl -n -e 'print if /oe$/' < /usr/share/dict/words

my @oes = (qw/
canoes
does
foes
gumshoes
hoes
horseshoes
oboes
shoes
snowshoes
throes
toes
/);

my %oes;

@oes{@oes} = (1) x @oes;

# A store of words which end in "ie" and whose plural ends in "ies".

# References:
# http://www.scrabblefinder.com/ends-with/ie/
# (most of the words are invalid, the above list was manually searched
# for useful words).

# Also get a good list using

# perl -n -e 'print if /ie$/' < /usr/share/dict/words 

# There are too many obscure words there though.

# Also, I'm deliberately not including "Bernie" and "Bessie" since the
# plurals are rare I think. 

my @ies = (qw/
Aussies
Valkryies
aunties
bogies
brownies
calories
charlies
coolies
coteries
curies
cuties
dies
genies
goalies
kilocalories
lies
magpies
menagerie
movies
neckties
pies
porkpies
prairies
quickies
reveries
rookies
sorties
stogies
talkies
ties
zombies
/);

my %ies;

@ies{@ies} = (1) x @ies;

# Words which end in -se, so that we want the singular to change from
# -ses to -se.

my @ses = (qw/
horses
tenses
/);

my %ses;
@ses{@ses} = (1) x @ses;

# A regular expression which matches the end of words like "dishes"
# and "sandwiches". $1 is a capture which contains the part of the
# word which should be kept in a substitution.

my $es_re = qr/([^aeiou]s|ch|sh)es$/;

# See documentation below.

sub to_singular
{
    my ($word) = @_;
    # The return value.
    my $singular = $word;
    if (! $not_plural{$word}) {
        # The word is not in the list of exceptions.
        if ($plural{$word}) {
            # The word has an irregular plural, like "children", or
            # "geese", so look up the singular in the table.
            $singular = $plural{$word};
        }
        elsif ($word =~ /s$/) {
            # The word ends in "s".
            if ($word =~ /'s$/) {
            # report's, etc.
            ;
            }
            elsif (length ($word) <= 2) {
            # is, as, letter s, etc.
            ;
            }
            elsif ($word =~ /ss$/) {
            # useless, etc.
            ;
            }
            elsif ($word =~ /sis$/) {
            # basis, dialysis etc.
            ;
            }
            elsif ($word =~ /ies$/) {
                # The word ends in "ies".
                if ($ies{$word}) {
                    # Lies -> lie
                    $singular =~ s/ies$/ie/;
                }
                else {
                    # Fries -> fry
                    $singular =~ s/ies$/y/;
                }
            }
            elsif ($word =~ /oes$/) {
                # The word ends in "oes".
                if ($oes{$word}) {
                    # Toes -> toe
                    $singular =~ s/oes$/oe/;
                }
                else {
                    # Potatoes -> potato
                    $singular =~ s/oes$/o/;
                }
            }
            elsif ($word =~ /xes$/) {
                # The word ends in "xes".
		        $singular =~ s/xes$/x/;
            }
            elsif ($word =~ /ses$/) {
                if ($ses{$word}) {
                    $singular =~ s/ses$/se/;
                }
                else {
                    $singular =~ s/ses$/s/;
                }
	        }
            elsif ($word =~ $es_re) {
                # Sandwiches -> sandwich
                # Dishes -> dish
                $singular =~ s/$es_re/$1/;
            }
            else {
                # Now the program has checked for every exception it
                # can think of, so it assumes that it is OK to remove
                # the "s" from the end of the word.
                $singular =~ s/s$//;
            }
        }
    }            
    return $singular;
}

sub is_plural
{
    my ($word) = @_;
    my $singular = to_singular ($word);
    my $is_plural;
    if ($singular ne $word) {
	    $is_plural = 1;
    }
    elsif ($plural{$singular} && $plural{$singular} eq $singular) {
	    $is_plural = 1;
    }
    else {
	    $is_plural = 0;
    }
    return $is_plural;
}

1;
