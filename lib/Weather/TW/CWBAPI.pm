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
