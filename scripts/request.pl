use Irssi;

use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
    author => 'pleia2',
    contact => 'lyz@princessleia.com ',
    name => 'request',
    description => 'Gives the chatter things they request, with special responses.',
    license => 'GNU GPL v2 or later',
    url => 'http://www.princessleia.com'
);

sub event_privmsg {
				my ($server, $text, $nick, $mask, $target) = @_;
				my $me=$server->{nick};
				#my ($target, $text) = split(/ :/, $data, 2);
				#my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;


				%get = ( 
				" cookies" => "action $target tend à $nick un cookie.",
				" café" => "action $target tend à $nick une tasse de café.",
				" guinness" => "action $target tend à $nick une pinte de guinness.",
				" chimay" => "action $target tend à $nick un verre de Chimay.",
				" leffe" => "action $target tend à $nick un verre de leffe.",
				" duvel" => "action $target tend à $nick un verre de duvel.",
				" calin" => "action $target fait un calin à $nick",
				" pepsi" => "action $target fais les gros yeux à $nick",
				" coca" => "action $target fais les gros yeux à $nick",
				" glace" => "action $target tend à $nick une glace à la pistache et aux amandes grillées",
				"moo" => "msg $target Est-ce que $nick est une vache ?",
				"meuh" => "msg $target Est-ce que $nick est une vache ?",
				"coin coin" => "action $target pan pan !", 
				"Pan !" => "msg $target Blah.", 
				"action $target o< o< o<" => "Ratatatatata !!" );
				if ( ($target =~ /^#spip}/ ) ) {
								foreach my $want (keys %get) {
												next if ( $text !~ /$want/i );
#												$server->command ( "msg #toto $nick a capte" );
#												$server->command ( "msg #toto $text - $nick - $mask - $target -- "$get{$want}");
												$server->command ( "$get{$want}" );
								}
				}
}

Irssi::signal_add('message public', 'event_privmsg');
#Irssi::signal_add('event privmsg', 'event_privmsg');
