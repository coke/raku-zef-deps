#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

plan 1;

my $out = MAIN-handler-dot();

my $expected = q:to/OUT/;
JSON::Fast
    Test
Zef::Client:ver<0.19+>
    NativeCall
    Test
Zef::Config:ver<0.19+>
    NativeCall
    Test
Zef:ver<0.19+>
    NativeCall
    Test
OUT

is $out, $expected, 'META6.json dependencies';
