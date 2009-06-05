use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CGI::Application::Plugin::FirePHP',
    AUTHOR              => 'Julián Porta <julian.porta@gmail.com>',
    VERSION_FROM        => 'lib/CGI/Application/Plugin/FirePHP.pm',
    ABSTRACT_FROM       => 'lib/CGI/Application/Plugin/FirePHP.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CGI-Application-Plugin-FirePHP-*' },
);
