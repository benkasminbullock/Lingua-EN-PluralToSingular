=head1 NAME

Lingua::EN::PluralToSingular - change an English plural to a singular

=head1 SYNOPSIS

    use Lingua::EN::PluralToSingular 'to_singular';

    print to_singular ('knives');
    # "knife"

=cut
package Lingua::EN::PluralToSingular;
require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw/to_singular/;
use warnings;
use strict;
our $VERSION = 0.01;

my %plural = (

# us which are plural
'menus' => 'menu',
);

my %not_plural = (

);

1;

__END__

=head1 AUTHOR

Ben Bullock <bkb@cpan.org>

=head1 COPYRIGHT & LICENCE

Copyright (C) 2011 Ben Bullock.

This Perl module may be used, copied, altered and redistributed under
the same terms as the Perl language itself.

