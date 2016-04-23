#!/usr/bin/env perl
use Time::HiRes qw( usleep gettimeofday tv_interval stat time alarm sleep );
#use strict;
use warnings;
use IO::File;
use Cwd; my $originalCwd = getcwd()."/";
#______________________________________________________________________open file
my ($FName) = @ARGV;
$FILE = new IO::File;$FILE->open("< ".$FName) || die("Could not open file!");
while (<$FILE>){ $field .= $_; } $FILE->close;
#______________________________________________________________________Translate
$field =~ s/(00|01|(1+0))/$1 /gsm;
$field =~ s/00 /\\ /gsm;
$field =~ s/01 /(a /gsm;
$field =~ s/(1+)0 /length($1)." "/gsme;

1 while $field =~ s/(\(a)(([\s\\]*?(?:\d+|(?&RecursParens))){2})(?(DEFINE)(?<RecursParens>(?>\((?>(?>[^()]+)|(?:(?=.)(?&RecursParens)|))+\))))/\($2\)/gsm;
$field =~ s/\( /\(/gsm;
#______________________________________________________________________save file
$fh = new IO::File "> ".$FName.".txt";
if (defined $fh) { print $fh $field; $fh->close; }
