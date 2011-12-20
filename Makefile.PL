use strict;
use warnings;
use ExtUtils::MakeMaker;

my $pm = 'lib/Lingua/EN/PluralToSingular.pm';

WriteMakefile (
    NAME => 'Lingua::EN::PluralToSingular',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
    },
);
