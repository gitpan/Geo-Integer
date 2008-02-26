package Geo::Integer;
use strict;

BEGIN {
    use vars qw($VERSION);
    $VERSION     = '0.02';
}

=head1 NAME

Geo::Integer - Generates a single integer from Lat and Lon coordinates

=head1 SYNOPSIS

  use Geo::Integer;
  my $gi=Geo::Integer->new(); 
  my $integer=$gint->integer($lat, $lon);
  my ($lat, $lon)=$gint->center($int);

=head1 DESCRIPTION

This module generates a 32-bit integer which represents a two dimensional value.
The defaults are latitude and longitude in degrees but there should be no limitation for using any Cartesian grid.
The integer returned actually represents a rectangular area like the image below.

  ul ---------------- ur
  |....................|
  |....................|
  |.......center.......|
  |....................|
  |....................|
  ll ---------------- lr

By definition the center and ll values are "in" the rectangle.  ul, ur and lr are by definition "in" adjacent rectangles.

=head1 USAGE

=head1 CONSTRUCTOR

=head2 new

  my $obj = Geo::Integer->new();
  my $obj = Geo::Integer->new(latmin   =>  -90,   #defaults
                              lonmin   => -180,
                              latrange =>  180,
                              lonrange =>  360 );

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self = shift();
  %$self=@_;
  $self->{'latmin'}  = -90 unless defined $self->{'latmin'};
  $self->{'lonmin'}  =-180 unless defined $self->{'lonmin'};
  $self->{'latrange'}= 180 unless defined $self->{'latrange'};
  $self->{'lonrange'}= 360 unless defined $self->{'lonrange'};
}

=head2 integer

Returns a 32-bit integer representing a rectangle that contains the given coordinates.

  my $integer=$gint->integer($lat, $lon);

=cut

sub integer {
  my $self=shift;
  my ($lat, $lon) = @_;
  my $integer=$self->interlace($self->int_lat($lat), $self->int_lon($lon));
  return $integer;
}

=head2 center

Returns the center of the rectangle given the integer.

  my $center=$gint->center($integer);

=cut

sub center {
  my $self=shift;
  my $int=shift;
  my @ll=$self->ll($int);
  my @ur=$self->ur($int);
  return (($ll[0]+$ur[0])/2, ($ll[1]+$ur[1])/2);
}

=head2 ll

Returns the lower left coordinate of the retangle given the integer.

  my ($lat, $lon)=$gint->ll($int);

=cut

sub ll {
  my $self=shift;
  my $int=shift;
  my @int=$self->unlace($int);
  return $self->lat_int($int[0]), $self->lon_int($int[1]);
}

=head2 ul

Returns the upper left coordinate of the retangle given the integer.

  my ($lat, $lon)=$gint->ul($int);

=cut

sub ul {
  my $self=shift();
  my $int=shift;
  my @int=$self->unlace($int);
  return $self->lat_int($int[0] + 1), $self->lon_int($int[1]);
}

=head2 ur

Returns the upper right coordinate of the retangle given the integer.

  my ($lat, $lon)=$gint->ur($int);

=cut

sub ur {
  my $self=shift;
  my $int=shift;
  my @int=$self->unlace($int);
  return $self->lat_int($int[0] + 1), $self->lon_int($int[1] + 1);
}

=head2 lr

Returns the lower right coordinate of the retangle given the integer.

  my ($lat, $lon)=$gint->lr($int);

=cut

sub lr {
  my $self=shift();
  my $int=shift;
  my @int=$self->unlace($int);
  return $self->lat_int($int[0]), $self->lon_int($int[1] + 1);
}

=head1 METHODS - Internal (coordinates to integer)

=head2 interlace

Returns a single 32-bit integer from two 16-bit integers.

  my $int32=$gint->interlace($int16l, $int16h);

=cut

sub interlace {
  my $self=shift;
  my $i1=shift;
  my $i2=shift;
  my $v1=unpack("b16", pack("S", $i1));  #0000000000000000 to 1111111111111111
  my $v2=unpack("b16", pack("S", $i2));  #0000000000000000 to 1111111111111111

  my @odd =grep     {$_ % 2} (0 .. 31);
  my @even=grep {not $_ % 2} (0 .. 31);

  my @out=();
  @out[@even]=split(//, $v1);   #slice assignemnt  #0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
  @out[@odd ]=split(//, $v2);   #slice assignemnt  #00000000000000000000000000000000

  my $out=unpack("L", pack("b32", join("", @out)));  #32 bit long integer
  return $out;
}

=head2 int_lat

Returns 16-bit integer from a latitude.

=cut

sub int_lat {
  my $self=shift;
  my $lat=shift;  #-90 <= $lat < 90  becomes  0 <= $int <= 2^16 - 1
  my $int=int(($lat - $self->{'latmin'})/$self->{'latrange'} * 2 ** 16);
  $int = 2**16 - 1 if $int >= 2 ** 16;   #trunc at top
  return $int;
}

=head2 int_lon

Returns 16-bit integer from a longitude.

=cut

sub int_lon {
  my $self=shift;
  my $lon=shift;
  my $int=int(($lon - $self->{'lonmin'})/$self->{'lonrange'} * 2 ** 16);
  $int=$int % 2 ** 16 if $int >= 2 ** 16; #wrap around
  return $int;
}

=head1 METHODS - Internal (integer to coordinates)

=head2 unlace

Returns two 16-bit integers from a single 32-bit integer.

  my ($int16l, $int16h)=gint->unlace($int32);

=cut

sub unlace {
  my $self=shift;
  my $int=shift;
  my @int=split(//, unpack("b32", pack("L", $int)));
  my @even=grep {($_ % 2) == 0} (0 .. 31);
  my @odd =grep {($_ % 2) == 1} (0 .. 31);
  my @v1=@int[@even];
  my @v2=@int[@odd ];

  my $v1=unpack("S", pack("b16", join("", @v1)));  #0000000000000000 to 1111111111111111
  my $v2=unpack("S", pack("b16", join("", @v2)));  #0000000000000000 to 1111111111111111
  return $v1, $v2;
}

=head2 lat_int

Returns latitude from a 16-bit integer.

=cut

sub lat_int {
  my $self=shift;
  my $int=shift;
  return $int / 2 ** 16 * $self->{'latrange'} + $self->{'latmin'};
}

=head2 lon_int

Returns longitude from a 16-bit integer.

=cut

sub lon_int {
  my $self=shift;
  my $int=shift;
  return $int / 2 ** 16 * $self->{'lonrange'} + $self->{'lonmin'};
}

=head1 BUGS

=head1 SUPPORT

Try geo-perl email list

=head1 AUTHOR

    Michael R. Davis
    CPAN ID: MRDVT
    account=>perl,tld=>com,domain=>michaelrdavis

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 SEE ALSO

L<Geo::Approx>

=cut

1;
