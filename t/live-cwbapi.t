use Test2::V0;
use Weather::TW::CWBAPI;

skip_all 'Requires CWBAPI_AUTH_KEY env var' unless $ENV{CWBAPI_AUTH_KEY};

my $cwb = Weather::TW::CWBAPI->new(
    authorization_key => $ENV{CWBAPI_AUTH_KEY},
);

my $res;

$res = $cwb->get('/api/v1/rest/datastore/XXXXXXXXX')->res;
ok ! $res->is_success;

$res = $cwb->get('/api/v1/rest/datastore/F-C0032-001')->res;
ok $res->is_success;

done_testing;
