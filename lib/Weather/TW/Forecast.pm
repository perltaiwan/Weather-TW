package Weather::TW::Forecast;

use strict;
use warnings;
use utf8;
use LWP::Simple;
use Moose;
use Moose::Util::TypeConstraints;
use Mojo::DOM;

my %area_zh_v7 = (
  台北市      => 'Taipei_City.htm',
  新北市      => 'New_Taipei_City.htm',
  台中市      => 'Taichung_City.htm',
  台南市      => 'Tainan_City.htm', 
  高雄市      => 'Kaohsiung_City.htm',
  基隆北海岸  => 'Keelung_North_Coast.htm',
  桃園        => 'Taoyuan.htm',
  新竹        => 'Hsinchu.htm',
  苗栗        => 'Miaoli.htm',
  彰化        => 'Changhua.htm',
  南投        => 'Nantou.htm',
  雲林        => 'Yunlin.htm',
  嘉義        => 'Chiayi.htm',
  屏東        => 'Pingtung.htm',
  恆春半島    => 'Hengchun_Peninsula.htm',
  宜蘭        => 'Yilan.htm',
  花蓮        => 'Hualien.htm',
  台東        => 'Taitung.htm',
  澎湖        => 'Penghu.htm',
  金門        => 'Kinmen.htm',
  馬祖        => 'Matsu.htm',
);

=head1 NAME

Weather::TW::Forecast - Get Taiwan forecasts

=cut

has location => (
  is => 'rw',
  isa => enum([qw|台北市 新北市 台中市 台南市 高雄市 
    基隆北海岸 桃園 新竹 苗栗 彰化 南投 雲林      
    嘉義 屏東 恆春半島 宜蘭 花蓮 台東 澎湖 金門 馬祖|]),
  trigger => \&_fetch_forecast,
);

=item C<<new>>

Available locations are

    台北市 新北市 台中市 台南市 高雄市 基隆北海岸 桃園 新竹 苗栗 彰化 南投 雲林 嘉義 屏東 恆春半島 宜蘭 花蓮 台東 澎湖 金門 馬祖

=cut


sub _fetch_forecast {};

1;
__END__
