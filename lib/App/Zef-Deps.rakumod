unit package App::Zef-Deps;

our $lock = Lock.new;
our $batch = 1;
our $indent = 4;

our sub MAIN-handler(@module, :$graph, :$v) is export {

    $*OUT.out-buffer = False;

    run(<zef --help>, :out, :err) or die "Can't find zef; is your PATH correct?";

    my %deps;
    my %installed;

    my @queue = @module;

    loop {
        last unless @queue;
        my @copy = @queue.unique;
        @queue = Array.new;
        my %output;
        @copy.race(:$batch).map: -> $module {
            next if %deps{$module}:exists;

            say "# PACKAGE: $module";
            react {
                my $proc = Proc::Async.new: ['zef', 'info', '--verbose', $module];

                whenever $proc.stdout.lines {
                    $lock.protect: {
                        %output{$module} ~= "$_\n";
                    }
                }
                whenever $proc.start {
                    done
                }
            }
        }

        for %output.kv -> $module, $data {
            my $depends = False;
            %deps{$module} = Array.new;
            for $data.lines -> $line {
                say "# $module|$line" if $v or $line.starts-with('!');
                $depends = True if $line.starts-with('Depends: ');
                next unless $depends;
                next unless $line ~~ /^ \d /;

                my @chunks = $line.split('|');
                die "oops, I missed some zef format" unless @chunks.elems == 3;

                my $dep = @chunks[1].trim;
                my $installed = @chunks[2].trim;
                %deps{$module}.push: $dep;
                %installed{$module} = $installed;
                @queue.push: $dep unless %deps{$dep}:exists;
            }
        }
    }

    # Dump the dependencies
    my %seen;
    sub show-deps($module, %deps, $depth=0) {
        print ' ' x $depth * $indent;
        print $module;
        print ' ';
        print %installed{$module} // '';
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

    if $graph {
        # Can we load module at runtime at all?
        if (try require Uxmal) === Nil {
            say "Unable to load optional module 'Uxmal', please install with zef to use this feature.";
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
