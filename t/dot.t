#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler-dot();

my $expected = q:to/OUT/;
JSON::Fast
    Test
Zef::Client:ver<0.14.2+>
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef::Config:ver<0.14.2+>
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
Zef:ver<0.14.2+>
    NativeCall:ver<6.c+>
    Test:ver<6.c+>
OUT

is $out, $expected, 'META6.json dependencies';
