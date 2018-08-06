#!/usr/bin/perl

use strict;
use Cwd 'abs_path';

$ENV{HARNESS_ACTIVE} = 1 if scalar @ARGV && shift eq '-tap';
$ENV{TOP} = abs_path($ENV{TOP}) if exists $ENV{TOP};
system('./epicsThreadPrivateTest.exe') == 0 or die "Can't run epicsThreadPrivateTest.exe: $!\n";
