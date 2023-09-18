#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler(['Zef::Client', 'Zef::Config']);

my $expected = q:to/OUT/;
Zef::Client
    NativeCall
    Test
Zef::Config
    NativeCall
    Test
OUT

is $out, $expected, 'Zef:C... dependencies';
