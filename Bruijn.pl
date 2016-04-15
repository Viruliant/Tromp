#!/usr/bin/env perl
use Time::HiRes qw( usleep gettimeofday tv_interval stat time alarm sleep );
#use strict;
use warnings;
use IO::File;
use Cwd; my $originalCwd = getcwd()."/";
#primes.blc as argument for test conversion
#______________________________________________________________________open file
my ($name) = @ARGV;
$FILE = new IO::File;
#$FILE->open("< ".$originalCwd."unparsed.txt") || die("Could not open file!");
$FILE->open("< ".$name) || die("Could not open file!");
while (<$FILE>){ $field .= $_; }
$FILE->close;
#______________________________________________________________________Translate
$field =~ s/(00|01|(1+0))/$1 /gsm;
$field =~ s/00 /\\ /gsm;
$field =~ s/01 /(a /gsm;
$field =~ s/(1+)0 /length($1)." "/gsme;

#$RecursiveRegex = qr/([ |\\]*((\((?:RecursiveRegex)\))|\d+)[ |\\]*){2}/
#$field =~  s/\(a${RecursiveRegex}/\(${RecursiveRegex}\)/gsme;
#______________________________________________________________________save file
$fh = new IO::File "> ".$name;
#$fh = new IO::File "> ".$originalCwd."parsed.txt";
if (defined $fh) { print $fh $field; $fh->close; }
