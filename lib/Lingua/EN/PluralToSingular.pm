package Lingua::EN::PluralToSingular;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/to_singular/;
use warnings;
use strict;
our $VERSION = 0.01;

# Irregular plurals.

my %irregular = (
    'women' => 'woman',
    'mice' => 'mouse',
    'men' => 'man',
    'children' => 'child',
    'geese' => 'goose',
    'feet' => 'foot',
    'teeth' => 'tooth',
    'lice' => 'louse',
);

# Words ending in ves need care, since the ves may become "f" or "fe".

my %ves = (
    'wolves' => 'wolf',
    'knives' => 'knife',
);

# A dictionary of plurals.

my %plural = (
    # Words ending in "us" which are plural, in contrast to words like
    # "citrus" or "bogus".
    'menus' => 'menu',
    %ves,
    %irregular,
);


# Words which are the same in both singular and plural.

my @no_change = qw/
deer
fish
means
offspring
series
sheep
species
/;

@plural{@no_change} = @no_change;

# Store of words which look like plurals but are not.

my @not_plural = (qw/
    citrus
    Charles
    bogus
/);

my %not_plural;

@not_plural{@not_plural} = (1) x @not_plural;

# Store of words which end in oe and whose plural ends in oes.

my @oes = (qw/
                 toe
                 hoe
             /);

my %oes;

@oes{@oes} = (1) x @oes;

# Store of words which end in ie and whose plural ends in ies.

my @ies = (qw/
                 lie
             /);

my %ies;

@ies{@ies} = (1) x @ies;

# A regular expression which matches the end of words like "dishes"
# and "sandwiches". $1 is a capture which contains the part of the
# word which should be kept in a substitution.

my $es_re = qr/(ch|sh)es$/;

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
            if ($word =~ /ies$/) {
                # The word ends in "ies".
                if ($ies{"${word}s"}) {
                    # Lies -> lie
                    $singular =~ s/ies$/ie/;
                }
                else {
                    # Fries -> fry
                    $singular =~ s/ies$/y/;
                }
            }
            elsif ($word =~ /oes/) {
                # The word ends in "oes".
                if ($oes{"${word}s"}) {
                    # Toes -> toe
                    $singular =~ s/oes$/oe/;
                }
                else {
                    # Potatoes -> potato
                    $singular =~ s/oes$/o/;
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


__END__

=head1 NAME

Lingua::EN::PluralToSingular - change an English plural to a singular

=head1 SYNOPSIS

    use Lingua::EN::PluralToSingular 'to_singular';

    print to_singular ('knives');
    # "knife"

=head1 DESCRIPTION

This Perl module converts words denoting a plural in the English
language into words denoting a singular noun.

=head1 METHODS

=head2 to_singular

    my $singular = to_singular ($word);

Convert C<$word> into its singular form. For example,

    to_singular ('cats')

returns 'cat'. If the word is unknown or does not seem to be
plural, C<to_singular> returns the word itself, so

    to_singular ('battlehorn');

returns 'battlehorn'.

=head1 AUTHOR

Ben Bullock <bkb@cpan.org>

=head1 COPYRIGHT & LICENCE

Copyright (C) 2011 Ben Bullock.

This Perl module may be used, copied, altered and redistributed under
the same terms as the Perl language itself.

