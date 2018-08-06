#!/usr/bin/perl

use strict;
use Cwd 'abs_path';

$ENV{HARNESS_ACTIVE} = 1 if scalar @ARGV && shift eq '-tap';
$ENV{TOP} = abs_path($ENV{TOP}) if exists $ENV{TOP};
system('./recGblCheckDeadbandTest.exe') == 0 or die "Can't run recGblCheckDeadbandTest.exe: $!\n";
