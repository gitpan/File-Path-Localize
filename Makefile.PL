# $Id: Makefile.PL,v 1.2 2004/03/31 18:05:36 dan Exp $
# -*- perl -*-

use ExtUtils::MakeMaker;

WriteMakefile(
	      NAME => "File::Path::Localize",
	      VERSION_FROM => "lib/File/Path/Localize.pm",
	      AUTHOR => "Daniel P. Berrange (dan[at]berrange[dot]com)",

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
