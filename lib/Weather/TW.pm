package Weather::TW;

use 5.008006;
use strict;
use warnings;
use WWW::Mechanize;
use HTML::TreeBuilder;
use HTML::Element;
use utf8;
use Carp;

our $VERSION = '0.01';

my %area_zh = (
  '台北市'      => '36_01_data.htm',
  '新北市'      => '36_04_data.htm',
  '台中市'      => '36_08_data.htm',
  '台南市'      => '36_13_data.htm', 
  '高雄市'      => '36_02_data.htm',
  '基隆北海岸'  => '36_03_data.htm',
  '桃園'        => '36_05_data.htm',
  '新竹'        => '36_06_data.htm',
  '苗栗'        => '36_07_data.htm',
  '彰化'        => '36_09_data.htm',
  '南投'        => '36_10_data.htm',
  '雲林'        => '36_11_data.htm',
  '嘉義'        => '36_12_data.htm',
  '屏東'        => '36_15_data.htm',
  '恆春半島'    => '36_16_data.htm',
  '宜蘭'        => '36_17_data.htm',
  '花蓮'        => '36_18_data.htm',
  '台東'        => '36_19_data.htm',
  '澎湖'        => '36_20_data.htm',
  '金門'        => '36_21_data.htm',
  '馬祖'        => '36_22_data.htm',
);
my %area_en = (
  'Changhua' => '36_09_data.htm',
  'Chiayi' => '36_12_data.htm',
  'Hengchun Peninsula' => '36_16_data.htm',
  'Hsinchu' => '36_06_data.htm',
  'Hualien' => '36_18_data.htm',
  'Kaohsiung City' => '36_02_data.htm',
  'Keelung North Coast' => '36_03_data.htm',
  'Kinmen' => '36_21_data.htm',
  'Matsu' => '36_22_data.htm',
  'Miaoli' => '36_07_data.htm',
  'Nantou' => '36_10_data.htm',
  'New Taipei City' => '36_04_data.htm',
  'Penghu' => '36_20_data.htm',
  'Pingtung' => '36_15_data.htm',
  'Taichung City' => '36_08_data.htm',
  'Tainan City' => '36_13_data.htm',
  'Taipei City' => '36_01_data.htm',
  'Taitung' => '36_19_data.htm',
  'Taoyuan' => '36_05_data.htm',
  'Yilan' => '36_17_data.htm',
  'Yunlin' => '36_11_data.htm',
);
my $url_zh = "http://www.cwb.gov.tw/V6/forecast/taiwan/";
my $url_en = "http://www.cwb.gov.tw/eng/forecast/taiwan/";

# Preloaded methods go here.

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Weather::TW - Fetch Taiwan weather data from 中央氣象局

=head1 SYNOPSIS

  use Weather::TW;
  my $weather = new Weather::TW;


=head1 DESCRIPTION

Stub documentation for Weather::TW, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head1 METHODS

=item C<<new>>
Create a new C<Weather::TW> object.
=cut

sub new {
  my $class = shift;
  my $self = {@_};
  bless $self, $class;
  return $self;
};

=item C<<city('$area_name')>>
City name can be either Chinese or English. The returned value is C<$self> so you can use it for cascading.
    $xmlstr = $weather->area('Taipei City')->to_XML;
The available city names are:
    台北市       Taipei City
    新北市       New Taipei City
    台中市       Taichung City
    台南市       Tainan City
    高雄市       Kaohsiung City
    基隆北海岸   Keelung North Coast
    桃園         Taoyuan
    新竹         Hsinchu
    苗栗         Miaoli
    彰化         Changhua
    南投         Nantou
    雲林         Yunlin
    嘉義         Chiayi
    屏東         Pingtung
    恆春半島     Hengchun Peninsula
    宜蘭         Yilan
    花蓮         Hualien
    台東         Taitung
    澎湖         Penghu
    金門         Kinmen
    馬祖         Matsu
=cut

sub area {
  my $self = shift;
  my $area_name = shift;
  my $area = $area_en{$area_name};
  $area = $area_zh{$area_name} unless $area;
  croak "Unknown area $area_name!\n" unless $area;
  $area ? $self->_fetch($url_en.$area) : $self->_reset;
  return $self;
}

sub _fetch{
  my $self = shift;
}
sub _reset{
}

=item C<<area_zh>>
Return area names in Chinese.
    @names = $weather->area_zh;
=cut
sub area_zh {
  my $self = shift;
  return %area_zh;
}

=item C<<area_en>>
Return area names in English.
    @names = $weather->area_en;
=cut
sub area_en {
  my $self = shift;
  return %area_en;
}

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

dryman, E<lt>dryman@apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by dryman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
1;
__END__
