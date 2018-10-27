#!/usr/bin/perl 

use strict;
use CGI;
use CGI::Carp qw ( fatalsToBrowser );
use File::Basename;
use Digest::MD5 qw(md5 md5_hex md5_base64);

$CGI::POST_MAX = 1024 * 5000;

my $service_name = 'picshare';
my $service_domain = 'mypicshare.ru';
my $safe_filename_characters = "a-zA-Z0-9_.-";
my $upload_root = 'shares';
my $invite_code = 'invite01';

my $query = new CGI;
unless ($query -> param('image')) {
	upload_html();
}

my $invite   = $query->param("invite");
upload_html("Wrong invite code") unless ($invite eq $invite_code);
my $filename = $query->param("image");
$filename =~ s/[^$safe_filename_characters]//xg;
my $upload_filehandle = $query->upload("image");

my $ls = 0;
my $dir =  $upload_root . '/' . substr(md5_hex($filename . time),0,7);
while (-e $dir) {
	$ls ++;
	my $dir =  $upload_root . '/' . substr(md5_hex($filename . time . $ls),0,7);
}
mkdir $dir;
open ( UPLOADFILE, ">$dir/temp" ) or die "$!";
binmode UPLOADFILE;
while ( <$upload_filehandle> ) {
	print UPLOADFILE;
}
close UPLOADFILE;

my $identify = `identify -ping $dir/temp`;
my ($newname, $type, $resolution) = split(/ /, $identify);
$type =~ tr/A-Z/a-z/;
unless ($type = 'jpeg' || $type = 'png' || $type = 'gif') {
	unlink "$dir/temp";
	`rm -r $dir`;
	upload_html("This is not an image. Thanks for using $service_name");
}
`mv $dir/temp $dir/image.$type`;
create_index($filename, $dir, $type);
upload_html("File link: http://$service_domain/$dir");



sub upload_html($) {
	my $message = shift;
print $query -> header('text/html');
print <<'END_HTML';

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>$service_name</title>
</head>
<body>
END_HTML

print "$message<br><br>" if ($message);

print <<'END_HTML';
<form action="/" method="post" enctype="multipart/form-data">
<p>Picture to upload: <input type="file" name="image" /></p>
<p>Invite code: <input type="text" name="invite" /> (beta version, sorry)</p>
<p><input type="submit" name="Submit" value="GO" /></p>
</form>
</body>
</html>

END_HTML
exit;
}


sub create_index($$$) {
	my $filename = shift;
	my $dir = shift;
	my $type = shift;
$html = <<END_HTML;
<!DOCTYPE html>
<html>
        <head>
                <meta charset="utf-8">
                <script src="/client.min.js"></script>
                <script src="/jquery-3.1.0.js"></script>
                <title>$filename</title>
        </head>
        <body>
                <center>
<a href=image.$type>Полный размер</a>
<br>
<br>
<script>var filename = 'image.$type';</script>
<script src="/resolution.js"></script>
<noscript>
Sorry. Javascript is required.
</noscript>
</body>
</html>

END_HTML
open (I, ">$dir/index.html");
print I $html;
close I;

}
