# $Id: 005Localize.t,v 1.2 2004/03/31 18:05:36 dan Exp $

BEGIN { $| = 1; print "1..5\n"; }
END { print "not ok 1\n" unless $loaded; }

use File::Path::Localize;
use File::Spec;

$loaded = 1;
print "ok 1\n";

my @locales = ("en_GB.UTF8", "en_US", "fr_FR");

my @actual_files = File::Path::Localize::expand(filename => "foo.txt", 
						locales => \@locales);

my @expected_files = (
		      "foo.txt.en_GB.UTF8",
		      "foo.txt.en_GB",
		      "foo.txt.en",
		      "foo.txt.en_US",
		      "foo.txt.en",
		      "foo.txt.fr_FR",
		      "foo.txt.fr",
		      "foo.txt"
);

print "not " unless $#expected_files == $#actual_files;
print "ok 2\n";

my $ok = 1;
if ($ok) {
  for (my $i = 0 ; $i  <= $#expected_files ; $i++) {
    $ok = 0 unless $expected_files[$i] eq $actual_files[$i];
  }
}

print "ok 3\n" if $ok;
print "not ok 3\n" unless $ok;

my $tmp = File::Spec->tmpdir;

my $dir_base = File::Spec->catfile($tmp, "IO-Resource-$$");
my $dir_one = File::Spec->catfile($dir_base, "one");
my $dir_two = File::Spec->catfile($dir_base, "two");

mkdir $dir_base, 0755 or
  die "cannot create dir $dir_base: $!";
mkdir $dir_one, 0755 or
  die "cannot create dir $dir_one: $!";
mkdir $dir_two, 0755 or
  die "cannot create dir $dir_two: $!";

my $file_one = File::Spec->catfile($dir_one, "foo.txt.fr");
my $file_two = File::Spec->catfile($dir_two, "bar.txt.en_GB");

open FILE_ONE, ">$file_one"
  or die "cannot touch $file_one: $!";
close FILE_ONE;
open FILE_TWO, ">$file_two"
  or die "cannot touch $file_two: $!";
close FILE_TWO;

my @path = ( $dir_one, $dir_two );

my $filename_foo = File::Path::Localize::locate(filename => "foo.txt",
						locales => \@locales,
						path => \@path);

print "not " unless $filename_foo eq $file_one;
print "ok 4\n";

my $filename_bar = File::Path::Localize::locate(filename => "bar.txt",
						locales => \@locales,
						path => \@path);

print "not " unless $filename_bar eq $file_two;
print "ok 5\n";

unlink $file_one;
unlink $file_two;
rmdir $dir_one;
rmdir $dir_two; 
rmdir $dir_base;

# Local Variables:
# mode: cperl
# End:
