#!/usr/bin/perl
use MIME::Base64;
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename;
use Digest::MD5 qw(md5 md5_hex md5_base64);
my $query = new CGI;
unless ($query -> param('image')) {
	upload_html();
}

my $root = 'shares';

my $sid = $query -> param('sid');
my @a = split(/\|/, decode_base64($sid));
my $dir = $root . '/' . shift @a;

unless (-e $dir) {
	print $query -> header;
	print "wrong sid\n";
	exit;
}
#my $identify = `identify -ping $dir/temp`;
#my ($newname, $type, $resolution) = split(/ /, $identify);

open (L, ">>$dir/log.txt");
for $k (@a) {
	print LOG "$k\n";
}
print "\n\n";
close L;

print $query -> header;

