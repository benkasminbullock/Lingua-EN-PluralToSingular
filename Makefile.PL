use ExtUtils::MakeMaker;

my $pm = 'lib/Lingua/EN/PluralToSingular.pm';
my $repo = 'https://github.com/benkasminbullock/Lingua-EN-PluralToSingular';

WriteMakefile (
    NAME => 'Lingua::EN::PluralToSingular',
    VERSION_FROM => $pm,
    ABSTRACT_FROM => $pm,
    AUTHOR => 'Ben Bullock <bkb@cpan.org>',
    LICENSE => 'perl',
    PREREQ_PM => {
    },
    EXE_FILES => [
        'scripts/singular',
    ],
    META_MERGE => {
        resources => {
            repository => $repo,
            bugtracker => "$repo/issues",
            homepage => 'http://prepan.org/module/3Yz7PYrBN8',
        }
    },
);
