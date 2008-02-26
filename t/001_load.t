# -*- perl -*-

# t/001_load.t - check module loading

use Test::More tests => 2;

BEGIN { use_ok( 'Geo::Integer' ); }

my $gint=Geo::Integer->new ();
isa_ok($gint, 'Geo::Integer');
