#!/usr/bin/env raku

use Test;
use App::Zef-Deps;

if (try require Uxmal) === Nil {
    plan :skip-all<Optional module needed for this feature not installed.>;
} else {
    plan 2;
}

my $out = MAIN-handler(['zef',], :png);

nok $out.contains("\n"), "single line of text";
ok $out.ends-with('.png'), "that looks like a PNG";
