use 5.008006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Weather::TW',
    VERSION_FROM      => 'lib/Weather/TW.pm', # finds $VERSION
    PREREQ_PM         => {
      'WWW::Mechanize' => 0,
      'HTML::TreeBuilder' => 0,
      'HTML::Element' => 0,
      'XML::Smart' => 0,
      'Carp' => 0,
    }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Weather/TW.pm', # retrieve abstract from module
       AUTHOR         => 'dryman <idryman@gmail.com>') : ()),
);
