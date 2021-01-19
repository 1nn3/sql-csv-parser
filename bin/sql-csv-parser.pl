#!/usr/bin/env perl

package main;

use locale;
use diagnostics;
use strict;
use utf8;
use warnings;

use Data::Dumper;
use DBI;
use File::Basename;
use Getopt::Long qw(:config auto_version auto_help);

our $VERSION = "1.00";

binmode( STDIN,  ":encoding(UTF-8)" );
binmode( STDOUT, ":encoding(UTF-8)" );
binmode( STDERR, ":encoding(UTF-8)" );

# Read the command-line-options
my %opts;
GetOptions(
    "csv-sep-char=s"  => \$opts{csv_sep_char},
    "file=s"          => \$opts{file},
    "fsep=s"          => \$opts{fsep},
    "lsep=s"          => \$opts{lsep},
    "maxlen=i"        => \$opts{maxlen},
    "quiet"           => \$opts{quiet},
    "sql-statement=s" => \$opts{sql_statement},
    "verbose"         => \$opts{verbose},
) || exit 1;    # Error in commandline arguments
$opts{csv_sep_char} //= ",";
$opts{fsep}         //= "\t";
$opts{lsep}         //= "\n";
$opts{maxlen}       //= 256;    # 35

my $dbh;                        # database handle object

# Establish a database connection, or session.
# Use $dbh->disconnect to terminate the connection.
$dbh = DBI->connect( "dbi:CSV:", undef, undef, { RaiseError => 1, } )
  || die "Couldn't connect to database: $DBI::errstr";

# The attributes f_dir and csv_tables
if ( defined( $opts{file} ) ) {
    my ( $fn, $dirs, $suffix ) = fileparse( $opts{file} );

    $dbh->{f_dir}      = $dirs;
    $dbh->{csv_tables} = { $fn => { f_file => $fn . $suffix } };
}

# The attribute csv_sep_char
# The attribute csv_sep_char (and csv_eol, csv_quote_char and csv_escape_char)
# is corresponding to the respective attributes of the Text::CSV_XS object.
if ( defined( $opts{csv_sep_char} ) ) {
    $dbh->{csv_sep_char} = $opts{csv_sep_char};
}

my $sth;    # statement handle object

# Prepare a statement for later execution by the database engine.
$sth = $dbh->prepare( $opts{sql_statement} )
  || die "Couldn't prepare SQL-statement: $dbh->errstr";

# Perform whatever processing is necessary to execute the prepared statement.
$sth->execute
  || die "Couldn't execute SQL-statement: $sth->errstr";

# Have we a SELECT-statement?
if ( $opts{sql_statement} =~ /^\s*SELECT\s/ ) {

    # $sth->dump_results( $opts{maxlen}, $opts{lsep}, $opts{fsep}, STDOUT );

    while ( my @data = $sth->fetchrow_array() ) {

        # print STDOUT Dumper (@data);
        print STDOUT join $opts{fsep} || $dbh->{csv_sep_char} || "\t", @data;
    }
}

# Indicate that no more data will be fetched from this statement
# handle before it is either executed again or destroyed.
# You almost certainly do not need to call this method.
$sth->finish;

# Disconnect the database from the database handle.
# Calling disconnect is typically only used before exiting the program.
# The database handle is of little use after disconnecting.
$dbh->disconnect;

=pod

=head1 NAME

SQL-CSV-parser - Execute a SQL-statement on a CSV-file

=head1 SYNOPSIS

B<sql-csv-parser> --sql-statement <SQL-statment> [--file <file.csv|directory>] [--csv-sep-char <delimiter>]

sql-csv-parser --sql-statement "INSERT INTO file.csv ('colum') VALUES ('value')"

sql-csv-parser --sql-statement "UPDATE file.csv SET colum='value' WHERE colum='value'"

sql-csv-parser --sql-statement "SELECT * FROM file.csv"

=head1 OPTIONS

=over

=item --sql-statement <string>

SQL-statment.

=item --file <string>

Filename of file used for the table; Defaults to "./<table>".

=item --csv-sep-char <string>

CSV-delimiter; Defaults to ",".

=item --lsep <string>

=item --fsep <string>

=item --maxlen <integer>

The Results are dump/print to STDOUT, separated by I<--lsep> with defaults
to "\n". The option I<--fsep> defaults to "\t" and I<--maxlen> defaults
to 256.

=back

=head1 SEE ALSO

L<DBI(3pm)>, L<DBD::CSV(3pm)>

=cut

