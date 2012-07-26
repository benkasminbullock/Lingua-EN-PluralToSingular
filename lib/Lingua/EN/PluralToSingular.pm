package Lingua::EN::PluralToSingular;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/to_singular/;
use warnings;
use strict;
our $VERSION = 0.03;

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
    'lives' => 'life',
);

# A dictionary of plurals.

my %plural = (
    # Words ending in "us" which are plural, in contrast to words like
    # "citrus" or "bogus".
    'menus' => 'menu',
    %ves,
    %irregular,
);

# A store of words which are the same in both singular and plural.

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

# A store of words which look like plurals but are not.

my @not_plural = (qw/
    citrus
    Charles
    bogus
    octopus
/);

my %not_plural;

@not_plural{@not_plural} = (1) x @not_plural;

# A store of words which end in "oe" and whose plural ends in "oes".

my @oes = (qw/
                 toes
                 hoes
             /);

my %oes;

@oes{@oes} = (1) x @oes;

# A store of words which end in "ie" and whose plural ends in "ies".

my @ies = (qw/
                 lies
             /);

my %ies;

@ies{@ies} = (1) x @ies;

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
            if ($word =~ /ies$/) {
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
            elsif ($word =~ /oes/) {
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

=head1 ROUTINES

=head2 to_singular

    my $singular = to_singular ($word);

Convert C<$word> into its singular form. For example,

    to_singular ('cats')

returns 'cat'. If the word is unknown or does not seem to be
plural, C<to_singular> returns the word itself, so

    to_singular ('battlehorn');

returns 'battlehorn'.

=head3 Limitations

It assumes its input is a noun. For example, "lives" may be the plural
of "life", or the verb "live", as in "he lives". The routine assumes a
noun and converts to "life".

It does not deal with capitalized words. If the input word may be
capitalized, or if its initial letter may be capitalized, the user
must preprocess it to put it into the normal case. So, for example,

    to_singular ('FLIES');

returns 'FLIES' and

    to_singular ('Wolves');

returns 'Wolve'.

=head1 AUTHOR

Ben Bullock <bkb@cpan.org>

=head1 COPYRIGHT & LICENCE

Copyright (C) 2011 Ben Bullock.

This Perl module may be used, copied, altered and redistributed under
the same terms as the Perl language itself.

