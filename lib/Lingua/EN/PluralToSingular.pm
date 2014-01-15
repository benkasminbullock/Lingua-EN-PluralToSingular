package Lingua::EN::PluralToSingular;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/to_singular/;
use warnings;
use strict;
our $VERSION = '0.12';

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
    children child
    corpora corpus
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
    craftsmen craftsman
    men man
    mice mouse
    monies money
    neuroses neurosis
    nuclei nucleus
    oases oasis
    pence penny
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
                      clothes
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
    Charles
    Texas
Hades 
Hercules 
Hermes 
Gonzales 
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

    dias
    iris
    molasses
    this
    yes
    chaos
    lens
    corps
    mews
    news

    athletics
    mathematics
    physics
    metaphysics


    bogus
    bus
    cactus
    citrus
    corpus
    hippopotamus
    homunculus
    minus
    narcissus
    octopus
    papyrus
    platypus
    plus
    pus
    stylus
    various
    previous
    devious
    metropolis
    miscellaneous
    perhaps
    thus
    famous
    mrs
sometimes

ourselves
themselves

/);

my %not_plural;

@not_plural{@not_plural} = (1) x @not_plural;

# A store of words which end in "oe" and whose plural ends in "oes".

# References
# http://www.scrabblefinder.com/ends-with/oe/

my @oes = (qw/
		 foes
		 shoes
                 hoes
		 throes
                 toes
		 oboes
             /);

my %oes;

@oes{@oes} = (1) x @oes;

# A store of words which end in "ie" and whose plural ends in "ies".

# References:
# http://www.scrabblefinder.com/ends-with/ie/
# (most of the words are invalid, the above list was manually searched
# for useful words).

my @ies = (qw/
calories
genies
lies
movies
neckties
pies
ties
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

1;

