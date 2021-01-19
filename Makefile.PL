#!/usr/bin/env perl

use diagnostics;
use strict;
use utf8;
use warnings;

use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share dist => 'dist';

WriteMakefile(
    NAME         => 'App::SQL-CSV-parser',
    VERSION_FROM => 'bin/sql-csv-parser.pl',
    AUTHOR       => q{nobody <nobody>},
    MAN1PODS     => {
        'bin/sql-csv-parser.pl' => '$(INST_MAN1DIR)/sql-csv-parser.1p',
    },
    MAN3PODS => {},
    PM       => {
        'bin/sql-csv-parser.pl' => '$(INST_BIN)/sql-csv-parser',
    },
    PREREQ_PM => {
        'Data::Dumper'   => undef,
        'DBI'            => undef,
        'File::Basename' => undef,
        'Getopt::Long'   => undef,
    },
);

package MY;
use File::ShareDir::Install qw(postamble);

