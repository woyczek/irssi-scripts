# This script responds with a comment each time someone in the channel says "clockbot"
#
# This script requires you to have the text file "clockbot" in your /home/user/.irssi/ directory
#
# cat ~/signatures/sig-natures | sed 's/^%$/####/;'| tr '\n' ' ' | sed 's/[[:space:]]\+/ /g;s/[[:space:]]####[[:space:]]/\n/g;' > ../../clockbot

# asr - Gaétan RYCKEBOER - 2012-2014

use Irssi;

use vars qw($VERSION %IRSSI);
use POSIX qw(strftime);

use LWP::UserAgent;

$VERSION = "1.3.2";

%IRSSI = (
    author => 'pleia2',
    contact => 'lyz@princessleia.com ',
    name => 'TC-14',
    description => 'Protocol Droid, dedicated to Lautre.roots',
    license => 'GNU GPL v2 or later',
    url => 'http://www.lautre.net/',
);
# those 4 files contains random quotes. One per line.
open ( CLOCKE, "<.irssi/randyes" ) or die "can't open randyes:$!\n";
chomp( @randyes = <CLOCKE> );
close CLOCKE;
open ( CLOCKIE, "<.irssi/clockbot" ) or die "can't open clockbot:$!\n";
chomp( @clockbot = <CLOCKIE> );
close CLOCKIE;
open ( CLOCKOK, "<.irssi/randok" ) or die "can't open clockbot:$!\n";
chomp( @clockok = <CLOCKOK> );
close CLOCKOK;
open ( CLOCKPO, "<.irssi/quotes" ) or die "can't open clockbot:$!\n";
chomp( @clockpo = <CLOCKPO> );
close CLOCKPO;

srand (time ^ $$ ^ unpack "%L*", `ps axww | gzip -f`);

my $changefile="/home/tc-14/var/changelog";
my $debug=0;
my $bingo=0;
my $last='';
my $warn='';
my @dad=("asr", "asr`", "asr_", "asr\\", "asr`_");
my $timeout=30;
my $warndate=time()-$timeout;

Irssi::settings_add_str($IRSSI{name},          # default fifo_remote_file
    'tc_chans', '#flood #starwars');     #
Irssi::settings_add_str($IRSSI{name},          # default fifo_remote_file
    'tc_admins', 'asr coin plop');     #
Irssi::settings_add_str($IRSSI{name},          # default fifo_remote_file
    'tc_logfile', '/home/tc-14/var/chan.log');     #

my @chan=split m/ /, Irssi::settings_get_str("tc_chans");
my @admin_chan=split m/ /,  Irssi::settings_get_str("tc_admins");
my $logfile=Irssi::settings_get_str("tc_logfile");

sub in_array {
	my ($arr,$search_for) = @_;
	return grep {$search_for eq $_} @$arr;
}


sub event_join {
  my ($server, $data, $nick, $host) = @_;
  my ($target) = $data =~ /^:(.*)/;

	my $admin=0;

	if (in_array(@chan,$target) || in_array(@admin_chan,$target))
	{
		return;
	}

	foreach $father (@dad) {
		if ($father eq $nick) {
			$admin=1;
		}
	}

#	if ($nick =~ /^BirthdayBot$/i) {
#		$server->command ( "mode $target +o $nick" );
#	}
}

