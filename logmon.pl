#!/usr/bin/perl -wT
#uso: /usr/bin/perl -wT /usr/local/sbin/logmon.pl -m sysadmins@nixus.es -u asterisk -g adm -f /var/log/asterisk/messages -p Lagged -i 60
# /usr/bin/perl -wT /usr/local/sbin/logmon.pl -m pablojoserocamora@gmail.com -u procamora -g adm -f /var/log/syslog -p FRASEABUSCAR -i 60
# Parses given logfile, looking for specified pattern, sends alert or
# logs message.
#
# Copyright (c) 2012 Doug Maxwell <doug@unixlore.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA
#
# Sample syslog error we want to alert on and usage:
#
# Jul 17 08:02:49 kaylee mysqld[1532]: 110717  8:02:49 [ERROR] /usr/sbin/mysqld: Table './mysql/user' is marked as crashed and should be repaired
#
# logmon.pl -p 'mysqld.+?table.+?crashed' -m you@example.com -u nobody -g adm -f /var/log/syslog -i 120
#
# Needs Mail::Mailer, Proc::Daemon, Unix::Syslog and File::Tail
# installed - the others are core modules.
#
# On Debian/Ubuntu:
# apt-get install libmailtools-perl libunix-syslog-perl libfile-tail-perl libproc-daemon-perl
#
# On Fedora
# yum install perl-MailTools perl-Unix-Syslog perl-File-Tail perl-Proc-Daemon
#
# CPAN:
#
# for m in Mail::Mailer Proc::Daemon Unix::Syslog File::Tail; do perl -MCPAN -e "install $m"; done
#
use strict;
use File::Tail;
use Mail::Mailer;
use Proc::Daemon;
use Unix::Syslog qw(:subs);
use Unix::Syslog qw(:macros);
use Getopt::Std;
use Sys::Hostname;
use POSIX qw(setuid setgid);
use English;

our ($opt_m,$opt_f,$opt_p,$opt_u,$opt_g,$opt_i,$opt_h,$opt_d,$opt_v);
getopts('hdvm:f:p:u:g:i:');

usage() && exit if ( $opt_h || !$opt_p);

sub usage {
    print "\n$0 synopsis: Daemon that periodically checks logfile for a pattern and send alerts\n";
    print "Pattern is always required. If no other options are given, defaults to syslog alerts and monitors /var/log/messages for given pattern.\n";
    print "Usage: $0  -p pattern [-m alerts\@example.com] [-f logfile] [-u run as user] [-g run as group] [-i max interval] [-v] [-d] [-h]\n";
    print "-m: Email destination for alerts\n-f: logfile to monitor\n-p: Pattern to match against lines in logfile (Perl regexp, match is case-insensitive)\n-u: Run with permissions of user\n-g: Run with permissions of group\n-i: Max time to sleep between checks\n-d: Debug output to STDERR, do not daemonize\n-v: Verbose logging (use with caution or you may have endless alerts)\n-h: This help text\n\n";
}

my $DEBUG = 1 if ( $opt_d );

if ( !$DEBUG ) {
    # Fork and detach
    log_alert("Forking and detaching from controlling terminal...");
    Proc::Daemon::Init;
}

# Drop privileges if needed.
if ( $opt_g && $UID == 0 ) {
    setgid( scalar getgrnam $opt_g ) or log_alert($!);
    log_alert("Now running with permissions of group $opt_g") if ( $GID );
}

if ( $opt_u && $UID == 0 ) {
    setuid( scalar getpwnam $opt_u ) or log_alert($!);
    log_alert("Now running with permissions of user $opt_u") if ( $UID );
}

# Clean up our environment for taint mode
delete @ENV{qw(IFS CDPATH ENV BASH_ENV)};
$ENV{PATH} = "/bin:/usr/bin";

# Source of email alerts
my $from = 'root@example.com';

# The logfile we are monitoring. Make sure we can read it and that it
# exists.
my $logfile = "/var/log/messages";

if ( $opt_f ) {
    if ( ! -r $opt_f ) {
        log_alert("Logfile $opt_f does not exist or is not readable");
        die;
    } else {
        $logfile = $opt_f;
    }
}

# Pre-compile the regexp we are using
my $pattern = qr/$opt_p/io;

# Mail recipient for alerts
my $recipient = $opt_m if ( $opt_m );

# Max time to wait between checks. File::Tail uses an adaptive
# algorithm to vary the time between file checks, depending on the
# amount of data being written to the file. This is the maximum
# allowed interval.
my $maxinterval = 60;
$maxinterval = $opt_i if ( $opt_i );

my $file = File::Tail->new(name=>$logfile, maxinterval=> $opt_i, adjustafter=>3) or ( log_alert($!) && die );

( $opt_v ) ? log_alert("Running and monitoring $logfile for $pattern") : log_alert("Running and monitoring $logfile");

# Loop as long as we keep getting lines from the file
while (defined(my $line = $file->read)) {
    if ( $line =~ /$pattern/ ) {
        chomp($line);
        if ( $opt_m ) {
            send_mail_alert($from,$recipient,$line);
        } else {
            ( $opt_v ) ? log_alert("Matched $pattern against '$line' in $logfile") : log_alert("$logfile matched!");
        }
    }
}

# Send an email alert using sendmail on the localhost
sub send_mail_alert {
  my ($from,$recipient,$body) = @_;
  my $hostname = hostname();
  my $subject = "Alert from $0 on $hostname while monitoring $logfile for $pattern";
  my $mailer = Mail::Mailer->new("sendmail");
  $mailer->open({ From    => $from,
		  To      => $recipient,
		  Subject => $subject,
		})
    or log_alert($!);
  print $mailer $body or log_alert($!);
  $mailer->close( );
  log_alert("Sent email alert to $recipient");
  return;
}

# Log a message to this system's syslog. If debugging is enabled, we
# are not a daemon and we just print to STDERR.
sub log_alert {
  my $text = shift;

  if ( $DEBUG ) {
      print STDERR "$0: $text\n";
      return;
  }

  openlog ("$0", LOG_PERROR|LOG_CONS , LOG_LOCAL7);
  syslog (LOG_INFO, "$text\n");
  closelog();
  return;
}
