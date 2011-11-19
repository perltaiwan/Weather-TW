use strict;
use warnings;
use utf8;

use Test::More tests => 2;

use Weather::TW::Forecast;
my $w = Weather::TW::Forecast->new(location => '台北市');
is $w->location, '台北市', "location is correct";
my @forecasts = $w->short_forecasts;
is scalar(@forecasts), 3, "three short forecasts";
