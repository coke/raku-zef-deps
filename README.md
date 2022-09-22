# Overview

`zef-deps` is a script to report on module dependencies for raku.

Given a list of package names on the command line, generate a listing of all
dependencies, direct and indirect.

# Usage

```
% zef-deps App::Cal
App::Cal
    Terminal::ANSIColor
    Test::Differences
        Data::Dump
        Text::Diff
            Algorithm::Diff
                Test
            Test
            Text::Tabs
```

The indent level shows the nesting of dependencies. So in this example, `App::Cal` depends
on `Test::Differences`, which in turn depends on `Data::Dump`.  Both `Algorithm::Diff` and
`Text::Diff` depend on `Test`.

Multiple packages can be specified on the command line.

If a single name of `.` is specified, `zef-deps` will instead read the local
`META6.json` and use the `depends` attribute as the list of packages.

# Options

`--png` generates a `png` file showing dependencies using `dot`. To use this option,
you must install the optional module `Uxmal`. When run with this option, a file is generated in a temp
directory and the path to the file is printed as the only non-debug output.

# Environment variables

## ZEF_DEPS_INDENT

Indenting defaults to 4 spaces but can be overridden via this environment variable.
