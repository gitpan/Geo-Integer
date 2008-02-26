# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 22;

BEGIN { use_ok( 'Geo::Integer' ); }

my $gint=Geo::Integer->new();
isa_ok ($gint, 'Geo::Integer');

is($gint->lat_int(0), "-90",          '$gint->lat_int(0)');
is($gint->lat_int(int(2**16/2)), "0", '$gint->int_lat(   0)');
is($gint->lat_int(2**16-1), 90 - 180/2**16,       '$gint->int_lat(  90)');
is($gint->lon_int(0), -180,        '$gint->int_lat(   0)');
is($gint->lon_int(2**16-1), 180 - 360/2**16,      '$gint->int_lat( 180)');
is($gint->lon_int(2**16), 180,          '$gint->int_lat( 180)');

my @int=();
@int=$gint->unlace(0);
is($int[0], "0", '$gint->unlace');
is($int[1], "0", '$gint->unlace');
@int=$gint->unlace(3);
is($int[0], "1", '$gint->unlace');
is($int[1], "1", '$gint->unlace');
@int=$gint->unlace(1);
is($int[0], "1", '$gint->unlace');
is($int[1], "0", '$gint->unlace');
@int=$gint->unlace(2);
is($int[0], "0", '$gint->unlace');
is($int[1], "1", '$gint->unlace');
@int=$gint->unlace(16);
is($int[0], "4", '$gint->unlace');
is($int[1], "0", '$gint->unlace');
@int=$gint->unlace(15);
is($int[0], "3", '$gint->unlace');
is($int[1], "3", '$gint->unlace');
@int=$gint->unlace(2**32-1);
is($int[0], 2**16-1, '$gint->unlace');
is($int[1], 2**16-1, '$gint->unlace');

#foreach my $e (0 .. 16) {
#  my $i=2 ** ($e * 2) - 1;
#  my @int=$gint->unlace($i);
#  is($int[0], 2**$e - 1, '$gint->unlace');
#  is($int[1], 2**$e - 1, '$gint->unlace');
#}
