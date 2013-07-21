#!/usr/bin/perl

use 5.010;
use strict;
use warnings;

use Irssi;

our $VERSION = '0.1';
our %IRSSI   = (
    authors     => 'Michael Greb',
    contact     => 'michael@thegrebs.com mikegrb @ irc.(perl|oftc).net',
    name        => 'rehilight',
    description => 'rehilight a query/other window by number',
    license     => 'BSD',
);

sub rehilight {
    my $target = shift;
    $target =~ s/\s+$//;

    my $window
        = $target =~ m/^\d+$/
        ? Irssi::window_find_refnum($target)
        : Irssi::window_find_item($target);

    $window->activity(4) if $window;
}

Irssi::command_bind( 'rehilight', \&rehilight );

1;
