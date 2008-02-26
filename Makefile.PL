use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Geo::Integer',
    VERSION_FROM => 'lib/Geo/Integer.pm',
    AUTHOR       => 'Michael R. Davis (account=>perl,tld=>com,domain=>michaelrdavis)',
    ABSTRACT     => 'Generates a single integer from Lat and Lon coordinates',
    PREREQ_PM    => {
                     'Test::More' => 0.44,
                     'strict'     => 0,
                    },
);
