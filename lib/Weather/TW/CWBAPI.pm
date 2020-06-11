package Weather::TW::CWBAPI {
    use Moose;
    use Types::Standard qw(StrMatch);

    use Mojo::URL;
    use Mojo::UserAgent;

    has api_base => (
        is => 'ro',
        required => 1,
        default => "https://opendata.cwb.gov.tw/",
    );

    has authorization_key => (
        is => 'ro',
        required => 1,
        isa => StrMatch[qr/[A-Z0-9\-]{40}/],
    );

    sub get {
        my ($self, $path, $query_params) = @_;

        my $url = Mojo::URL->new( $self->api_base );
        $url->path($path);
        $url->query(
            %$query_params,
            Authorization => $self->authorization_key,
            format => 'JSON',
        );

        my $ua = Mojo::UserAgent->new;
        return $ua->get($url, { Accept => 'application/json' });
    }
};

1;

__END__

=encoding utf-8

=head1 NAME

Weather::TW::CWBAPI - Accessing CWB WebAPI

=head1 DESCRIPTION

This is a thin client for CWB WebAPI. Users of this class needs to
know the details about CWB WebAPI in order to use this class
correctly.

=head1 Attributes

=head2 authorization_key

This attribute is mandatory and is need for to make requests. The provided
value is automatically added to every outgoing requests.

=head2 api_base

This is a constant C<"https://opendata.cwb.gov.tw/"> and probably
won't need to be changed.

=head1 Methods

=head2 get( Str $path, HashRef $query_param ) #=> Mojo::Transaction

This method simply re-wrap C<$path> and C<$query_param> and passthrough
C<Mojo::UserAgent->new->get()>.

=cut
