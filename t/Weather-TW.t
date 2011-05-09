# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-TW.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
use utf8;
use lib 'lib';
BEGIN { 
  use_ok('Weather::TW');
  new_ok 'Weather::TW';
};

my $w = new Weather::TW;
can_ok $w, qw(area_zh area_en area _fetch);
eval {$w->area('abcd')};
ok $@, "expect croak when using wrong area name";
ok $w->area('Taipei City'), "English name";
$arr = $w->{data}{seven_day_forecasts}[0]{area};
isnt scalar @{$arr}, 1, "number of Taipei area should be 3 or more";
ok $w->area('台北市'), "Chinese name";



#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

