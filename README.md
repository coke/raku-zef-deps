# Overview

`zef-deps` is a script to report on module dependencies for raku.

Given a list of names on the command line, generate a listing of all
dependencies, direct and indirect.

# Usage

```
% zef-deps App::Cal
# PACKAGE: App::Cal
# PACKAGE: Terminal::ANSIColor
# PACKAGE: Test::Differences
# PACKAGE: Data::Dump
# PACKAGE: Text::Diff
# PACKAGE: Algorithm::Diff
# PACKAGE: Text::Tabs
# PACKAGE: Test
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

Any lines appearing with a leading `#` are diagnostic, to show progress is occurring.

The indent level shows the nesting of dependencies. So in this example, App::Cal depends
on Test::Differences, which in turn depends on Data::Dump.  Both Algorithm::Diff and
Text::Diff depend on Test.

Multiple packages can be specified on the command line.

# Options

`-graph` generates a PNG via `dot`. To use this option, you must install the optional
module `Uxmal` using zef. When run with this option, a file is generated in a temp
directory and the path to the file is printed as the only non-debug output.
