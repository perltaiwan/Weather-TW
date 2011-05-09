# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Weather-TW.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
use utf8;
use lib 'lib';
BEGIN { 
  use_ok('Weather::TW');
  new_ok 'Weather::TW';
};

my $w = new Weather::TW;
can_ok $w, qw(area_zh area_en area _fetch _reset);
eval {$w->area('abcd')};
ok $@, "expect croak when using wrong area name\n";



#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

