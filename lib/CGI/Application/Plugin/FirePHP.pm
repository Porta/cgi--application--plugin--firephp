package CGI::Application::Plugin::FirePHP;

use strict;
use vars qw($VERSION @EXPORT);

use CGI::Application;
use HTTP::Headers;
use FirePHP::Dispatcher;


@EXPORT = qw(
  log
  log_start
  log_finish
  headers
);

sub import { 
    my $pkg = shift;
    my $callpkg = caller;
    no strict 'refs';
    foreach my $sym (@EXPORT) {
        *{"${callpkg}::$sym"} = \&{$sym};
    }
    
    if ( ! UNIVERSAL::isa($callpkg, 'CGI::Application') ) {
        warn "Calling package is not a CGI::Application module so not setting up the prerun hook.  If you are using \@ISA instead of 'use base', make sure it is in a BEGIN { } block, and make sure these statements appear before the plugin is loaded";
    }
    elsif ( ! UNIVERSAL::can($callpkg, 'add_callback')) {
        warn "You are using an older version of CGI::Application that does not support callbacks, so the prerun method can not be registered automatically (Lookup the prerun_callback method in the docs for more info)";
    }
    else {
	    #Add the required callback to the CGI::Application app so it executes the log_start sub on the prerun stage and log_finish on post run (in order to create the new log object and finalize it before sending the headers)
        $callpkg->add_callback( prerun => 'log_start' );
        $callpkg->add_callback( postrun => 'log_finish' );
    }
}

sub log_start {
    my $self = shift;
    my $headers = HTTP::Headers->new;
    $self->{'Application::Plugin::FirePHP::__log_object'} = FirePHP::Dispatcher->new($headers);
    $self->{'Application::Plugin::FirePHP::__headers'} = $headers;
    return 1;
}

sub headers{
    my $self = shift;
    return $self->{'Application::Plugin::FirePHP::__headers'};
}

sub log {
    my $self = shift;
    my $message = shift;
    return $self->{'Application::Plugin::FirePHP::__log_object'};
}


sub log_finish {
    my $self = shift;
    $self->log->finalize;
    foreach my $field ($self->headers->header_field_names){
        $self->header_add('-'.$field => $self->headers->header($field));
    }
    return;
}

=head1 NAME

CGI::Application::Plugin::FirePHP - Send messages to FirePHP Console

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

In your CGI::Application class:

    package My::App;
    use base 'CGI::Application';
    use CGI::Application::Plugin::FirePHP;
    
    
    sub setup {
        #your app setup info
    }
    
    sub my_runmode {
        my $self = shift;
        $self->log->log('this is a plain log message');
        $self->log->info('this is a info message');
        $self->log->warn('this is a warn message');
        $self->log->error('this is a error message');
        $self->log->start_group('group_name');
        $self->log->error('error in group group_name');
        $self->log->end_group('this is a error message');
    
    }

For all methods, you can just refer to the FirePHP::Dispatcher docs: L<http://search.cpan.org/~willert/FirePHP-Dispatcher-0.02_01/>


=head1 AUTHOR

Julián Porta, C<< <julian.porta at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-cgi-application-plugin-firephp at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CGI-Application-Plugin-FirePHP>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc CGI::Application::Plugin::FirePHP


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CGI-Application-Plugin-FirePHP>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CGI-Application-Plugin-FirePHP>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CGI-Application-Plugin-FirePHP>

=item * Search CPAN

L<http://search.cpan.org/dist/CGI-Application-Plugin-FirePHP/>

=back


=head1 ACKNOWLEDGEMENTS

This is only a simple wrapper to Sebastian Willert's FirePHP::Dispatcher.
More info, here: L<http://search.cpan.org/~willert/>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Julián Porta, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of CGI::Application::Plugin::FirePHP
