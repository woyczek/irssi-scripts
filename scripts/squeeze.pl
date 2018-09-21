use strict;
use vars qw($VERSION %IRSSI);

use Irssi 20020324;
use Lingua::EN::Squeeze qw ( :ALL );

$VERSION = '0.01';
%IRSSI = (
    authors     => 'Michael Greb',
    contact     => 'michael@thegrebs.com',
    name        => 'squeeze',
    description => 'passes your text through Lingua::EN::Squeeze',
    license     => 'GPLv2',
    changed     => '20080104',
    commands	=> 'squeeze'
);

sub cmd_squeeze {
    my ($arg, $server, $witem) = @_;
    if ($witem && ($witem->{type} eq 'CHANNEL' || $witem->{type} eq 'QUERY')) {
        $witem->command('MSG ' . $witem->{name} . ' ' . SqueezeText(lc $arg) );
    }
}

Irssi::command_bind('squeeze', \&cmd_squeeze);

print "Squeeze $VERSION loaded";
