unit package App::Zef-Deps;

our $indent = 4;

our sub MAIN-handler(@module, :$png) is export {
    use Zef;
    use Zef::Client;
    use Zef::Config;

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

            my $candidates = $zef.find-candidates($module).head;
            my $deps = $zef.list-dependencies($candidates).map(*.identity).cache;
            %deps{$module} = $deps;
            @queue.push: |$deps;
        }
    }

    # Dump the dependencies
    my %seen;
    sub show-deps($module, %deps, $depth=0) {
        print ' ' x $depth * $indent;
        print $module;
        if %seen{$module} {
            if %deps{$module}.elems {
                 print ' ...';
            }
            say '';
            return;
        }
        %seen{$module} = True;

        say '';
        for @(%deps{$module}).sort.unique -> $dep {
            next unless $dep;
            show-deps($dep, %deps, $depth+1);
        }
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

        say attempt-full-dot-gen(depends-tree(@uxmal-deps));
    } else {
        for @module.sort -> $module {
            show-deps($module, %deps);
        }
    }
}
