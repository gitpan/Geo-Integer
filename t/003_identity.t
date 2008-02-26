# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 561;

BEGIN { use_ok( 'Geo::Integer' ); }

my $gint=Geo::Integer->new();
isa_ok ($gint, 'Geo::Integer');

foreach (1704402877 .. 1704402887) {
  my ($i1, $i2)=$gint->unlace($_);
  is($gint->int_lat($gint->lat_int($i1)), $i1,     "gint->lat_int $i1");
  is($gint->int_lon($gint->lon_int($i2)), $i2,     "gint->lon_int $i2");
  is($gint->interlace($gint->unlace($_)), $_,      "gint->interlace $_");
  is($gint->integer($gint->ll($_)),       $_,      "gint->interlace $_");
  is($gint->integer($gint->center($_)),   $_,      "gint->interlace $_");
}

foreach my $dlat (-25, 37, 40) {
  foreach my $dlon (21, -77, -120) {
    foreach (0 .. 27) {
      my $lat = $dlat + $_ / 27;
      my $lon = $dlon + $_ / 27;
      my ($lat1, $lon1) = $gint->ll($gint->integer($lat, $lon));
      my ($lat2, $lon2) = $gint->ur($gint->integer($lat, $lon));
      is(($lat >= $lat1 and $lat < $lat2), 1, "gint->integer($lat, $lon)");
      is(($lon >= $lon1 and $lon < $lon2), 1, "gint->integer($lat, $lon)");
    }
  }
}
