# automatically rejoin to channel after kicked

# /SET autorejoin_channels #channel1 #channel2 ...

# NOTE: I personally don't like this feature, in most channels I'm in it
# will just result as ban. You've probably misunderstood the idea of /KICK
# if you kick/get kicked all the time "just for fun" ...

use Irssi;
use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.00";
%IRSSI = (
    authors     => 'Timo Sirainen',
    name        => 'autorejoin',
    description => 'Automatically rejoin to channel after kicked',
    license     => 'Public Domain',
    changed	=> 'Sun Mar 10 23:18 EET 2002'
);

my $delay = 10;

my @tags;
my $acttag = 0;

sub channel_rejoin {
	my ( $data ) = @_;
  my ($servtag, $channel, $tag, $server, $password) = split( / +/, $data);

  # check if channel has password
  my $serv = Irssi::server_find_tag( $servtag );
  Irssi::print "Rejoining $channel.";

  # We have to use send_raw() because the channel record still
  # exists and irssi won't even try to join to it with command()
  $serv->send_raw("JOIN $channel $password");
	Irssi::timeout_remove( $tags[$tag] );
}

sub event_rejoin_kick {
  my ($server, $data) = @_;
  my ($channel, $nick) = split(/ +/, $data);

  return if ($server->{nick} ne $nick);

  # check if we want to autorejoin this channel
  my @chans = split(/[ ,]+/, Irssi::settings_get_str('autorejoin_channels'));
  foreach my $chan (@chans) {
    if (lc($chan) eq lc($channel)) {
			
				my $chanrec = $server->channel_find( $channel );
				my $password = $chanrec->{ key } if ( $chanrec );

        my $servtag = $server->{ tag };
				Irssi::print "Rejoining $channel in $delay seconds.";
				$tags[$acttag] = Irssi::timeout_add( $delay * 1000, "channel_rejoin", "$servtag $channel $acttag $server" );
				$acttag++;
				$acttag = 0 if ( $acttag > 60 );
      last;
    }
  }
}

Irssi::settings_add_str('misc', 'autorejoin_channels', '');
Irssi::signal_add('event kick', 'event_rejoin_kick');
