unit package App::Zef-Deps;

our $indent = 4;

our sub MAIN-handler-dot(:$png, :$json) is export {
    use JSON::Fast;
    my @depends = |(from-json "META6.json".IO.slurp)<depends>;
    MAIN-handler(@depends, :$png, :$json);
}

our sub MAIN-handler(@module, :$png, :$json) is export {
    use Zef;
    use Zef::Client;
    use Zef::Config;

    if %*ENV<ZEF_DEPS_INDENT> {
        $indent = %*ENV<ZEF_DEPS_INDENT>.Int;
    }

    $*ERR.out-buffer = False;

    my $chosen-config-file = %*ENV<ZEF_CONFIG_PATH> // Zef::Config::guess-path();
    my $config = Zef::Config::parse-file($chosen-config-file);

    my $zef = Zef::Client.new(:$config);

    my %deps;
    my @queue = @module;

    loop {
        last unless @queue;
        my @copy = @queue.unique;
        @queue = Array.new;
        for @copy -> $module {
            next if %deps{$module}:exists;

            # One of the dependencies may be a native library that
            # zef can't report on
            my $candidates = try $zef.find-candidates($module).head;
            next unless $candidates;

            my $deps = $zef.list-dependencies($candidates).map(*.identity).cache;
            %deps{$module} = $deps;
            @queue.push: |$deps;
        }
    }

    # Dump the dependencies
    my %seen;
    sub show-deps($module, %deps, $depth=0) {
        my $output = '';
        $output ~= ' ' x $depth * $indent;
        $output ~= $module;
        if %seen{$module} {
            if %deps{$module}.elems {
                 $output ~= " ...\n";
            }
            $output ~= "\n";
            return $output;
        }
        %seen{$module} = True;

        $output ~= "\n";
        for @(%deps{$module}).sort.unique -> $dep {
            next unless $dep;
            $output ~= show-deps($dep, %deps, $depth+1);
        }
        return $output
    }

    # Extract data suitable for JSON dump
    sub model-for-json($module, %deps) {
        # Get hash of attributes of module using zef
        # Skip blank attributes and from eq "Perl6"
        use Zef::Identity;
        my %obj = identity2hash($module).hash.pairs.grep(*.value.chars);
        %obj<from>:delete if %obj<from> eq "Perl6";
        for @(%deps{$module}).sort.unique -> $dep {
            next unless $dep;
            %obj<deps>.push: model-for-json($dep, %deps);
        }
        return %obj;
    }

    if $png {
        # Can we load module at runtime at all?
        if (try require Uxmal) === Nil {
            say "Unable to load optional module 'Uxmal', please install it to use this feature.";
            exit 1;
        }

        # ... If so, load the subs we need
        require Uxmal <&attempt-full-dot-gen &depends-tree>;

        my @uxmal-deps;
        for %deps.kv -> $k, $v {
            @uxmal-deps.push: { :name($k), :depends($v) };
        }

        return attempt-full-dot-gen(depends-tree(@uxmal-deps));
    } elsif $json {
        use JSON::Fast;
        my @deps;
        @deps.push: model-for-json($_, %deps) for @module;
        return to-json @deps, :pretty, :sorted-keys;
    } else {
        my $output = '';
        for @module.sort -> $module {
            $output ~= show-deps($module, %deps);
        }
        return $output;
    }
}
