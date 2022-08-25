use as-cli-arguments:ver<0.0.4>:auth<zef:lizmat>;

my sub meh($message) { exit note $message }

sub EXPORT(&target) {
    die "Target &{&target.name} must be a multi"
      unless &target.is_dispatcher;

    my @sub-commands = &target.candidates.map({
        if .signature.params -> @params {
            my $sub-command := @params.head;
            $sub-command.constraint_list.head
              if !$sub-command.name
              && !$sub-command.named
              &&  $sub-command.type ~~ Str | Numeric
              &&  $sub-command.constraint_list == 1
        }
    }).sort.List;

    &target.add_dispatchee: my sub (Str:D $command, |c) is hidden-from-USAGE {
        meh("Must specify a sub-commmand") unless $command;

        my @matches = @sub-commands.grep: -> $sub-command {
            $sub-command.starts-with($command)
        }
        if @matches == 1 {
            with $*RECURSIVE-SHORT-SUB-COMMAND -> $from {
                my $params := as-cli-arguments c;
                $params    := " $params" if $params;
                meh $command eq $from
                  ?? "'$from$params' recurses"
                  !! "'$from$params' recurses into '$command'";
            }
            else {
                my $*RECURSIVE-SHORT-SUB-COMMAND := $command;
                target(@matches[0], |c);
            }
        }
        else {
            @matches
              ?? meh("'$command' is ambiguous, matches: @matches[]")
              !! meh("'$command' is not recognized as sub-command:
Known sub-commands: @sub-commands[]")
        }
    }

    Map.new
}

=begin pod

=head1 NAME

shorten-sub-commands - allow partial specification of sub-commands

=head1 SYNOPSIS

=begin code :lang<raku>

# in script "frobnicate"
multi sub MAIN("foozle")  { say "foozle"  }
multi sub MAIN("barabas") { say "barabas" }
multi sub MAIN("bazzie")  { say "bazzie"  }
use shorten::sub::commands &MAIN;

    $ raku frobnicate foo
    foozle
    $ raku frobnicate ba
    'ba' is ambiguous, matches: barabas bazzie
    $ raku frobnicate bar
    barabas

=end code

=head1 DESCRIPTION

shorten::sub::commands is a helper module intended to be used for command-line
application that have a sub-command structure (in which the first positional
parameter indicates what needs to be done, and there is a separate candidate
to handle execution of that command).

When used B<after> all C<MAIN> candidates have been defined, it will add
another candidate that will allow to shorten the command names to be as
short as possible (e.g. just "foo" in the example above, or even just "f"
as there is only one candidate that starts with "f".  Numeric subcommands
are also supported, but they will be matched as strings (so C<4> on the
command line will match C<42> in the signature).

Special care has been taken to ensure that re-dispatch doesn't devolve into
an infinite loop.

=head1 AUTHOR

Elizabeth Mattijsen <liz@raku.rocks>

Source can be located at: https://github.com/lizmat/shorten-sub-commands .
Comments and Pull Requests are welcome.

=head1 COPYRIGHT AND LICENSE

Copyright 2022 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
