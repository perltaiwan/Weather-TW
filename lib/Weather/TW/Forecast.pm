package Weather::TW::Forecast;

use strict;
use warnings;
use utf8;
use LWP::Simple;
use Moose;
use Moose::Util::TypeConstraints;
use Mojo::DOM;
use DateTime;
use Carp;

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

=head2 C<new>

    my $weather = Weather::TW::Forecast->new(
      location => '台北',
    );

Construct a new Weather::TW::Forecast object.

Available locations are

    台北市 新北市 台中市 台南市 高雄市 基隆北海岸 桃園 新竹 苗栗 彰化 南投 雲林 嘉義 屏東 恆春半島 宜蘭 花蓮 台東 澎湖 金門 馬祖

Weather::TW::Forecast will do the fetching right after location is set.

=head2 C<location>

    $weather->location('台中市'); 
    # Change location to 台中市 and do the fetching
    
    $location = $weather->location();
    # Get the location string of $weather

Setter and getter of location.

=cut

has location => (
  is => 'rw',
  isa => enum([qw|台北市 新北市 台中市 台南市 高雄市 
    基隆北海岸 桃園 新竹 苗栗 彰化 南投 雲林      
    嘉義 屏東 恆春半島 宜蘭 花蓮 台東 澎湖 金門 馬祖|]),
  trigger => \&_fetch_forecast,
);

=head2 C<short_forecast>

=cut

has short_forecast => (
  traits => ['Array'],
  is => 'ro',
  isa => 'ArrayRef[Weather::TW::Forecast::ShortForecast]',
  clearer => '_clear_short_forecast',
  handles => { _add_short_forecast => 'push' },
);

=head2 C<weekly>

=cut

has weekly => (
  is => 'ro',
  isa => 'ArrayRef[Weather::TW::Forecast::Weekly]',
);

has monthly_mean => (
  is => 'ro',
  isa => 'HashRef',
);

sub _fetch_forecast {
  my $self=shift;
  my $url = 'http://www.cwb.gov.tw/V7/forecast/taiwan/'. $area_zh_v7{$self->location()};
  my $content = get $url or croak "Can't fetch url $url";
  my $dom = Mojo::DOM->new($content);

  my @titles = $dom->find('h3.CenterTitle')->each;
  my @tables = $dom->find('table.FcstBoxTable01')->each;
  my $title; 
  my $table;

  $self->_clear_short_forecast;
  do {
    $title = shift @titles or croak "Can't get 今明預報 in $url";
    $table = shift @tables;
  }until $title->all_text =~ /^今明預報/;
  $table->find('tbody>tr')->each(sub{
    my $e = shift;
    my @tds = $e->find('td')->each;

#  <tr>
#    <th scope="row">今晚至明晨 11/19 18:00~11/20 06:00</th>
#    <td>20 ~ 23</td>
#    <td> <img alt="陰短暫陣雨" src="../../symbol/weather/gif/night/26.gif" title="陰短暫陣雨" /></td>
#    <td>舒適</td>
#    <td>100 %</td>
#  </tr>
    my $time_range = $e->at('th')->all_text or croak "Can't get time range";
    my $temp_range = (shift @tds)->text or croak "Can't get temperature";
    my $weather = (shift @tds)->attr('title') or croak "Can't get weather info";
    my $confortable = (shift @tds)->text or croak "Can't get confortable info";
    my $rain = (shift @tds)->text or croak "Can't get rain info";

    $time_range =~ 
      qr|(\d+)/     # month
         (\d+)\s    # day
         (\d+):     # hour
         (\d+)~     # minute
         (\d+)/(\d+)\s(\d+):(\d+)|x;
    my $today = Datetime->today();

    $self->_add_short_forecast(Weather::TW::Forecast::ShortForecast->new(
      start => DateTime->new(
        year => $today->year,
        month => $1, day => $2,
        hour => $3, minute => $4,
        time_zone => 'Asia/Taipei'),
      end => DateTime->new(
        year => $today->year,
        month => $5, day=>$6, hour=>$7, minute=>$8,
        time_zone => 'Asia/Taipei'),
      temperature => $temp_range,
      weather => $weather,
      confortable => $confortable,
      rain => $rain,
    ));
  });
};

package Weather::TW::Forecast::Weekly;
use DateTime;
use Moose;
has day => qw|is ro isa DateTime|;
has temperature => qw|is ro isa Str|;
has weather => qw|is ro isa Str|;

package Weather::TW::Forecast::ShortForecast;
use DateTime;
use Moose;
has start => qw|is ro isa DateTime|;
has end => qw|is ro isa DateTime|;
has temperature => qw|is ro isa Str|;
has weather => qw|is ro isa Str|;
has confortable => qw|is ro isa Str|;
has rain => qw|is ro isa Int|;

1;
__END__