sub event_privmsg {

my ($server, $data, $nick, $mask) =@_;
my ($target, $text) = $data =~ /^(\S*)\s:(.*)/;

	#print ( "C:$target X:$text A:$admin D:$warndate L:$last W:$warn N:$nick D:$data" );

	sub send_server($$$$) {
		my ($action,$cible,$pseudo,$msg)=@_;
		$server->command ( "msg $target SWarn C:$cible X:$action A:$admin D:$warndate L:$last W:$warn N:$pseudo T:$msg" ) unless ($debug == 0);
		if (in_array(@chan,$target) || in_array(@admin_chan,$pseudo))
		{
			return;
		} else {
			if (($warndate + $timeout) < time()) {
				$warn='';
				$last='';
			}
			if (!($warn eq $pseudo)) {
				if ($last eq $pseudo)  {
					$server->command ( "msg $cible $pseudo: Chut.");
					$warn=$nick;
				} else {
					$server->command ( "$action $cible $msg" );
					$last=$nick;
				}
			} else {
				$server->command ( "msg $cible $pseudo bloque pour $timeout" ) unless $debug=0;
			}
			$warndate=time();
		}
	}

	my $admin=0;

	if (in_array(@chan,$target) || in_array(@admin_chan,$target))
	{
		return;
	}

	foreach $father (@dad) {
		if ($father eq $nick) {
			$admin=1;
		}
	}

	my $locdate=time()-$warndate;
	if ( $text =~ /^!status/i ) {
		if ($admin == 1) {
			my $locdate=time()-$warndate;
			$server->command ( "msg $target S1 A:$admin D:$warndate L:$last W:$warn N:$nick WD:$locdate/$timeout");
			$server->command ( "msg $target S2 V:$VERSION D:$debug T:$text B:$bingo" );
			foreach $K (keys %bingovar) {
				$server->command ( "msg $target SB $K:$bingovar{$K}" );
			}
		}
		return 1;
	}
	if (($warn ne $nick) || ($locdate) > time()) {
#		if ( $text =~ /^tc-14:/i ) {
#			$clocky="J'cause pas aux cons, ca les instruit.";
#			send_server("msg", $target, $nick, "$clocky");
#		}
#		elsif ( $text =~ /^tc-14/i ) {
#		#   $clocky = $clockok[rand @clockok];
#		#	send_server("msg", $target, $nick, "$nick: $clocky");
#		}
		if ( $text =~ /^\\_o< ~ Coin ~ >o_\//i ) {
		   $clocky = $clockok[rand @clockok];
			send_server("msg", $target, $nick, "$nick: \\_o< \\_o<");
		}
		elsif ( $text =~ /^!password( .+)?/ ) {
			my $password ="";
			$length = $1;
			if ($1 eq '') { $length = 10; }
			elsif ($1 >60) { $length = 60; }
			elsif ($1 < 5 ) { $length = 5; }
			   my $possible = 'abcdefghijkmnpqrstuvwxyz23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
			   while (length($password) < $length) {
			     $password .= substr($possible, (int(rand(length($possible)))), 1);
			   }
			send_server("msg", $target, $nick, "$password");
		}
		elsif ( $text =~ /(th[^ ]+orie|pragmatique|delirium|spongieux|postural|fonctionnellement|cathar|quadri|capillo|drosoph)/i ) {
			if ( ! ($target =~ /spip|wikipedia/ ) ) {
				 if (!($warn eq $nick)) {
					 $last=$nick;
					 $clocky = "Coche la case.";
					 if ($bingovar{$1} eq "coche") {$clocky = "deja coche"}
						 else {
							$bingovar{$1} = "coche";
							$bingo++;
						 }
					 $server->command ( "action $target $clocky" );
					 if ( $bingo > 3 ) {
					   undef(%bingovar);
					   $bingo=0; $clocky="FOUTAISES !";
					   $server->command ( "msg $target $clocky" );
					   $warn=$nick;
					 }
				}
			}
		}
		elsif ( $text =~ /fortune/i ) {
			$clocky = $clockbot[rand @clockbot];
			send_server("msg", $target, $nick, $clocky) unless ($nick =~ /edgard/i);
		}
	}
	if ($debug == 1) {
		$server->command ( "msg $target D1 A:$admin L:$last W:$warn N:$nick B:$bingo" );
		my $locdate=time()-$warndate;
		$server->command ( "msg $target D2 W:$warndate T1:".time." T2:$locdate" );
	}
}

Irssi::signal_add('event privmsg', 'event_privmsg');
Irssi::signal_add("event join", "event_join");
Irssi::signal_add("message public", "event_privmsg");

print $IRSSI{"name"}." loaded $VERSION.";
