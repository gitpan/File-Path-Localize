# $Id: Makefile.PL,v 1.2 2001/03/15 16:29:51 dan Exp $
# -*- perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => "File::Path::Localize",
	      VERSION_FROM => "lib/File/Path/Localize.pm",

	      dist =>
	      {
	       COMPRESS => 'gzip --force --best',
	      },

	      clean =>
	      {
	       FILES => '*.bak *~',
	      },
	      
	      depend => {
	        Makefile => '$(VERSION_FROM)',
	        File-Path-Localize.spec => '$(VERSION_FROM)',
		dist => 'File-Path-Localize.spec',
	      },
	      
	      realclean => {
	       FILES => 'File-Path-Localize-*.tar.gz File-Path-Localize.spec',
	      }
	     );

package MY;

sub libscan
  {
    my ($self, $path) = @_;
    ($path =~ /\~$/) ? undef : $path;
  }

__END__
