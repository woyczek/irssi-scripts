=pod
=head1 NAME
template.pl
=head1 DESCRIPTION
A minimalist template useful for basing actual scripts on.
=head1 INSTALLATION
Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.
=head1 USAGE
None, since it doesn't actually do anything.
=head1 AUTHORS
Copyright E<copy> 2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>>
=head1 LICENCE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
=head1 BUGS
=head1 TODO
Use this template to make an actual script.
=cut

use strict;
use warnings;

use Irssi;
use Irssi::Irc;
use Irssi::TextUI;

use Data::Dumper;

our $VERSION = '0.1';
our %IRSSI = (
              authors     => 'shabble',
              contact     => 'shabble+irssi@metavore.org',
              name        => 'flood-detect',
              description => '',
              license     => 'MIT',
              updated     => '$DATE'
             );


my $NAME  = $IRSSI{name};
my $DEBUG = 0;

my $activity;

sub DEBUG () { $DEBUG }

sub setup_changed {
    $DEBUG = Irssi::settings_get_bool($NAME . '_debug');
}

sub DEBUG () { $DEBUG }

sub _debug_print {
    my ($msg) = @_;
    Irssi::active_window()->print($msg);
}

sub sig_setup_changed {
    $DEBUG = Irssi::settings_get_bool($NAME . '_debug');
    _debug_print($NAME . ': debug enabled') if $DEBUG;
}

sub init {
    Irssi::theme_register
        ([
          verbatim      => '[$*]',
          script_loaded => 'Loaded script {hilight $0} v$1',
         ]);
    Irssi::settings_add_bool($NAME, $NAME . '_debug', 0);
    Irssi::signal_add('setup changed', \&sig_setup_changed);

    Irssi::settings_add_int($NAME, 'flood_detect_lines',  10);
    Irssi::settings_add_int($NAME, 'flood_detect_period', 10);
    Irssi::settings_add_str($NAME, 'flood_detected_action', '/echo $N is flooding!');

    sig_setup_changed();

    Irssi::printformat(Irssi::MSGLEVEL_CLIENTCRAP,
                       'script_loaded', $NAME, $VERSION);
}

init();

sub update_activity {
    my ($nick, $channel, $server) = @_;
}

sub prune_activity_list {
}

sub apply_flood_action {

    my ($channel, $nick, $nick_addr) = @_;

    my $action_setting = Irssi::settings_get_str('flood_detected_action');

    my @actions = split /\s*;\s*/, $action_setting;

    foreach my $action (@actions) {

        my $processed_action = $action;

        if ($action =~ m/suppress/i) {
            return 0;
        } elsif ($action =~ m/kick/i) {
            $processed_action = "/KICK $channel $nick";
        } else {
            $processed_action =~ s/\$nick/$nick/;
            $processed_action =~ s/\$channel/$channel/;
            $processed_action =~ s/\$host/$nick_addr/;

        }

        $processed_action = "/echo $action" if DEBUG;
        $server->command($processed_action);
    }
}

init();
