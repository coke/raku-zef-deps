#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler(['Zef::Client', 'Zef::Config']);

my $expected = q:to/OUT/;
Zef::Client
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef::Config
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

is $out, $expected, 'Zef:C... dependencies';
