#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use strict;

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
    my ($window_number) = shift;
    my $window = Irssi::window_find_refnum($window_number);
    $window->print( Irssi::settings_get_str('rehilight_text'),
        , MSGLEVEL_HILIGHT );
}

Irssi::settings_add_str( $IRSSI{'name'}, 'rehilight_text', 'rehilighted' );

Irssi::command_bind( 'rehilight', \&rehilight );


1;