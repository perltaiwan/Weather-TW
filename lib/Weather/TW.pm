package Weather::TW;

our $VERSION = '0.352';

=encoding utf-8

=cut

use 5.008006;
use strict;
use warnings;
use Encode qw/encode decode/;
use LWP::UserAgent;
use HTML::TreeBuilder;
use HTML::Element;
use XML::Smart;
use JSON;
use YAML qw(Dump);
use utf8;
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



=head1 NAME

Weather::TW - Fetch Taiwan weather data from L<http://www.cwb.gov.tw/>

=head1 SYNOPSIS

  use Weather::TW;

  my $weather = Weather::TW->new;
  my $xml = $weather->area('Taipei City')->xml;
  my $json = $weather->json;
  my $yaml = $weather->yaml;
  my %hash = $weather->hash;

  foreach my $area ($weather->area_en){
    my $xml = $weather->area($area)->xml
    print $xml;
  }

  use utf8;
  $xml = $weather->area('台北')->xml;
  # Chinese also works!

=head1 DESCRIPTION

This module parse data from L<http://www.cwb.gov.tw/> (中央氣象局), and generates xml/json/hash/yaml data.

=head1 METHODS

=over

=item C<< new >>

Create a new C<Weather::TW> object. Available option is C< lang >, see method C< lang >.

  $weather = Weather::TW->new( lang => 'zh' );

=cut

sub new {
  my $class = shift;
  my $self = {
    lang=>'en',
    @_,
  };
  bless $self, $class;
  return $self;
}

=item C<< area($area_name) >>


City name can be either Chinese or English. The returned value is C<$self> so you can use it for cascading.

    $xmlstr = $weather->area('Taipei City')->xml;

The available area names are:

   台北市         Taipei City
   新北市         New Taipei City
   台中市         Taichung City
   台南市         Tainan City
   高雄市         Kaohsiung City
   基隆北海岸     Keelung North Coast
   桃園           Taoyuan
   新竹           Hsinchu
   苗栗           Miaoli
   彰化           Changhua
   南投           Nantou
   雲林           Yunlin
   嘉義           Chiayi
   屏東           Pingtung
   恆春半島       Hengchun Peninsula
   宜蘭           Yilan
   花蓮           Hualien
   台東           Taitung
   澎湖           Penghu
   金門           Kinmen
   馬祖           Matsu

=cut

sub area {
  my $self = shift;
  my $area_name = shift;
  my $area = $area_en{$area_name};
  $area = $area_zh{$area_name} unless $area;
  croak "Unknown area $area_name\n" unless $area;
  $self->{lang} eq 'zh' ? $self->_fetch($url_zh.$area) : $self->_fetch($url_en.$area);
  return $self;
}

=item C< lang($lang) >

Available options are 'zh' or 'en'.

=cut

sub lang{
  my ($self, $opt) = @_;
  $self->{lang}=$opt;
}


=item C<< area_zh >>

Return area names in Chinese.

    @names = $weather->area_zh;

=cut
sub area_zh {
  my $self = shift;
  return %area_zh;
}

=item C<< area_en >>

Return area names in English.

    @names = $weather->area_en;

=cut
sub area_en {
  my $self = shift;
  return %area_en;
}

=item C<< xml >>

Return data as xml.

=cut
sub xml{
  my $self = shift;
  my $XML = XML::Smart->new;
  $self->{xml}=$self->{data};
  $XML->{$_}= $self->{xml}{$_} for qw(short_forecasts seven_day_forecasts monthly_mean rising_time);
  return $XML->data(
    nometagen => 1,
    noheader => 1,
    nodtd => 1,
  );
}

=item C<< json >>

Return data as json.

=cut
sub json{
  my $self = shift;
  return to_json($self->{data});
}

=item C<< json_pretty >>

Pretty json.

=cut
sub json_pretty{
  my $self = shift;
  return to_json($self->{data},{pretty =>1});
}

=item C<< yaml >>

Return data as yaml.

=cut
sub yaml{
  my $self = shift;
  return Dump $self->{data};
}

=item C<< hash >>

Return a perl hash object.

  %hash = $weather->hash;

=cut
sub hash{
  my $self=shift;
  return $self->{data};
}

=back

=head1 SEE ALSO

L<https://github.com/dryman/Weather-TW>

and

L<XML::Smart>

=head1 AUTHOR

dryman, E<lt>idryman@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by dryman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut

sub _fetch{
  my $self = shift;
  my $url = shift;
  my $tree = new HTML::TreeBuilder;
  my %hash;
  my $response = LWP::UserAgent->new->request(
    HTTP::Request->new(GET => $url)
  );

  croak "Cannot fetch url $url\n" unless $response->is_success;
  croak "Content is empty in $url\n" unless $response->content;
  $tree->parse(decode("big5",$response->content)) and $tree->eof;

  my @tables = $tree->find_by_attribute('class','datatable');
  $hash{short_forecasts} = [{forecast => $self->_short_forecasts(shift @tables)}];
  $hash{seven_day_forecasts} = [{area => $self->_seven_day_forecasts(shift @tables)}];
  if (scalar @tables == 3){
    my $areas = $self->_seven_day_forecasts(shift @tables);
    my $ref = $hash{seven_day_forecasts}[0]{area};
    push @{$ref},@{$areas};
  }
  $hash{monthly_mean} = $self->_monthly_mean(shift @tables);
  $hash{rising_time} = $self->_rising_time(shift @tables);

  $self->{data}=\%hash;
}

sub _monthly_mean{
  my ($self,$table)=@_;
  my @ths = $table->find('th');
  my $zh = $self->{lang} eq 'zh';
  my $th = shift @ths;
  my %hash;
  @hash{qw(month max_temp min_temp rain_mm)}=
    (
      $th->as_text,
      map {$_->as_text} $table->find('td'),
    );
  return \%hash;
}
sub _rising_time{
  my ($self,$table)=@_;
  my %hash;
  @hash{qw(sunrise sunset moonrise roonset)}= map{$_->as_text} $table->find('td');
  return \%hash;
}

sub _short_forecasts {
  my ($self, $table) = @_;
  my $zh = $self->{lang} eq 'zh';
  my @forecasts=();
  my @trs = $table->find('tr');
  shift @trs;
  foreach my $tr (@trs){
    my %forecast;
    my $img;
    my @children = $tr->content_list;
    $forecast{time}    = (shift @children)->as_text;
    $forecast{temp}    = (shift @children)->as_text;
    $forecast{weather} = (${(shift @children)->content}[0])->attr('title');
    $forecast{confort} = (shift @children)->as_text;
    $forecast{rain}    = (shift @children)->as_text;

    push @forecasts, \%forecast;
  }
  return \@forecasts;
}
sub _seven_day_forecasts{
  my ($self, $table) = @_;
  my @areas = ();
  my @trs = $table->find('tr');
  my @dates = map {$_->as_text} (shift @trs)->find('th');
  shift @dates;

  foreach my $tr (@trs){
    my %area=();
    my @forecasts=();
    my @ths = map{$_->as_text}$tr->find('th');
    $area{name}=$ths[0];
    my @tds = $tr->find('td');
    croak "There should be seven days in a weak!" unless 7 == scalar @tds;

    foreach my $i (0..6){
      my @imgs = $tds[$i]->find('img');
      my $img = shift @imgs;
      push @forecasts, {
        date => $dates[$i],
        weather => $img->attr('title'),
        temp => $tds[$i]->as_text,
      };
    }
    $area{forecast}=\@forecasts;
    push @areas,\%area;
  }
  return \@areas;
}

1;
__END__
