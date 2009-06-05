#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'CGI::Application::Plugin::FirePHP' );
}

diag( "Testing CGI::Application::Plugin::FirePHP $CGI::Application::Plugin::FirePHP::VERSION, Perl $], $^X" );
