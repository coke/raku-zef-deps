#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler(['zef',]);

my $expected = q:to/OUT/;
zef
    NativeCall
    Test
OUT

is $out, $expected, 'zef dependencies';
