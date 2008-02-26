# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 35;

BEGIN { use_ok( 'Geo::Integer' ); }

my $gint=Geo::Integer->new();
isa_ok ($gint, 'Geo::Integer');

is($gint->int_lat( -90), "0",              '$gint->int_lat( -90)');
is($gint->int_lat(   0), int((2**16)/2), '$gint->int_lat(   0)');
is($gint->int_lat(  90), 2**16-1,          '$gint->int_lat(  90)');
is($gint->int_lat(  90 - 1e-6), 2**16-1,          '$gint->int_lat(  90)');
is($gint->int_lon(-180), "0",              '$gint->int_lat(-180)');
is($gint->int_lon(   0), int((2**16)/2), '$gint->int_lat(   0)');
is($gint->int_lon( 180), 0,          '$gint->int_lat( 180)');
is($gint->int_lon( 180 - 1e-6), 2**16-1,          '$gint->int_lat( 180)');

is($gint->interlace(0, 0), "0", '$gint->interlace');
is($gint->interlace(1, 1), "3", '$gint->interlace');
is($gint->interlace(1, 0), "1", '$gint->interlace');
is($gint->interlace(0, 1), "2", '$gint->interlace');
is($gint->interlace(4, 0), "16", '$gint->interlace');
is($gint->interlace(3, 3), "15", '$gint->interlace');
is($gint->interlace(4, 4), "48", '$gint->interlace');
is($gint->interlace(2**16-1,2**16-1), 2**32-1, '$gint->interlace');

foreach my $e (0 .. 16) {
  my $i=2 ** $e;
  is($gint->interlace($i-1,$i-1), $i**2-1, '$gint->interlace'. " I: $i");
}
