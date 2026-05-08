#!/usr/bin/env perl

use diagnostics;
use strict;
use utf8;
use warnings;

use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share dist => 'dist';

WriteMakefile(
    NAME          => 'App::SQL-CSV-parser',
    AUTHOR        => q{user <user@host>},
    VERSION_FROM  => 'bin/sql-csv-parser',
    ABSTRACT_FROM => 'pod/sql-csv-parser.pod',
    MAN1PODS      =>
        { 'pod/sql-csv-parser.pod' => '$(INST_MAN1DIR)/sql-csv-parser.1p', },
    MAN3PODS  => {},
    EXE_FILES => [ 'bin/sql-csv-parser', ],
    PREREQ_PM => {
        'Data::Dumper'   => undef,
        'DBI'            => undef,
        'File::Basename' => undef,
        'Getopt::Long'   => undef,
    },
);

package MY;
use File::ShareDir::Install qw(postamble);

