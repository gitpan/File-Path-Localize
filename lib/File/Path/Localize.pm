# -*- perl -*-
#
# IO::File::Cached by Daniel Berrange <dan@berrange.com>
#
# Copyright (C) 20004  Daniel P. Berrange <dan@berrange.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# $Id: Document.pm,v 1.4 2002/01/20 19:55:12 dan Exp $

=pod

=head1 NAME

    File::Path::Localize - locale and path aware file name resolution

=head1 SYNOPSIS

    use File::Path::Localize;

    my @filenames = File::Path::Localize::expand(filename => $filename,
						 locales => \@locales);

    my $filepath = File::Path::Localize::locate(filename => $filename,
						path => \@path,
						locales => \@locales);

=head1 DESCRIPTION

The File::Path::Localize module provides a method to turn a relative 
filename into an absolute filename using a listed of paths.
It can also localize the file path based on a list of locales.

=head1 METHODS

=over 4

=cut
    
package File::Path::Localize;

use strict;
use Carp qw(confess);

use vars qw($VERSION);

### The package version, both in 1.23 style *and* usable by MakeMaker:
$VERSION = substr q$Revision: 1.0.0 $, 10;

=item my $filename = locate(filename => $filename, locales => \@locales, path => \@path);

Finds the best matching localized file in a set of paths.

=cut

sub locate {
    my %params = @_;
    
    my $filename = exists $params{filename} ? $params{filename} : confess "filename parameter is required";
    my $locales = exists $params{locales} ? $params{locales} : undef;
    my $path = exists $params{path} ? $params{path} : confess "path parameter is required";
    
    return $filename if $filename eq "-";
    
    foreach my $filename (expand(filename => $filename, locales => $locales)) {
	if ($filename =~ /^\//) {
	    return $filename if -e $filename;
	} else {
	    foreach my $path (@{$path}) {
		return "$path/$filename" if -e "$path/$filename";
	    }
	}
    }
    
    return undef;
}


=item my \@filenames = expand(filename => $filename, locales => \@locales)

Expands a filename with a set of locales. For example given a filename
foo.txt and an array of locales [ en_GB.UTF-8, en_US, fr_FR] it will
return the set [ foo.txt.en_GB.UTF-8, foo.txt.en_GB, foo.txt.en, 
foo.txt.en_US, foo.txt.en, foo.txt.fr, foo.txt.fr]

=cut

sub expand {
    my %params = @_;

    my $filename = exists $params{filename} ? $params{filename} : confess "filename parameter is required";
    my $locales = exists $params{locales} ? $params{locales} : [];

    my @files;
    foreach my $locale (@{$locales}) {
	my $language;
	my $country;
	my $charset;

	if ($locale =~ /^(\w\w)(?:_(\w\w)(?:\.([[:print:]]+))?)?$/) {
	    $language = $1;
	    $country = $2;
	    $charset = $3;
	} else {
	    confess "cannot grok locale $locale\n";
	}

	my @variations;
	push @variations, join("", $language, "_", $country, ".", $charset)
	    if defined $charset;
	push @variations, join("", $language, "_", $country)
	    if defined $country;
	push @variations, $language;
	
	push @files, map { $filename . "." . $_ } @variations;
    }
    push @files, $filename;

    return @files;
}

1 # So that the require or use succeeds.

__END__

=back 4

=head1 AUTHORS

Daniel Berrange <dan@berrange.com>

=head1 COPYRIGHT

    Copyright (C) 2004 Daniel P. Berrange <dan@berrange.com>

=head1 SEE ALSO

    L<perl(1)> 

=cut
