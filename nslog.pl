#!/usr/bin/perl

use strict;
use MIME::Base64;

my $service_domain = 'picshare.ru';
my $homedir        = '/home/picshare';
my $log            = '/var/log/bind/named_query.log';
my $url            = "http://$service_domain/resolution.pl";

open (L0, "$homedir/last");
my $lasttime = <L0>;
close L0;

my $grep = "egrep [^\(]$service_domain " . $log;
my @grep = `$grep`;

for $str (@grep) {
	my ($time, $ip, $dir) = $str =~ /(\d\d-\w\w\w-\d\d\d\d \d\d:\d\d:\d\d.\d+) client (\d+.\d+.\d+.\d+)\#\d+ \((\w+).$service_domain)/;
	$time = parsetime($time);
	if ($time > $lasttime) {
		my $sid = "$dir|$time|Client addr: $ip";
		my $wget = 'wget ' . $url . '?sid=' . encode_base64($sid)) . '=';
		`$wget`;
	}
}

open (L0, "$homedir/last");
print L0 $time;
close L0;

sub parsetime($) {
	my $time = shift;
	my %mon = ('Jan' => 0, 'Feb' => 1, 'Mar' => 2, 'Apr' => 3, 'May' => 4, 'Jun' => 5, 'Jul' => 6, 'Aug' => 7, 'Sep' => 8, 'Oct' => 9, 'Nov' => 10, 'Dec' => 11);

	my ($day, $mmon, $year, $hour, $min, $sec) = $time =~ /(\d\d)-(\w\w\w)-(\d\d\d\d) (\d\d):(\d\d):(\d\d).\d+)/;
	$mmon = $mon{$mmon);
	return timelocal( $sec, $min, $hour, $day, $mmon, $year );	

}

