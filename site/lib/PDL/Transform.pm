
#
# GENERATED WITH PDL::PP! Don't modify!
#
package PDL::Transform;

@EXPORT_OK  = qw( apply invert map PDL::PP map unmap t_inverse t_compose t_wrap t_identity t_lookup t_linear t_scale t_offset  t_rot t_fits t_code  t_cylindrical t_radial t_quadratic t_cubic t_quadratic t_spherical t_projective );
%EXPORT_TAGS = (Func=>[@EXPORT_OK]);

use PDL::Core;
use PDL::Exporter;
use DynaLoader;



   
   @ISA    = ( 'PDL::Exporter','DynaLoader' );
   push @PDL::Core::PP, __PACKAGE__;
   bootstrap PDL::Transform ;





=head1 NAME

PDL::Transform - Coordinate transforms, image warping, and N-D functions

=head1 SYNOPSIS

use PDL::Transform;

 my $t = new PDL::Transform::<type>(<opt>)

 $out = $t->apply($in)  # Apply transform to some N-vectors (Transform method)
 $out = $in->apply($t)  # Apply transform to some N-vectors (PDL method)

 $im1 = $t->map($im);   # Transform image coordinates (Transform method)
 $im1 = $im->map($t);   # Transform image coordinates (PDL method)

 $t2 = $t->compose($t1);  # compose two transforms
 $t2 = $t x $t1;          # compose two transforms (by analogy to matrix mult.)

 $t3 = $t2->inverse();    # invert a transform
 $t3 = !$t2;              # invert a transform (by analogy to logical "not")

=head1 DESCRIPTION

PDL::Transform is a convenient way to represent coordinate
transformations and resample images.  It embodies functions mapping
R^N -> R^M, both with and without inverses.  Provision exists for
parametrizing functions, and for composing them.  You can use this
part of the Transform object to keep track of arbitrary functions
mapping R^N -> R^M with or without inverses.

The simplest way to use a Transform object is to transform vector
data between coordinate systems.  The L<apply|/apply> method
accepts a PDL whose 0th dimension is coordinate index (all other
dimensions are threaded over) and transforms the vectors into the new
coordinate system.

Transform also includes image resampling, via the L<map|/map> method.
You define a coordinate transform using a Transform object, then use
it to remap an image PDL.  The output is a remapped, resampled image.

You can define and compose several transformations, then apply them
all at once to an image.  The image is interpolated only once, when
all the composed transformations are applied.

In keeping with standard practice, but somewhat counterintuitively,
the L<map|/map> engine uses the inverse transform to map coordinates
FROM the destination dataspace (or image plane) TO the source dataspace;
hence PDL::Transform keeps track of both the forward and inverse transform.

For terseness and convenience, most of the constructors are exported
into the current package with the name C<< t_<transform> >>, so the following
(for example) are synonyms:

  $t = new PDL::Transform::Radial();  # Long way

  $t = t_radial();                    # Short way

Several math operators are overloaded, so that you can compose and
invert functions with expression syntax instead of method syntax (see below).

=head1 EXAMPLE

Coordinate transformations and mappings are a little counterintuitive
at first.  Here are some examples of transforms in action:

   use PDL::Transform;
   $x = rfits('m51.fits');   # Substitute path if necessary!
   $ts = t_linear(Scale=>3); # Scaling transform

   $w = pgwin(xs);
   $w->imag($x);

   ## Grow m51 by a factor of 3; origin is at lower left.
   $y = $ts->map($x,{pix=>1});    # pix option uses direct pixel coord system
   $w->imag($y);

   ## Shrink m51 by a factor of 3; origin still at lower left.
   $c = $ts->unmap($x, {pix=>1});
   $w->imag($c);

   ## Grow m51 by a factor of 3; origin is at scientific origin.
   $d = $ts->map($x,$x->hdr);    # FITS hdr template prevents autoscaling
   $w->imag($d);

   ## Shrink m51 by a factor of 3; origin is still at sci. origin.
   $e = $ts->unmap($x,$x->hdr);
   $w->imag($e);

   ## A no-op: shrink m51 by a factor of 3, then autoscale back to size
   $f = $ts->map($x);            # No template causes autoscaling of output

=head1 OPERATOR OVERLOADS

=over 3

=item '!'

The bang is a unary inversion operator.  It binds exactly as
tightly as the normal bang operator.

=item 'x'

By analogy to matrix multiplication, 'x' is the compose operator, so these
two expressions are equivalent:

  $f->inverse()->compose($g)->compose($f) # long way
  !$f x $g x $f                           # short way

Both of those expressions are equivalent to the mathematical expression
f^-1 o g o f, or f^-1(g(f(x))).

=item '**'

By analogy to numeric powers, you can apply an operator a positive
integer number of times with the ** operator:

  $f->compose($f)->compose($f)  # long way
  $f**3                         # short way

=back

=head1 INTERNALS

Transforms are perl hashes.  Here's a list of the meaning of each key:

=over 3

=item func

Ref to a subroutine that evaluates the transformed coordinates.  It's
called with the input coordinate, and the "params" hash.  This
springboarding is done via explicit ref rather than by subclassing,
for convenience both in coding new transforms (just add the
appropriate sub to the module) and in adding custom transforms at
run-time. Note that, if possible, new C<func>s should support
L<inplace|PDL::Core/inplace> operation to save memory when the data are flagged
inplace.  But C<func> should always return its result even when
flagged to compute in-place.

C<func> should treat the 0th dimension of its input as a dimensional
index (running 0..N-1 for R^N operation) and thread over all other input
dimensions.

=item inv

Ref to an inverse method that reverses the transformation.  It must
accept the same "params" hash that the forward method accepts.  This
key can be left undefined in cases where there is no inverse.

=item idim, odim

Number of useful dimensions for indexing on the input and output sides
(ie the order of the 0th dimension of the coordinates to be fed in or
that come out).  If this is set to 0, then as many are allocated as needed.

=item name

A shorthand name for the transformation (convenient for debugging).
You should plan on using UNIVERAL::isa to identify classes of
transformation, e.g. all linear transformations should be subclasses
of PDL::Transform::Linear.  That makes it easier to add smarts to,
e.g., the compose() method.

=item itype

An array containing the name of the quantity that is expected from the
input piddle for the transform, for each dimension.  This field is advisory,
and can be left blank if there's no obvious quantity associated with
the transform.  This is analogous to the CTYPEn field used in FITS headers.

=item oname

Same as itype, but reporting what quantity is delivered for each
dimension.

=item iunit

The units expected on input, if a specific unit (e.g. degrees) is expected.
This field is advisory, and can be left blank if there's no obvious
unit associated with the transform.

=item ounit

Same as iunit, but reporting what quantity is delivered for each dimension.

=item params

Hash ref containing relevant parameters or anything else the func needs to
work right.

=item is_inverse

Bit indicating whether the transform has been inverted.  That is useful
for some stringifications (see the PDL::Transform::Linear
stringifier), and may be useful for other things.

=back

Transforms should be inplace-aware where possible, to prevent excessive
memory usage.

If you define a new type of transform, consider generating a new stringify
method for it.  Just define the sub "stringify" in the subclass package.
It should call SUPER::stringify to generate the first line (though
the PDL::Transform::Composition bends this rule by tweaking the
top-level line), then output (indented) additional lines as necessary to
fully describe the transformation.

=head1 NOTES

Transforms have a mechanism for labeling the units and type of each
coordinate, but it is just advisory.  A routine to identify and, if
necessary, modify units by scaling would be a good idea.  Currently,
it just assumes that the coordinates are correct for (e.g.)  FITS
scientific-to-pixel transformations.

Composition works OK but should probably be done in a more
sophisticated way so that, for example, linear transformations are
combined at the matrix level instead of just strung together
pixel-to-pixel.

=head1 MODULE INTERFACE

There are both operators and constructors.  The constructors are all
exported, all begin with "t_", and all return objects that are subclasses
of PDL::Transform.

The L<apply|/apply>, L<invert|/invert>, L<map|/map>,
and L<unmap|/unmap> methods are also exported to the C<PDL> package: they
are both Transform methods and PDL methods.

=cut







=head1 FUNCTIONS



=cut





=head2 apply

=for sig

  Signature: (data(); PDL::Transform t)

=for usage

  $out = $data->apply($t);
  $out = $t->apply($data);

=for ref

Apply a transformation to some input coordinates.

In the example, C<$t> is a PDL::Transform and C<$data> is a PDL to
be interpreted as a collection of N-vectors (with index in the 0th
dimension).  The output is a similar but transformed PDL.

For convenience, this is both a PDL method and a Transform method.

=cut

use Carp;

*PDL::apply = \&apply;
sub apply {
  my($me) = shift;
  my($from) = shift;

  if(UNIVERSAL::isa($me,'PDL')){
      my($x) = $from;
      $from = $me;
      $me = $x;
  }

  if(UNIVERSAL::isa($me,'PDL::Transform') && UNIVERSAL::isa($from,'PDL')){
      croak "Applying a PDL::Transform with no func! Oops.\n" unless(defined($me->{func}) and ref($me->{func}) eq 'CODE');
      my $result = &{$me->{func}}($from,$me->{params});
      $result->is_inplace(0); # clear inplace flag, just in case.
      return $result;
  } else {
      croak "apply requires both a PDL and a PDL::Transform.\n";
  }

}




=head2 invert

=for sig

  Signature: (data(); PDL::Transform t)

=for usage

  $out = $t->invert($data);
  $out = $data->invert($t);

=for ref

Apply an inverse transformation to some input coordinates.

In the example, C<$t> is a PDL::Transform and C<$data> is a piddle to
be interpreted as a collection of N-vectors (with index in the 0th
dimension).  The output is a similar piddle.

For convenience this is both a PDL method and a PDL::Transform method.

=cut

*PDL::invert = \&invert;
sub invert {
  my($me) = shift;
  my($data) = shift;

  if(UNIVERSAL::isa($me,'PDL')){
      my($x) = $data;
      $data = $me;
      $me = $x;
  }

  if(UNIVERSAL::isa($me,'PDL::Transform') && UNIVERSAL::isa($data,'PDL')){
      croak "Inverting a PDL::Transform with no inverse! Oops.\n" unless(defined($me->{inv}) and ref($me->{inv}) eq 'CODE');
      my $result = &{$me->{inv}}($data, $me->{params});
      $result->is_inplace(0);  # make sure inplace flag is clear.
      return $result;
  } else {
      croak("invert requires a PDL and a PDL::Transform (did you want 'inverse' instead?)\n");
  }
}





=head2 map

=for sig

  Signature: (k0(); SV *in; SV *out; SV *map; SV *boundary; SV *method;
                    SV *big; SV *blur; SV *sv_min; SV *flux; SV *bv)


=head2 match

=for usage

  $y = $x->match($c);                  # Match $c's header and size
  $y = $x->match([100,200]);           # Rescale to 100x200 pixels
  $y = $x->match([100,200],{rect=>1}); # Rescale and remove rotation/skew.

=for ref

Resample a scientific image to the same coordinate system as another.

The example above is syntactic sugar for

 $y = $x->map(t_identity, $c, ...);

it resamples the input PDL with the identity transformation in
scientific coordinates, and matches the pixel coordinate system to
$c's FITS header.

There is one difference between match and map: match makes the
C<rectify> option to C<map> default to 0, not 1.  This only affects
matching where autoscaling is required (i.e. the array ref example
above).  By default, that example simply scales $x to the new size and
maintains any rotation or skew in its scientific-to-pixel coordinate
transform.

=head2 map

=for usage

  $y = $x->map($xform,[<template>],[\%opt]); # Distort $x with transform $xform
  $y = $x->map(t_identity,[$pdl],[\%opt]); # rescale $x to match $pdl's dims.

=for ref

Resample an image or N-D dataset using a coordinate transform.

The data are resampled so that the new pixel indices are proportional
to the transformed coordinates rather than the original ones.

The operation uses the inverse transform: each output pixel location
is inverse-transformed back to a location in the original dataset, and
the value is interpolated or sampled appropriately and copied into the
output domain.  A variety of sampling options are available, trading
off speed and mathematical correctness.

For convenience, this is both a PDL method and a PDL::Transform method.

C<map> is FITS-aware: if there is a FITS header in the input data,
then the coordinate transform acts on the scientific coordinate system
rather than the pixel coordinate system.

By default, the output coordinates are separated from pixel coordinates
by a single layer of indirection.  You can specify the mapping between
output transform (scientific) coordinates to pixel coordinates using
the C<orange> and C<irange> options (see below), or by supplying a
FITS header in the template.

If you don't specify an output transform, then the output is
autoscaled: C<map> transforms a few vectors in the forward direction
to generate a mapping that will put most of the data on the image
plane, for most transformations.  The calculated mapping gets stuck in the
output's FITS header.

Autoscaling is especially useful for rescaling images -- if you specify
the identity transform and allow autoscaling, you duplicate the
functionality of L<rescale2d|PDL::Image2D/rescale2d>, but with more
options for interpolation.

You can operate in pixel space, and avoid autoscaling of the output,
by setting the C<nofits> option (see below).

The output has the same data type as the input.  This is a feature,
but it can lead to strange-looking banding behaviors if you use
interpolation on an integer input variable.

The C<template> can be one of:

=over 3

=item * a PDL

The PDL and its header are copied to the output array, which is then
populated with data.  If the PDL has a FITS header, then the FITS
transform is automatically applied so that $t applies to the output
scientific coordinates and not to the output pixel coordinates.  In
this case the NAXIS fields of the FITS header are ignored.

=item * a FITS header stored as a hash ref

The FITS NAXIS fields are used to define the output array, and the
FITS transformation is applied to the coordinates so that $t applies to the
output scientific coordinates.

=item * a list ref

This is a list of dimensions for the output array.  The code estimates
appropriate pixel scaling factors to fill the available space.  The
scaling factors are placed in the output FITS header.

=item * nothing

In this case, the input image size is used as a template, and scaling
is done as with the list ref case (above).

=back

OPTIONS:

The following options are interpreted:

=over 3

=item b, bound, boundary, Boundary (default = 'truncate')

This is the boundary condition to be applied to the input image; it is
passed verbatim to L<range|PDL::Slices/range> or
L<interpND|PDL::Primitive/interpND> in the sampling or interpolating
stage.  Other values are 'forbid','extend', and 'periodic'.  You can
abbreviate this to a single letter.  The default 'truncate' causes the
entire notional space outside the original image to be filled with 0.

=item pix, Pixel, nf, nofits, NoFITS (default = 0)

If you set this to a true value, then FITS headers and interpretation
are ignored; the transformation is treated as being in raw pixel coordinates.

=item j, J, just, justify, Justify (default = 0)

If you set this to 1, then output pixels are autoscaled to have unit
aspect ratio in the output coordinates.  If you set it to a non-1
value, then it is the aspect ratio between the first dimension and all
subsequent dimensions -- or, for a 2-D transformation, the scientific
pixel aspect ratio.  Values less than 1 shrink the scale in the first
dimension compared to the other dimensions; values greater than 1
enlarge it compared to the other dimensions.  (This is the same sense
as in the L<PGPLOT|PDL::Graphics::PGPLOT> interface.)

=item ir, irange, input_range, Input_Range

This is a way to modify the autoscaling.  It specifies the range of
input scientific (not necessarily pixel) coordinates that you want to be
mapped to the output image.  It can be either a nested array ref or
a piddle.  The 0th dim (outside coordinate in the array ref) is
dimension index in the data; the 1st dim should have order 2.
For example, passing in either [[-1,2],[3,4]] or pdl([[-1,2],[3,4]])
limites the map to the quadrilateral in input space defined by the
four points (-1,3), (-1,4), (2,4), and (2,3).

As with plain autoscaling, the quadrilateral gets sparsely sampled by
the autoranger, so pathological transformations can give you strange
results.

This parameter is overridden by C<orange>, below.

=item or, orange, output_range, Output_Range

This sets the window of output space that is to be sampled onto the
output array.  It works exactly like C<irange>, except that it specifies
a quadrilateral in output space.  Since the output pixel array is itself
a quadrilateral, you get pretty much exactly what you asked for.

This parameter overrides C<irange>, if both are specified.  It forces
rectification of the output (so that scientific axes align with the pixel
grid).

=item r, rect, rectify

This option defaults TRUE and controls how autoscaling is performed.  If
it is true or undefined, then autoscaling adjusts so that pixel coordinates
in the output image are proportional to individual scientific coordinates.
If it is false, then autoscaling automatically applies the inverse of any
input FITS transformation *before* autoscaling the pixels.  In the special
case of linear transformations, this preserves the rectangular shape of the
original pixel grid and makes output pixel coordinate proportional to input
coordinate.

=item m, method, Method

This option controls the interpolation method to be used.
Interpolation greatly affects both speed and quality of output.  For
most cases the option is directly passed to
L<interpND|PDL::Primitive/interpnd> for interpolation.  Possible
options, in order from fastest to slowest, are:

=over 3


=item * s, sample (default for ints)

Pixel values in the output plane are sampled from the closest data value
in the input plane.  This is very fast but not very accurate for either
magnification or decimation (shrinking).  It is the default for templates
of integer type.

=item * l, linear (default for floats)

Pixel values are linearly interpolated from the closest data value in the
input plane.  This is reasonably fast but only accurate for magnification.
Decimation (shrinking) of the image causes aliasing and loss of photometry
as features fall between the samples.  It is the default for floating-point
templates.

=item * c, cubic

Pixel values are interpolated using an N-cubic scheme from a 4-pixel
N-cube around each coordinate value.  As with linear interpolation,
this is only accurate for magnification.

=item * f, fft

Pixel values are interpolated using the term coefficients of the
Fourier transform of the original data.  This is the most appropriate
technique for some kinds of data, but can yield undesired "ringing" for
expansion of normal images.  Best suited to studying images with
repetitive or wavelike features.

=item * h, hanning

Pixel values are filtered through a spatially-variable filter tuned to
the computed Jacobian of the transformation, with hanning-window
(cosine) pixel rolloff in each dimension.  This prevents aliasing in the
case where the image is distorted or shrunk, but allows small amounts
of aliasing at pixel edges wherever the image is enlarged.

=item * g, gaussian, j, jacobian

Pixel values are filtered through a spatially-variable filter tuned to
the computed Jacobian of the transformation, with radial Gaussian
rolloff.  This is the most accurate resampling method, in the sense of
introducing the fewest artifacts into a properly sampled data set.
This method uses a lookup table to speed up calculation of the Gaussian
weighting.

=item * G

This method works exactly like 'g' (above), except that the Gaussian
values are computed explicitly for every sample -- which is considerably
slower.

=back

=item blur, Blur (default = 1.0)

This value scales the input-space footprint of each output pixel in
the gaussian and hanning methods. It's retained for historical
reasons.  Larger values yield blurrier images; values significantly
smaller than unity cause aliasing.  The parameter has slightly
different meanings for Gaussian and Hanning interpolation.  For
Hanning interpolation, numbers smaller than unity control the
sharpness of the border at the edge of each pixel (so that blur=>0 is
equivalent to sampling for non-decimating transforms).  For
Gaussian interpolation, the blur factor parameter controls the
width parameter of the Gaussian around the center of each pixel.

=item sv, SV (default = 1.0)

This value lets you set the lower limit of the transformation's
singular values in the hanning and gaussian methods, limiting the
minimum radius of influence associated with each output pixel.  Large
numbers yield smoother interpolation in magnified parts of the image
but don't affect reduced parts of the image.

=item big, Big (default = 0.5)

This is the largest allowable input spot size which may be mapped to a
single output pixel by the hanning and gaussian methods, in units of
the largest non-thread input dimension.  (i.e. the default won't let
you reduce the original image to less than 5 pixels across).  This places
a limit on how long the processing can take for pathological transformations.
Smaller numbers keep the code from hanging for a long time; larger numbers
provide for photometric accuracy in more pathological cases.  Numbers larer
than 1.0 are silly, because they allow the entire input array to be compressed
into a region smaller than a single pixel.

Wherever an output pixel would require averaging over an area that is too
big in input space, it instead gets NaN or the bad value.

=item phot, photometry, Photometry

This lets you set the style of photometric conversion to be used in the
hanning or gaussian methods.  You may choose:

=over 3

=item * 0, s, surf, surface, Surface (default)

(this is the default): surface brightness is preserved over the transformation,
so features maintain their original intensity.  This is what the sampling
and interpolation methods do.

=item * 1, f, flux, Flux

Total flux is preserved over the transformation, so that the brightness
integral over image regions is preserved.  Parts of the image that are
shrunk wind up brighter; parts that are enlarged end up fainter.

=back

=back

VARIABLE FILTERING:

The 'hanning' and 'gaussian' methods of interpolation give
photometrically accurate resampling of the input data for arbitrary
transformations.  At each pixel, the code generates a linear
approximation to the input transformation, and uses that linearization
to estimate the "footprint" of the output pixel in the input space.
The output value is a weighted average of the appropriate input spaces.

A caveat about these methods is that they assume the transformation is
continuous.  Transformations that contain discontinuities will give
incorrect results near the discontinuity.  In particular, the 180th
meridian isn't handled well in lat/lon mapping transformations (see
L<PDL::Transform::Cartography>) -- pixels along the 180th meridian get
the average value of everything along the parallel occupied by the
pixel.  This flaw is inherent in the assumptions that underly creating
a Jacobian matrix.  Maybe someone will write code to work around it.
Maybe that someone is you.

BAD VALUES:

If your PDL was compiled with bad value support, C<map()> supports
bad values in the data array.  Bad values in the input array are
propagated to the output array.  The 'g' and 'h' methods will do some
smoothing over bad values:  if more than 1/3 of the weighted input-array
footprint of a given output pixel is bad, then the output pixel gets marked
bad.



=for bad

map does not process bad values.
It will set the bad-value flag of all output piddles if the flag is set for any of the input piddles.


=cut





sub PDL::match {
  # Set default for rectification to 0 for simple matching...
  if( ref($_[$#_]) ne 'HASH' ) {
      push(@_,{})
  }
  my @k = grep(m/^r(e(c(t)?)?)?/,keys %{$_[$#_]});
  unless(@k) {
      $_[$#_]->{rectify} = 0;
  }
  t_identity()->map(@_);
}


*PDL::map = \&map;
sub map {
  my($me) = shift;
  my($in) = shift;

  if(UNIVERSAL::isa($me,'PDL') && UNIVERSAL::isa($in,'PDL::Transform')) {
      my($x) = $in;
      $in = $me;
      $me = $x;
  }

  barf ("PDL::Transform::map: source is not defined or is not a PDL\n")
    unless(defined $in and  UNIVERSAL::isa($in,'PDL'));

  barf ("PDL::Transform::map: source is empty\n")
    unless($in->nelem);

  my($tmp) = shift;
  my($opt) = shift;

  # Check for options-but-no-template case
  if(ref $tmp eq 'HASH' && !(defined $opt)) {
    if(!defined($tmp->{NAXIS})) {  # FITS headers all have NAXIS.
      $opt = $tmp;
      $tmp = undef;
    }
  }

  croak("PDL::Transform::map: Option 'p' was ambiguous and has been removed. You probably want 'pix' or 'phot'.") if exists($opt->{'p'});

  $tmp = [$in->dims]  unless(defined($tmp));

  # Generate an appropriate output piddle for values to go in
  my($out);
  my(@odims);
  my($ohdr);
  if(UNIVERSAL::isa($tmp,'PDL')) {
    @odims = $tmp->dims;

    my($x);
    if(defined ($x = $tmp->gethdr)) {
      my(%b) = %{$x};
      $ohdr = \%b;
    }
  } elsif(ref $tmp eq 'HASH') {
    # (must be a fits header -- or would be filtered above)
    for my $i(1..$tmp->{NAXIS}){
      push(@odims,$tmp->{"NAXIS$i"});
    }
    # deep-copy fits header into output
    my %foo = %{$tmp};
    $ohdr = \%foo;
  } elsif(ref $tmp eq 'ARRAY') {
    @odims = @$tmp;
  } else {
    barf("map: confused about dimensions of the output array...\n");
  }

  if(scalar(@odims) < scalar($in->dims)) {
    my @idims = $in->dims;
    push(@odims, splice(@idims,scalar(@odims)));
  }

  $out = PDL::new_from_specification('PDL',$in->type,@odims);
  $out->sethdr($ohdr) if defined($ohdr);

  if($PDL::Bad::Status) {
    # set badflag on output all the time if possible, to account for boundary violations
    $out->badflag(1);
  }

  ##############################
  ## Figure out the dimensionality of the
  ## transform itself (extra dimensions come along for the ride)
  my $nd = $me->{odim} || $me->{idim} || 2;
  my @sizes = $out->dims;
  my @dd = @sizes;

  splice @dd,$nd; # Cut out dimensions after the end

  # Check that there are elements in the output fields...
  barf "map: output has no dims!\n"
        unless(@dd);
  my $ddtotal = 1;
  map {$ddtotal *= $_} @dd;
  barf "map: output has no elements (at least one dim is 0)!\n"
     unless($ddtotal);


  ##############################
  # If necessary, generate an appropriate FITS header for the output.

  my $nofits = _opt($opt, ['nf','nofits','NoFITS','pix','pixel','Pixel']);

  ##############################
  # Autoscale by transforming a subset of the input points' coordinates
  # to the output range, and pick a FITS header that fits the output
  # coordinates into the given template.
  #
  # Autoscaling always produces a simple, linear mapping in the FITS header.
  # We support more complex mappings (via t_fits) but only to match a pre-existing
  # FITS header (which doesn't use autoscaling).
  #
  # If the rectify option is set (the default) then the image is rectified
  # in scientific coordinates; if it is clear, then the existing matrix
  # is used, preserving any shear or rotation in the coordinate system.
  # Since we eschew CROTA whenever possible, the CDi_j formalism is used instead.
  my $f_in = (defined($in->hdr->{NAXIS}) ? t_fits($in,{ignore_rgb=>1}) : t_identity());

  unless((defined $out->gethdr && $out->hdr->{NAXIS})  or  $nofits) {
      print "generating output FITS header..." if($PDL::Transform::debug);

      $out->sethdr($in->hdr_copy) # Copy extraneous fields...
        if(defined $in->hdr);

      my $samp_ratio = 300;

      my $orange = _opt($opt, ['or','orange','output_range','Output_Range'],
                        undef);

      my $omin;
      my $omax;
      my $osize;


      my $rectify = _opt($opt,['r','rect','rectify','Rectify'],1);


      if (defined $orange) {
          # orange always rectifies the coordinates -- the output scientific
          # coordinates *must* align with the axes, or orange wouldn't make
          # sense.
        print "using user's orange..." if($PDL::Transform::debug);
        $orange = pdl($orange) unless(UNIVERSAL::isa($orange,'PDL'));
        barf "map: orange must be 2xN for an N-D transform"
          unless ( (($orange->dim(1)) == $nd )
                   && $orange->ndims == 2);

        $omin = $orange->slice("(0)");
        $omax = $orange->slice("(1)");
        $osize = $omax - $omin;

        $rectify = 1;

      } else {

          ##############################
          # Real autoscaling happens here.

          if(!$rectify and ref( $f_in ) !~ /Linear/i) {
              if( $f_in->{name} ne 'identity' ) {
                 print STDERR "Warning: map can't preserve nonlinear FITS distortions while autoscaling.\n";
              }
              $rectify=1;
          }

          my $f_tr = ( $rectify ?
                       $me x $f_in :
                       (  ($me->{name} eq 'identity') ?  # Simple optimization for match()
                          $me :                          # identity -- just matching
                          !$f_in x $me x $f_in           # common case
                       )
                       );

          my $samps = (pdl(($in->dims)[0..$nd-1]))->clip(0,$samp_ratio);

          my $coords = ndcoords(($samps + 1)->list);

          my $t;
          my $irange = _opt($opt, ['ir','irange','input_range','Input_Range'],
                            undef);

          # If input range is defined, sample that quadrilateral -- else
          # sample the quad defined by the boundaries of the input image.
          if(defined $irange) {
              print "using user's irange..." if($PDL::Transform::debug);
              $irange = pdl($irange) unless(UNIVERSAL::isa($irange,'PDL'));
              barf "map: irange must be 2xN for an N-D transform"
                  unless ( (($irange->dim(1)) == $nd )
                           && $irange->ndims == 2);

              $coords *= ($irange->slice("(1)") - $irange->slice("(0)")) / $samps;
              $coords += $irange->slice("(0)");
              $coords -= 0.5; # offset to pixel corners...
              $t = $me;
          } else {
              $coords *= pdl(($in->dims)[0..$nd-1]) / $samps;
              $coords -= 0.5; # offset to pixel corners...
              $t = $f_tr;
          }
          my $ocoords = $t->apply($coords)->mv(0,-1)->clump($nd);

          # discard non-finite entries
          my $oc2  = $ocoords->range(
              which(
                  $ocoords->
                  xchg(0,1)->
                  sumover->
                  isfinite
              )
              ->dummy(0,1)
              );

          $omin = $oc2->minimum;
          $omax = $oc2->maximum;

          $osize = $omax - $omin;
          my $tosize;
          ($tosize = $osize->where($osize == 0)) .= 1.0;
      }

      my ($scale) = $osize / pdl(($out->dims)[0..$nd-1]);

      my $justify = _opt($opt,['j','J','just','justify','Justify'],0);
      if($justify) {
          my $tmp; # work around perl -d "feature"
          ($tmp = $scale->slice("0")) *= $justify;
          $scale .= $scale->max;
          $scale->slice("0") /= $justify;
      }

      print "done with autoscale. Making fits header....\n" if($PDL::Transform::debug);
      if( $rectify ) {
          # Rectified header generation -- make a simple coordinate header with no
          # rotation or skew.
          print "rectify\n" if($PDL::Transform::debug);
          for my $d(1..$nd) {
              $out->hdr->{"CRPIX$d"} = 1 + ($out->dim($d-1)-1)/2 ;
              $out->hdr->{"CDELT$d"} = $scale->at($d-1);
              $out->hdr->{"CRVAL$d"} = ( $omin->at($d-1) + $omax->at($d-1) ) /2 ;
              $out->hdr->{"NAXIS$d"} = $out->dim($d-1);
              $out->hdr->{"CTYPE$d"} = ( (defined($me->{otype}) ?
                                          $me->{otype}->[$d-1] : "")
                                         || $in->hdr->{"CTYPE$d"}
                                         || "");
              $out->hdr->{"CUNIT$d"} = ( (defined($me->{ounit}) ?
                                          $me->{ounit}->[$d-1] : "")
                                         || $in->hdr->{"CUNIT$d"}
                                         || $in->hdr->{"CTYPE$d"}
                                         || "");
          }
          $out->hdr->{"NAXIS"} = $nd;

          $out->hdr->{"SIMPLE"} = 'T';
          $out->hdr->{"HISTORY"} .= "Header written by PDL::Transform::Cartography::map";

          ### Eliminate fancy newfangled output header pointing tags if they exist
          ### These are the CROTA<n>, PCi_j, and CDi_j.
          for $k(keys %{$out->hdr})      {
              if( $k=~m/(^CROTA\d*$)|(^(CD|PC)\d+_\d+[A-Z]?$)/ ){
                  delete $out->hdr->{$k};
              }
          }
      } else {
          # Non-rectified output -- generate a CDi_j matrix instead of the simple formalism.
          # We have to deal with a linear transformation: we've got:  (scaling) x !input x (t x input),
          # where input is a linear transformation with offset and scaling is a simple scaling. We have
          # the scaling parameters and the matrix for !input -- we have only to merge them and then we
          # can write out the FITS header in CDi_j form.
          print "non-rectify\n" if($PDL::Transform::debug);
          my $midpoint_val = (pdl(($out->dims)[0..$nd-1])/2 * $scale)->apply( $f_in );
          print "midpoint_val is $midpoint_val\n" if($PDL::Transform::debug);
          # linear transformation
          unless(ref($f_in) =~ m/Linear/) {
              croak("Whups -- got a nonlinear t_fits transformation.  Can't deal with it.");
          }

          my $inv_sc_mat = zeroes($nd,$nd);
          $inv_sc_mat->diagonal(0,1) .= $scale;
          my $mat = $f_in->{params}->{matrix} x $inv_sc_mat;
          print "scale is $scale; mat is $mat\n" if($PDL::Transform::debug);

          print "looping dims 1..$nd: " if($PDL::Transform::debug);
          for my $d(1..$nd) {
              print "$d..." if($PDL::Transform::debug);
              $out->hdr->{"CRPIX$d"} = 1 + ($out->dim($d-1)-1)/2;
              $out->hdr->{"CRVAL$d"} = $midpoint_val->at($d-1);
              $out->hdr->{"NAXIS$d"} = $out->dim($d-1);
              $out->hdr->{"CTYPE$d"} = ( (defined($me->{otype}) ?
                                          $me->{otype}->[$d-1] : "")
                                         || $in->hdr->{"CTYPE$d"}
                                         || "");
              $out->hdr->{"CUNIT$d"} = ( (defined($me->{ounit}) ?
                                          $me->{ounit}->[$d-1] : "")
                                         || $in->hdr->{"CUNIT$d"}
                                         || $in->hdr->{"CTYPE$d"}
                                         || "");
              for my $e(1..$nd) {
                  $out->hdr->{"CD${d}_${e}"} = $mat->at($d-1,$e-1);
                  print "setting CD${d}_${e} to ".$mat->at($d-1,$e-1)."\n" if($PDL::Transform::debug);
              }
          }

          ## Eliminate competing header pointing tags if they exist
          for $k(keys %{$out->hdr}) {
              if( $k =~ m/(^CROTA\d*$)|(^(PC)\d+_\d+[A-Z]?$)|(CDELT\d*$)/ ) {
                  delete $out->hdr->{$k};
              }
          }
      }



    }

  $out->hdrcpy(1);

  ##############################
  # Sandwich the transform between the input and output plane FITS headers.
  unless($nofits) {
      $me = !(t_fits($out,{ignore_rgb=>1})) x $me x $f_in;
  }

  ##############################
  ## Figure out the interpND options
  my $method = _opt($opt,['m','method','Method'],undef);
  my $bound = _opt($opt,['b','bound','boundary','Boundary'],'t');


  ##############################
  ## Rubber meets the road: calculate the inverse transformed points.
  my $ndc = PDL::Basic::ndcoords(@dd);
  my $idx = $me->invert($ndc->double);

  barf "map: Transformation had no inverse\n" unless defined($idx);

  ##############################
  ## Integrate ?  (Jacobian, Gaussian, Hanning)
  my $integrate = ($method =~ m/^[jghJGH]/) if defined($method);

  ##############################
  ## Sampling code:
  ## just transform and interpolate.
  ##  ( Kind of an anticlimax after all that, eh? )
  if(!$integrate) {
    my $x = $in->interpND($idx,{method=>$method, bound=>$bound});
    my $tmp; # work around perl -d "feature"
    ($tmp = $out->slice(":")) .= $x; # trivial slice prevents header overwrite...
    return $out;
  }

  ##############################
  ## Anti-aliasing code:
  ## Condition the input and call the pixelwise C interpolator.
  ##

  barf("PDL::Transform::map: Too many dims in transformation\n")
        if($in->ndims < $idx->ndims-1);

  ####################
  ## Condition the threading -- pixelwise interpolator only threads
  ## in 1 dimension, so squish all thread dimensions into 1, if necessary
  my @iddims = $idx->dims;
  if($in->ndims == $#iddims) {
        $in2 = $in->dummy(-1,1);
  } else {
        $in2 = ( $in
                ->reorder($nd..$in->ndims-1, 0..$nd-1)
                ->clump($in->ndims - $nd)
                ->mv(0,-1)
               );
  }

  ####################
  # Allocate the output array
  my $o2 = PDL->new_from_specification($in2->type,
                                    @iddims[1..$#iddims],
                                    $in2->dim(-1)
                                   );

  ####################
  # Pack boundary string if necessary
  if(defined $bound) {
    if(ref $bound eq 'ARRAY') {
      my ($s,$el);
      foreach $el(@$bound) {
        barf "Illegal boundary value '$el' in range"
          unless( $el =~ m/^([0123fFtTeEpPmM])/ );
        $s .= $1;
      }
      $bound = $s;
    }
    elsif($bound !~ m/^[0123ftepx]+$/  && $bound =~ m/^([0123ftepx])/i ) {
      $bound = $1;
    }
  }

  ####################
  # Get the blur and minimum-sv values
  my $blur  =  _opt($opt,['blur','Blur'],1.0);
  my $svmin =  _opt($opt,['sv','SV'],1.0);
  my $big   =  _opt($opt,['big','Big'],1.0);
  my $flux  =  _opt($opt,['phot','photometry'],0);
  my @idims = $in->dims;

  $flux = ($flux =~ m/^[1fF]/);
  $big = $big * max(pdl(@idims[0..$nd]));
  $blur = $blur->at(0) if(ref $blur);
  $svmin =  $svmin->at(0)  if(ref $svmin);

  my $bv;
  if($PDL::Bad::Status  and $in->badflag){
      $bv = $in->badvalue;
  } else {
      $bv = 0;
  }

  ### The first argument is a dummy to set $GENERIC.
  $idx = double($idx) unless($idx->type == double);
  print "Calling _map_int...\n" if($PDL::Transform::debug);
  &PDL::_map_int( $in2->flat->index(0),
        $in2, $o2, $idx,
        $bound, $method, $big, $blur, $svmin, $flux, $bv);

  my @rdims = (@iddims[1..$#iddims], @idims[$#iddims..$#idims]);
  {
     my $tmp; # work around perl -d "feature"
     ($tmp = $out->slice(":")) .= $o2->reshape(@rdims);
  }
  return $out;
}



*map = \&PDL::map;




######################################################################

=head2 unmap

=for sig

 Signature: (data(); PDL::Transform a; template(); \%opt)

=for usage

  $out_image = $in_image->unmap($t,[<options>],[<template>]);
  $out_image = $t->unmap($in_image,[<options>],[<template>]);

=for ref

Map an image or N-D dataset using the inverse as a coordinate transform.

This convenience function just inverts $t and calls L<map|/map> on
the inverse; everything works the same otherwise.  For convenience, it
is both a PDL method and a PDL::Transform method.

=cut

*PDL::unmap = \&unmap;
sub unmap {
  my($me) = shift;
  my($data) = shift;
  my(@params) = @_;

  if(UNIVERSAL::isa($data,'PDL::Transform') && UNIVERSAL::isa($me,'PDL')) {
      my $x = $data;
      $data = $me;
      $me = $x;
  }

  return $me->inverse->map($data,@params);
}




=head2 t_inverse

=for usage

  $t2 = t_inverse($t);
  $t2 = $t->inverse;
  $t2 = $t ** -1;
  $t2 = !$t;

=for ref

Return the inverse of a PDL::Transform.  This just reverses the
func/inv, idim/odim, itype/otype, and iunit/ounit pairs.  Note that
sometimes you end up with a transform that cannot be applied or
mapped, because either the mathematical inverse doesn't exist or the
inverse func isn't implemented.

You can invert a transform by raising it to a negative power, or by
negating it with '!'.

The inverse transform remains connected to the main transform because
they both point to the original parameters hash.  That turns out to be
useful.

=cut

*t_inverse = \&inverse;

sub inverse {
  my($me) = shift;

  unless(defined($me->{inv})) {
    Carp::cluck("PDL::Transform::inverse:  got a transform with no inverse.\n");
    return undef;
  }

  my(%out) = %$me; # force explicit copy of top-level
  my($out) = \%out;

  $out->{inv}  = $me->{func};
  $out->{func} = $me->{inv};

  $out->{idim} = $me->{odim};
  $out->{odim} = $me->{idim};

  $out->{otype} = $me->{itype};
  $out->{itype} = $me->{otype};

  $out->{ounit} = $me->{iunit};
  $out->{iunit} = $me->{ounit};

  $out->{name} = "(inverse ".$me->{name}.")";

  $out->{is_inverse} = !($out->{is_inverse});

  bless $out,(ref $me);
  return $out;
}




=head2 t_compose

=for usage

  $f2 = t_compose($f, $g,[...]);
  $f2 = $f->compose($g[,$h,$i,...]);
  $f2 = $f x $g x ...;

=for ref

Function composition: f(g(x)), f(g(h(x))), ...

You can also compose transforms using the overloaded matrix-multiplication
(nee repeat) operator 'x'.

This is accomplished by inserting a splicing code ref into the C<func>
and C<inv> slots.  It combines multiple compositions into a single
list of transforms to be executed in order, fram last to first (in
keeping with standard mathematical notation).  If one of the functions is
itself a composition, it is interpolated into the list rather than left
separate.  Ultimately, linear transformations may also be combined within
the list.

No checking is done that the itype/otype and iunit/ounit fields are
compatible -- that may happen later, or you can implement it yourself
if you like.

=cut

@PDL::Transform::Composition::ISA = ('PDL::Transform');
sub PDL::Transform::Composition::stringify {
  package PDL::Transform::Composition;
  my($me) = shift;
  my($out) = SUPER::stringify $me;
  $out;
}

*t_compose = \&compose;

sub compose {
  local($_);
  my(@funcs) = @_;
  my($me) = PDL::Transform->new;

  # No inputs case: return the identity function
  return $me
    if(!@funcs);

  $me->{name} = "";
  my($f);
  my(@clist);

  for $f(@funcs) {

    $me->{idim} = $f->{idim} if($f->{idim} > $me->{idim});
    $me->{odim} = $f->{odim} if($f->{odim} > $me->{odim});

    if(UNIVERSAL::isa($f,"PDL::Transform::Composition")) {
      if($f->{is_inverse}) {
        for(reverse(@{$f->{params}->{clist}})) {
          push(@clist,$_->inverse);
          $me->{name} .= " o inverse ( ".$_->{name}." )";
        }
      } else {
        for(@{$f->{params}->{clist}}) {
          push(@clist,$_);
          $me->{name} .= " o ".$_->{name};
        }
      }
    } else {  # Not a composition -- just push the transform onto the list.
      push(@clist,$f);
      $me->{name} .= " o ".$f->{name};
    }
  }

  $me->{name}=~ s/^ o //; # Get rid of leading composition mark

  $me->{otype} = $funcs[0]->{otype};
  $me->{ounit} = $funcs[0]->{ounit};

  $me->{itype} = $funcs[-1]->{itype};
  $me->{iunit} = $funcs[-1]->{iunit};

  $me->{params}->{clist} = \@clist;

  $me->{func} = sub {
    my ($data,$p) = @_;
    my ($ip) = $data->is_inplace;
    for my $t ( reverse @{$p->{clist}} ) {
      croak("Error: tried to apply a PDL::Transform with no function inside a composition!\n  offending transform: $t\n")
          unless(defined($t->{func}) and ref($t->{func}) eq 'CODE');
      $data = $t->{func}($ip ? $data->inplace : $data, $t->{params});
    }
    $data->is_inplace(0); # clear inplace flag (avoid core bug with inplace)
    $data;
  };

  $me->{inv} = sub {
    my($data,$p) = @_;
    my($ip) = $data->is_inplace;
    for my $t ( @{$p->{clist}} ) {
      croak("Error: tried to invert a non-invertible PDL::Transform inside a composition!\n  offending transform: $t\n")
          unless(defined($t->{inv}) and ref($t->{inv}) eq 'CODE');
      $data = &{$t->{inv}}($ip ? $data->inplace : $data, $t->{params});
    }
    $data;
  };

  return bless($me,'PDL::Transform::Composition');
}




=head2 t_wrap

=for usage

  $g1fg = $f->wrap($g);
  $g1fg = t_wrap($f,$g);

=for ref

Shift a transform into a different space by 'wrapping' it with a second.

This is just a convenience function for two
L<t_compose|/t_compose> calls. C<< $x->wrap($y) >> is the same as
C<(!$y) x $x x $y>: the resulting transform first hits the data with
$y, then with $x, then with the inverse of $y.

For example, to shift the origin of rotation, do this:

  $im = rfits('m51.fits');
  $tf = t_fits($im);
  $tr = t_linear({rot=>30});
  $im1 = $tr->map($tr);               # Rotate around pixel origin
  $im2 = $tr->map($tr->wrap($tf));    # Rotate round FITS scientific origin

=cut

*t_wrap = \&wrap;

sub wrap {
  my($f) = shift;
  my($g) = shift;

  return $g->inverse->compose($f,$g);
}



######################################################################

# Composition operator -- handles 'x'.
sub _compose_op {
    my($x,$y,$c) = @_;
    $c ? compose($y,$x) : compose($x,$y);
}

# Raise-to-power operator -- handles '**'.

sub _pow_op {
    my($x,$y,$c) = @_;

    barf("%s", "Can't raise anything to the power of a transform")
        if($c || UNIVERSAL::isa($y,'PDL::Transform')) ;

    $x = $x->inverse
        if($y < 0);

    return $x if(abs($y) == 1);
    return new PDL::Transform if(abs($y) == 0);

    my(@l);
    for my $i(1..abs($y)) {
        push(@l,$x);
    }

    t_compose(@l);
}




=head2 t_identity

=for usage

  my $xform = t_identity
  my $xform = new PDL::Transform;

=for ref

Generic constructor generates the identity transform.

This constructor really is trivial -- it is mainly used by the other transform
constructors.  It takes no parameters and returns the identity transform.

=cut

sub _identity { return shift; }
sub t_identity { new PDL::Transform(@_) };

sub new {
  my($class) = shift;
  my $me = {name=>'identity',
            idim => 0,
            odim => 0,
            func=>\&PDL::Transform::_identity,
            inv=>\&PDL::Transform::_identity,
            params=>{}
          };

  return bless $me,$class;
}




=head2 t_lookup

=for usage

  $f = t_lookup($lookup, {<options>});

=for ref

Transform by lookup into an explicit table.

You specify an N+1-D PDL that is interpreted as an N-D lookup table of
column vectors (vector index comes last).  The last dimension has
order equal to the output dimensionality of the transform.

For added flexibility in data space, You can specify pre-lookup linear
scaling and offset of the data.  Of course you can specify the
interpolation method to be used.  The linear scaling stuff is a little
primitive; if you want more, try composing the linear transform with
this one.

The prescribed values in the lookup table are treated as
pixel-centered: that is, if your input array has N elements per row
then valid data exist between the locations (-0.5) and (N-0.5) in
lookup pixel space, because the pixels (which are numbered from 0 to
N-1) are centered on their locations.

Lookup is done using L<interpND|PDL::Primitive/interpnd>, so the boundary conditions
and threading behaviour follow from that.

The indexed-over dimensions come first in the table, followed by a
single dimension containing the column vector to be output for each
set of other dimensions -- ie to output 2-vectors from 2 input
parameters, each of which can range from 0 to 49, you want an index
that has dimension list (50,50,2).  For the identity lookup table
you could use  C<cat(xvals(50,50),yvals(50,50))>.

If you want to output a single value per input vector, you still need
that last index threading dimension -- if necessary, use C<dummy(-1,1)>.

The lookup index scaling is: out = lookup[ (scale * data) + offset ].

A simplistic table inversion routine is included.  This means that
you can (for example) use the C<map> method with C<t_lookup> transformations.
But the table inversion is exceedingly slow, and not practical for tables
larger than about 100x100.  The inversion table is calculated in its
entirety the first time it is needed, and then cached until the object is
destroyed.

Options are listed below; there are several synonyms for each.

=over 3

=item s, scale, Scale

(default 1.0) Specifies the linear amount of scaling to be done before
lookup.  You can feed in a scalar or an N-vector; other values may cause
trouble.  If you want to save space in your table, then specify smaller
scale numbers.

=item o, offset, Offset

(default 0.0) Specifies the linear amount of offset before lookup.
This is only a scalar, because it is intended to let you switch to
corner-centered coordinates if you want to (just feed in o=-0.25).

=item b, bound, boundary, Boundary

Boundary condition to be fed to L<interpND|PDL::Primitive/interpND>

=item m, method, Method

Interpolation method to be fed to L<interpND|PDL::Primitive/interpND>

=back

EXAMPLE

To scale logarithmically the Y axis of m51, try:

  $x = float rfits('m51.fits');
  $lookup = xvals(128,128) -> cat( 10**(yvals(128,128)/50) * 256/10**2.55 );
  $t = t_lookup($lookup);
  $y = $t->map($x);

To do the same thing but with a smaller lookup table, try:

  $lookup = 16 * xvals(17,17)->cat(10**(yvals(17,17)/(100/16)) * 16/10**2.55);
  $t = t_lookup($lookup,{scale=>1/16.0});
  $y = $t->map($x);

(Notice that, although the lookup table coordinates are is divided by 16,
it is a 17x17 -- so linear interpolation works right to the edge of the original
domain.)

NOTES

Inverses are not yet implemented -- the best way to do it might be by
judicious use of map() on the forward transformation.

the type/unit fields are ignored.

=cut

sub t_lookup {
  my($class) = 'PDL::Transform';
  my($source)= shift;
  my($o) = shift;

  if(!defined($o) && ((ref $source) eq 'HASH')) {
    Carp::cluck("lookup transform called as sub not method; using 'PDL::Transform' as class...\n");
    $o = $source;
    $source = $class;
    $class = "PDL::Transform";
  }

  $o = {} unless(ref $o eq 'HASH');

  my($me) = PDL::Transform::new($class);

  my($bound) = _opt($o,['b','bound','boundary','Boundary']);
  my($method)= _opt($o,['m','meth','method','Method']);

  $me->{idim} = $source->ndims - 1;
  $me->{odim} = $source->dim($source->ndims-1);

  $me->{params} = {
      table => $source,
      scale =>  _opt($o,['s','scale','Scale'],1.0),
      offset => _opt($o,['o','off','offset','Offset'],0.0),
      interpND_opt => {
        method => $method,
        bound =>  $bound,
        bad   => _opt($o,['bad'],0)
      }
    };


   my $lookup_func = sub {
     my($data,$p,$table,$scale,$offset) = @_;

    $data = pdl($data)
      unless ((ref $data) && (UNIVERSAL::isa($data,'PDL')));
      $main::foo = $data;

    if($data->dim(0) > $me->{idim}) {
      barf("Too many dims (".$data->dim(0).") for your table (".$me->{idim}.")\n");
    };

    my($x)= ($table
             ->interpND(float($data) * $scale + $offset,
                        $p->{interpND_opt}
                        )
             );


    # Put the index dimension (and threaded indices) back at the front of
    # the dimension list.
    my($dnd) = $data->ndims - 1;
    return ($x -> ndims > $data->ndims - 1) ?
      ($x->reorder( $dnd..($dnd + $table->ndims - $data->dim(0)-1)
                    , 0..$data->ndims-2
                    )
       ) : $x;
  };

  $me->{func} = sub {my($data,$p) = @_;  &$lookup_func($data,$p,$p->{table},$p->{scale},$p->{offset})};

  #######
  ## Lazy inverse -- find it if and only if we need it...
  $me->{inv} = sub {
      my $data = shift;
      my $p = shift;
      if(!defined($p->{'itable'})) {
        if($me->{idim} != $me->{odim}) {
         barf("t_lookup: can't calculate an inverse of a projection operation! (idim != odim)");
        }
       print "t_lookup: Warning, table inversion is only weakly supported.  \n   I'll try to invert it using a pretty boneheaded algorithm...\n  (If it takes too long, consider writing a faster algorithm!)\n   Calculating inverse table (will be cached)...\n" if($PDL::verbose || $PDL::debug || $PDL::Transform::debug);
        my $itable = zeroes($p->{table});
        my $minvals = $p->{table}->clump($me->{idim})->minimum;
        my $maxvals = $p->{table}->clump($me->{idim})->maximum;

        # Scale so that the range runs from 0 through the top pixel in the table
        my $scale = (  pdl(  $itable->dims  )->slice("0:-2")-1  ) /
                    (($maxvals - $minvals)+ (($maxvals-$minvals) == 0));
        my $offset = - ($minvals * $scale);

        $p->{iscale} = $scale;
        $p->{ioffset} = $offset;

        my $enl_scale = $p->{'enl_scale'} || 10;
        my $smallcoords = ndcoords((pdl($enl_scale * 2 + 1)->at(0)) x $me->{idim})/ $enl_scale - 1;

        # $oloop runs over (point, index) for all points in the output table, in
        # $p->{table} output space
        $oloop = ndcoords($itable->mv(-1,0)->slice("(0)"))->
            double->
            mv(0,-1)->
            clump($itable->ndims-1);  # oloop: (pixel, index)
        {
            my $tmp; # work around perl -d "feature"
            ($tmp = $oloop->mv(-1,0)) -= $offset;
            ($tmp = $oloop->mv(-1,0)) /= $scale;
        }

        # The Right Thing to do here is to take the outer product of $itable and $otable, then collapse
        # to find minimum distance.  But memory demands for that would be HUGE.  Instead we do an
        # elementwise calculation.

        print "t_lookup: inverting ".$oloop->dim(0)." points...\n" if($PDL::verbose || $PDL::debug || $PDL::Transform::debug);
        my $pt = $p->{table}->mv(-1,0); # pt runs (index, x,y,...)

        my $itable_flattened = zeroes($oloop);

        for $i(0..$oloop->dim(0)-1) {

            my $olp = $oloop->slice("($i)");                # olp runs (index)
            my $diff = ($pt - $olp);                 # diff runs (index, x, y, ...)
            my $r2 = ($diff * $diff)->sumover;       # r2 runs (x,y,...)
            my $c = whichND($r2==$r2->min)->slice(":,(0)"); # c runs (index)

            # Now zero in on the neighborhood around the point of closest approach.
            my $neighborhood = $p->{table}->interpND($c + $smallcoords,{method=>'linear',bound=>'t'})->
                     mv(-1,0); # neighborhood runs (index, dx, dy,...)
            $diff = $neighborhood - $olp;        # diff runs (index, dx, dy, ...)
            $r2 = ($diff * $diff)->sumover;      # r2 runs (dx,dy,...)
            my $dc = $smallcoords->mv(0,-1)->indexND(0+whichND($r2==$r2->min)->slice(":,(0)"));


            my $coord = $c + $dc;
            # At last, we've found the best-fit to an enl_scale'th of an input-table pixel.
            # Back it out to input-science coordinates, and stuff it in the inverse table.
            my $tmp; # work around perl -d "feature"
            ($tmp = $itable_flattened->slice("($i)")) .= $coord;

            print " $i..." if( ($i%1000==0) && ( $PDL::verbose || $PDL::debug || $PDL::Transform::debug));
        }

        {
            my $tmp; # work around perl -d "feature"
            ($tmp = $itable->clump($itable->ndims-1)) .= $itable_flattened;
            ($tmp = $itable->mv(-1,0)) -= $p->{offset};
            ($tmp = $itable->mv(-1,0)) /= $p->{scale};
        }

        $p->{itable} = $itable;
      }
      &$lookup_func($data,$p, $p->{itable},$p->{iscale},$p->{ioffset}) ;
    };


  $me->{name} = 'Lookup';

  return $me;
}




=head2 t_linear

=for usage

$f = t_linear({options});

=for ref

Linear (affine) transformations with optional offset

t_linear implements simple matrix multiplication with offset,
also known as the affine transformations.

You specify the linear transformation with pre-offset, a mixing
matrix, and a post-offset.  That overspecifies the transformation, so
you can choose your favorite method to specify the transform you want.
The inverse transform is automagically generated, provided that it
actually exists (the transform matrix is invertible).  Otherwise, the
inverse transform just croaks.

Extra dimensions in the input vector are ignored, so if you pass a
3xN vector into a 3-D linear transformation, the final dimension is passed
through unchanged.

The options you can usefully pass in are:

=over 3

=item s, scale, Scale

A scaling scalar (heh), vector, or matrix.  If you specify a vector
it is treated as a diagonal matrix (for convenience).  It gets
left-multiplied with the transformation matrix you specify (or the
identity), so that if you specify both a scale and a matrix the
scaling is done after the rotation or skewing or whatever.

=item r, rot, rota, rotation, Rotation

A rotation angle in degrees -- useful for 2-D and 3-D data only.  If
you pass in a scalar, it specifies a rotation from the 0th axis toward
the 1st axis.  If you pass in a 3-vector as either a PDL or an array
ref (as in "rot=>[3,4,5]"), then it is treated as a set of Euler
angles in three dimensions, and a rotation matrix is generated that
does the following, in order:

=over 3

=item * Rotate by rot->(2) degrees from 0th to 1st axis

=item * Rotate by rot->(1) degrees from the 2nd to the 0th axis

=item * Rotate by rot->(0) degrees from the 1st to the 2nd axis

=back

The rotation matrix is left-multiplied with the transformation matrix
you specify, so that if you specify both rotation and a general matrix
the rotation happens after the more general operation -- though that is
deprecated.

Of course, you can duplicate this functionality -- and get more
general -- by generating your own rotation matrix and feeding it in
with the C<matrix> option.

=item m, matrix, Matrix

The transformation matrix.  It does not even have to be square, if you want
to change the dimensionality of your input.  If it is invertible (note:
must be square for that), then you automagically get an inverse transform too.

=item pre, preoffset, offset, Offset

The vector to be added to the data before they get multiplied by the matrix
(equivalent of CRVAL in FITS, if you are converting from scientific to
pixel units).

=item post, postoffset, shift, Shift

The vector to be added to the data after it gets multiplied by the matrix
(equivalent of CRPIX-1 in FITS, if youre converting from scientific to pixel
units).

=item d, dim, dims, Dims

Most of the time it is obvious how many dimensions you want to deal
with: if you supply a matrix, it defines the transformation; if you
input offset vectors in the C<pre> and C<post> options, those define
the number of dimensions.  But if you only supply scalars, there is no way
to tell and the default number of dimensions is 2.  This provides a way
to do, e.g., 3-D scaling: just set C<{s=><scale-factor>, dims=>3}> and
you are on your way.

=back

NOTES

the type/unit fields are currently ignored by t_linear.

=cut

@PDL::Transform::Linear::ISA = ('PDL::Transform');

sub t_linear { new PDL::Transform::Linear(@_); }

sub PDL::Transform::Linear::new {
  my($class) = shift;
  my($o) = $_[0];
  pop @_ if (($#_ % 2 ==0) && !defined($_[-1]));
  #suppresses a warning if @_ has an odd number of elements and the
  #last is undef

  if(!(ref $o)) {
    $o = {@_};
  }

  my($me) = PDL::Transform::new($class);

  $me->{name} = "linear";

  $me->{params}->{pre} = _opt($o,['pre','Pre','preoffset','offset',
                                  'Offset','PreOffset','Preoffset'],0);
  $me->{params}->{pre} = pdl($me->{params}->{pre})
    if(defined $me->{params}->{pre});

  $me->{params}->{post} = _opt($o,['post','Post','postoffset','PostOffset',
                                   'shift','Shift'],0);
  $me->{params}->{post} = pdl($me->{params}->{post})
    if(defined $me->{params}->{post});

  $me->{params}->{matrix} = _opt($o,['m','matrix','Matrix','mat','Mat']);
  $me->{params}->{matrix} = pdl($me->{params}->{matrix})
    if(defined $me->{params}->{matrix});

  $me->{params}->{rot} = _opt($o,['r','rot','rota','rotation','Rotation']);
  $me->{params}->{rot} = 0 unless defined($me->{params}->{rot});
  $me->{params}->{rot} = pdl($me->{params}->{rot});

  my $o_dims = _opt($o,['d','dim','dims','Dims']);
  $o_dims = pdl($o_dims)
    if defined($o_dims);

  my $scale  = _opt($o,['s','scale','Scale']);
  $scale = pdl($scale)
    if defined($scale);

  # Figure out the number of dimensions to transform, and,
  # if necessary, generate a new matrix.

  if(defined($me->{params}->{matrix})) {
    my $mat = $me->{params}->{matrix} = $me->{params}->{matrix}->slice(":,:");
    $me->{idim} = $mat->dim(0);
    $me->{odim} = $mat->dim(1);

  } else {
    if(defined($me->{params}->{rot}) &&
        UNIVERSAL::isa($me->{params}->{rot},'PDL')) {
          $me->{idim} = $me->{odim} = 2 if($me->{params}->{rot}->nelem == 1);
          $me->{idim} = $me->{odim} = 3 if($me->{params}->{rot}->nelem == 3);
    }

    if(defined($scale) &&
       UNIVERSAL::isa($scale,'PDL') &&
       $scale->getndims > 0) {
      $me->{idim} = $me->{odim} = $scale->dim(0);
      $me->{odim} = $scale->dim(0);

    } elsif(defined($me->{params}->{pre}) &&
            UNIVERSAL::isa($me->{params}->{pre},'PDL') &&
            $me->{params}->{pre}->getndims > 0) {
      $me->{idim} = $me->{odim} = $me->{params}->{pre}->dim(0);

    } elsif(defined($me->{params}->{post}) &&
            UNIVERSAL::isa($me->{params}->{post},'PDL') &&
            $me->{params}->{post}->getndims > 0) {
      $me->{idim} = $me->{odim} = $me->{params}->{post}->dim(0);
    } elsif(defined($o_dims)) {
      $me->{idim} = $me->{odim} = $o_dims;
    } else {
      print "PDL::Transform::Linear: assuming 2-D transform (set dims option to change)\n" if($PDL::Transform::debug);
      $me->{idim} = $me->{odim} = 2;
    }

    $me->{params}->{matrix} = PDL->zeroes($me->{idim},$me->{odim});
    my $tmp; # work around perl -d "feature"
    ($tmp = $me->{params}->{matrix}->diagonal(0,1)) .= 1;

  }

  ### Handle rotation option
  my $rot = $me->{params}->{rot};
  if(defined($rot)) {
    # Subrotation closure -- rotates from axis $d->(0) --> $d->(1).
    my $subrot = sub {
                       my($d,$angle,$m)=@_;
                       my($i) = identity($m->dim(0));
                       my($subm) = $i->dice($d,$d);

                       $angle = $angle->at(0)
                         if(UNIVERSAL::isa($angle,'PDL'));

                       my($x) = $angle * $DEG2RAD;
                       $subm .= $subm x pdl([cos($x),-sin($x)],[sin($x),cos($x)]);
                       $m .= $m x $i;
                     };

    if(UNIVERSAL::isa($rot,'PDL') && $rot->nelem > 1) {
      if($rot->ndims == 2) {
        $me->{params}->{matrix} x= $rot;
      } elsif($rot->nelem == 3) {
        my $rm = identity(3);

        # Do these in reverse order to make it more like
        # function composition!
        &$subrot(pdl(0,1),$rot->at(2),$rm);
        &$subrot(pdl(2,0),$rot->at(1),$rm);
        &$subrot(pdl(1,2),$rot->at(0),$rm);

        $me->{params}->{matrix} .= $me->{params}->{matrix} x $rm;
      } else {
        barf("PDL::Transform::Linear: Got a strange rot option -- giving up.\n");
      }
    } else {
        if($rot != 0  and  $me->{params}->{matrix}->dim(0)>1) {
          &$subrot(pdl(0,1),$rot,$me->{params}->{matrix});
        }
    }
  }


  #
  # Apply scaling
  #
  $me->{params}->{matrix} = $me->{params}->{matrix}->slice(":,:");
  my $tmp; # work around perl -d "feature"
  ($tmp = $me->{params}->{matrix}->diagonal(0,1)) *= $scale
    if defined($scale);

  #
  # Check for an inverse and apply it if possible
  #
  my($o2);
  if($me->{params}->{matrix}->det($o2 = {lu=>undef})) {
    $me->{params}->{inverse} = $me->{params}->{matrix}->inv($o2);
  } else {
    delete $me->{params}->{inverse};
  }

  $me->{params}->{idim} = $me->{idim};
  $me->{params}->{odim} = $me->{odim};


  ##############################
  # The meat -- just shift, matrix-multiply, and shift again.
  $me->{func} = sub {
    my($in,$opt) = @_;

    my($d) = $opt->{matrix}->dim(0)-1;

    barf("Linear transform: transform is $d-D; data only ".($in->dim(0))."\n")
        if($in->dim(0) < $d);

    my($x) = $in->slice("0:$d")->copy + $opt->{pre};
    my($out) = $in->is_inplace ? $in : $in->copy;

    my $tmp; # work around perl -d "feature"
    ($tmp = $out->slice("0:$d")) .= $x x $opt->{matrix} + $opt->{post};

    return $out;
  };


  $me->{inv} = (defined $me->{params}->{inverse}) ? sub {
    my($in,$opt) = @_;

    my($d) = $opt->{inverse}->dim(0)-1;
    barf("Linear transform: transform is $d-D; data only ".($in->dim(0))."\n")
        if($in->dim(0) < $d);

    my($x) = $in->slice("0:$d")->copy - $opt->{post};
    my($out) = $in->is_inplace ? $in : $in->copy;

    my $tmp; # work around perl -d "feature"
    ($tmp = $out->slice("0:$d")) .= $x x $opt->{inverse} - $opt->{pre};

    $out;
  } : undef;

  return $me;
}

sub PDL::Transform::Linear::stringify {
  package PDL::Transform::Linear;
  my($me) = shift;  my($out) = SUPER::stringify $me;
  my $mp = $me->{params};

  if(!($me->{is_inverse})){
    $out .= "Pre-add: ".($mp->{pre})."\n"
      if(defined $mp->{pre});

    $out .= "Post-add: ".($mp->{post})."\n"
      if(defined $mp->{post});

    $out .= "Forward matrix:".($mp->{matrix})
      if(defined $mp->{matrix});

    $out .= "Inverse matrix:".($mp->{inverse})
      if(defined $mp->{inverse});
  } else {
    $out .= "Pre-add: ".(-$mp->{post})."\n"
      if(defined $mp->{post});

    $out .= "Post-add: ".(-$mp->{pre})."\n"
      if(defined $mp->{pre});

    $out .= "Forward matrix:".($mp->{inverse})
      if(defined $mp->{inverse});

    $out .= "Inverse matrix:".($mp->{matrix})
      if(defined $mp->{matrix});
  }

  $out =~ s/\n/\n  /go;
  $out;
}




=head2 t_scale

=for usage

  $f = t_scale(<scale>)

=for ref

Convenience interface to L<t_linear|/t_linear>.

t_scale produces a transform that scales around the origin by a fixed
amount.  It acts exactly the same as C<t_linear(Scale=>\<scale\>)>.

=cut

sub t_scale {
    my($scale) = shift;
    my($y) = shift;
    return t_linear(scale=>$scale,%{$y})
        if(ref $y eq 'HASH');
    t_linear(Scale=>$scale,$y,@_);
}




=head2 t_offset

=for usage

  $f = t_offset(<shift>)

=for ref

Convenience interface to L<t_linear|/t_linear>.

t_offset produces a transform that shifts the origin to a new location.
It acts exactly the same as C<t_linear(Pre=>\<shift\>)>.

=cut

sub t_offset {
    my($pre) = shift;
    my($y) = shift;
    return t_linear(pre=>$pre,%{$y})
        if(ref $y eq 'HASH');

    t_linear(pre=>$pre,$y,@_);
}




=head2 t_rot

=for usage

  $f = t_rot(<rotation-in-degrees>)

=for ref

Convenience interface to L<t_linear|/t_linear>.

t_rot produces a rotation transform in 2-D (scalar), 3-D (3-vector), or
N-D (matrix).  It acts exactly the same as C<t_linear(Rot=>\<shift\>)>.

=cut

*t_rot = \&t_rotate;
sub t_rotate    {
    my $rot = shift;
    my($y) = shift;
    return t_linear(rot=>$rot,%{$y})
        if(ref $y eq 'HASH');

    t_linear(rot=>$rot,$y,@_);
}




=head2 t_fits

=for usage

  $f = t_fits($fits,[option]);

=for ref

FITS pixel-to-scientific transformation with inverse

You feed in a hash ref or a PDL with one of those as a header, and you
get back a transform that converts 0-originated, pixel-centered
coordinates into scientific coordinates via the transformation in the
FITS header.  For most FITS headers, the transform is reversible, so
applying the inverse goes the other way.  This is just a convenience
subclass of PDL::Transform::Linear, but with unit/type support
using the FITS header you supply.

For now, this transform is rather limited -- it really ought to
accept units differences and stuff like that, but they are just
ignored for now.  Probably that would require putting units into
the whole transform framework.

This transform implements the linear transform part of the WCS FITS
standard outlined in Greisen & Calabata 2002 (A&A in press; find it at
"http://arxiv.org/abs/astro-ph/0207407").

As a special case, you can pass in the boolean option "ignore_rgb"
(default 0), and if you pass in a 3-D FITS header in which the last
dimension has exactly 3 elements, it will be ignored in the output
transformation.  That turns out to be handy for handling rgb images.

=cut

sub t_fits {
  my($class) = 'PDL::Transform::Linear';
  my($hdr) = shift;
  my($opt) = shift;

  if(ref $opt ne 'HASH') {
    $opt = defined $opt ? {$opt,@_} : {} ;
  }

  $hdr = $hdr->gethdr
    if(defined $hdr && UNIVERSAL::isa($hdr,'PDL'));

  croak('PDL::Transform::FITS::new requires a FITS header hash\n')
    if(!defined $hdr || ref $hdr ne 'HASH' || !defined($hdr->{NAXIS}));

  my($n) = $hdr->{NAXIS}; $n = $n->at(0) if(UNIVERSAL::isa($n,'PDL'));

  $n = 2
    if($opt->{ignore_rgb} && $n==3 && $hdr->{NAXIS3} == 3);

  my($matrix) = PDL->zeroes($hdr->{NAXIS},$hdr->{NAXIS});
  my($pre) = PDL->zeroes($n);
  my($post) = PDL->zeroes($n);

  ##############################
  # Scaling: Use CDi_j formalism if present; otherwise use the
  # older PCi_j + CDELTi formalism.

  my(@hgrab);

  if(@hgrab = grep(m/^CD\d{1,3}_\d{1,3}$/,keys %$hdr)) {   # assignment
    #
    # CDi_j formalism
    #
    for my $h(@hgrab) {
      $h =~ m/CD(\d{1,3})_(\d{1,3})/;  # Should always match
      my $tmp; # work around perl -d "feature"
      ($tmp = $matrix->slice("(".($1-1)."),(".($2-1).")")) .= $hdr->{$h};
    }
    print "PDL::Transform::FITS: Detected CDi_j matrix: \n",$matrix,"\n"
      if($PDL::Transform::debug);

  } else {

    #
    # PCi_j + CDELTi formalism
    # If PCi_j aren't present, and N=2, then try using CROTA or
    # CROTA2 to generate a rotation matrix instea.
    #

    my($cdm) = PDL->zeroes($n,$n);
    my($cd) = $cdm->diagonal(0,1);

    my($cpm) = PDL->zeroes($n,$n);
    my $tmp; # work around perl -d "feature"
    ($tmp = $cpm->diagonal(0,1)) .= 1;     # PC: diagonal defaults to unity
    $cd .= 1;


    if( @hgrab = grep(m/^PC\d{1,3}_\d{1,3}$/,keys %$hdr) ) {  # assignment

      for my $h(@hgrab) {
        $h =~ m/PC(\d{1,3})_(\d{1,3})$/ || die "t_fits - match failed! This should never happen!";
        my $tmp; # work around perl -d "feature"
        ($tmp = $cpm->slice("(".($1-1)."),(".($2-1).")")) .= $hdr->{$h};
      }
      print "PDL::Transform::FITS: Detected PCi_j matrix: \n",$cpm,"\n"
        if($PDL::Transform::debug && @hgrab);

    } elsif($n==2 && ( defined $hdr->{CROTA} || defined $hdr->{CROTA1} || defined $hdr->{CROTA2}) ) {

        ## CROTA is deprecated; CROTA1 was used for a while but is unofficial;
        ## CROTA2 is encouraged instead.
      my $cr;
      $cr = $hdr->{CROTA2} unless defined $cr;
      $cr = $hdr->{CROTA} unless defined $cr;
      $cr = $hdr->{CROTA1} unless defined $cr;

      $cr *= $DEG2RAD;
        # Rotation matrix rotates counterclockwise to get from sci to pixel coords
        # (detector has been rotated ccw, according to FITS standard)
      $cpm .= pdl( [cos($cr), sin($cr)],[-sin($cr),cos($cr)] );

    }

    for my $i(1..$n) {
      my $tmp; # work around perl -d "feature"
      ($tmp = $cd->slice("(".($i-1).")")) .= $hdr->{"CDELT$i"};
    }
#If there are no CDELTs, then we assume they are all 1.0,
#as in PDL::Graphics::PGPLOT::Window::_FITS_tr.
    $cd+=1 if (all($cd==0));

    $matrix = $cdm x $cpm;
  }

  my($i1) = 0;
  for my $i(1..$n) {
    my $tmp; # work around perl -d "feature"
    ($tmp = $pre->slice("($i1)"))  .= 1 - $hdr->{"CRPIX$i"};
    ($tmp = $post->slice("($i1)")) .= $hdr->{"CRVAL$i"};
    $i1++;
  }

  my($me) = PDL::Transform::Linear::new($class,
                                        {'pre'=>$pre,
                                         'post'=>$post,
                                         'matrix'=>$matrix
                                         });

  $me->{name} = 'FITS';

  my (@otype,@ounit,@itype,@iunit);
  our (@names) = ('X','Y','Z') unless @names;

  for my $i(1..$hdr->{NAXIS}) {
    push(@otype,$hdr->{"CTYPE$i"});
    push(@ounit,$hdr->{"CUNIT$i"});
    push(@itype,"Image ". ( ($i-1<=$#names) ? $names[$i-1] : "${i}th dim" ));
    push(@iunit,"Pixels");
  }

  $me->{otype} = \@otype;
  $me->{itype} = \@itype;
  $me->{ounit} = \@ounit;
  $me->{iunit} = \@iunit;

  # Check for nonlinear projection...
#  if($hdr->{CTYPE1} =~ m/(\w\w\w\w)\-(\w\w\w)/) {
#      print "Nonlinear transformation found... ignoring nonlinear part...\n";
#  }

  return $me;


}




=head2 t_code

=for usage

  $f = t_code(<func>,[<inv>],[options]);

=for ref

Transform implementing arbitrary perl code.

This is a way of getting quick-and-dirty new transforms.  You pass in
anonymous (or otherwise) code refs pointing to subroutines that
implement the forward and, optionally, inverse transforms.  The
subroutines should accept a data PDL followed by a parameter hash ref,
and return the transformed data PDL.  The parameter hash ref can be
set via the options, if you want to.

Options that are accepted are:

=over 3

=item p,params

The parameter hash that will be passed back to your code (defaults to the
empty hash).

=item n,name

The name of the transform (defaults to "code").

=item i, idim (default 2)

The number of input dimensions (additional ones should be passed through
unchanged)

=item o, odim (default 2)

The number of output dimensions

=item itype

The type of the input dimensions, in an array ref (optional and advisiory)

=item otype

The type of the output dimension, in an array ref (optional and advisory)

=item iunit

The units that are expected for the input dimensions (optional and advisory)

=item ounit

The units that are returned in the output (optional and advisory).

=back

The code variables are executable perl code, either as a code ref or
as a string that will be eval'ed to produce code refs.  If you pass in
a string, it gets eval'ed at call time to get a code ref.  If it compiles
OK but does not return a code ref, then it gets re-evaluated with "sub {
... }" wrapped around it, to get a code ref.

Note that code callbacks like this can be used to do really weird
things and generate equally weird results -- caveat scriptor!

=cut

sub t_code {
  my($class) = 'PDL::Transform';
  my($func, $inv, $o) = @_;
  if(ref $inv eq 'HASH') {
    $o = $inv;
    $inv = undef;
  }

  my($me) = PDL::Transform::new($class);
  $me->{name} = _opt($o,['n','name','Name']) || "code";
  $me->{func} = $func;
  $me->{inv} = $inv;
  $me->{params} = _opt($o,['p','params','Params']) || {};
  $me->{idim} = _opt($o,['i','idim']) || 2;
  $me->{odim} = _opt($o,['o','odim']) || 2;
  $me->{itype} = _opt($o,['itype']) || [];
  $me->{otype} = _opt($o,['otype']) || [];
  $me->{iunit} = _opt($o,['iunit']) || [];
  $me->{ounit} = _opt($o,['ounit']) || [];

  $me;
}




=head2 t_cylindrical

C<t_cylindrical> is an alias for C<t_radial>

=head2 t_radial

=for usage

  $f = t_radial(<options>);

=for ref

Convert Cartesian to radial/cylindrical coordinates.  (2-D/3-D; with inverse)

Converts 2-D Cartesian to radial (theta,r) coordinates.  You can choose
direct or conformal conversion.  Direct conversion preserves radial
distance from the origin; conformal conversion preserves local angles,
so that each small-enough part of the image only appears to be scaled
and rotated, not stretched.  Conformal conversion puts the radius on a
logarithmic scale, so that scaling of the original image plane is
equivalent to a simple offset of the transformed image plane.

If you use three or more dimensions, the higher dimensions are ignored,
yielding a conversion from Cartesian to cylindrical coordinates, which
is why there are two aliases for the same transform.  If you use higher
dimensionality than 2, you must manually specify the origin or you will
get dimension mismatch errors when you apply the transform.

Theta runs B<clockwise> instead of the more usual counterclockwise; that is
to preserve the mirror sense of small structures.

OPTIONS:

=over 3

=item d, direct, Direct

Generate (theta,r) coordinates out (this is the default); incompatible
with Conformal.  Theta is in radians, and the radial coordinate is
in the units of distance in the input plane.

=item r0, c, conformal, Conformal

If defined, this floating-point value causes t_radial to generate
(theta, ln(r/r0)) coordinates out.  Theta is in radians, and the
radial coordinate varies by 1 for each e-folding of the r0-scaled
distance from the input origin.  The logarithmic scaling is useful for
viewing both large and small things at the same time, and for keeping
shapes of small things preserved in the image.

=item o, origin, Origin [default (0,0,0)]

This is the origin of the expansion.  Pass in a PDL or an array ref.

=item u, unit, Unit [default 'radians']

This is the angular unit to be used for the azimuth.

=back

EXAMPLES

These examples do transformations back into the same size image as they
started from; by suitable use of the "transform" option to
L<unmap|/unmap> you can send them to any size array you like.

Examine radial structure in M51:
Here, we scale the output to stretch 2*pi radians out to the
full image width in the horizontal direction, and to stretch 1 radius out
to a diameter in the vertical direction.

  $x = rfits('m51.fits');
  $ts = t_linear(s => [250/2.0/3.14159, 2]); # Scale to fill orig. image
  $tu = t_radial(o => [130,130]);            # Expand around galactic core
  $y = $x->map($ts x $tu);

Examine radial structure in M51 (conformal):
Here, we scale the output to stretch 2*pi radians out to the full image width
in the horizontal direction, and scale the vertical direction by the exact
same amount to preserve conformality of the operation.  Notice that
each piece of the image looks "natural" -- only scaled and not stretched.

  $x = rfits('m51.fits')
  $ts = t_linear(s=> 250/2.0/3.14159);  # Note scalar (heh) scale.
  $tu = t_radial(o=> [130,130], r0=>5); # 5 pix. radius -> bottom of image
  $y = $ts->compose($tu)->unmap($x);


=cut

*t_cylindrical = \&t_radial;
sub t_radial {
  my($class) = 'PDL::Transform';
  my($o) = $_[0];
  if(ref $o ne 'HASH') {
    $o = { @_ };
  }

  my($me) = PDL::Transform::new($class);

  $me->{params}->{origin} = _opt($o,['o','origin','Origin']);
  $me->{params}->{origin} = pdl(0,0)
    unless defined($me->{params}->{origin});
  $me->{params}->{origin} = PDL->pdl($me->{params}->{origin});


  $me->{params}->{r0} = _opt($o,['r0','R0','c','conformal','Conformal']);
  $me->{params}->{origin} = PDL->pdl($me->{params}->{origin});

  $me->{params}->{u} = _opt($o,['u','unit','Unit'],'radians');
  ### Replace this kludge with a units call
  $me->{params}->{angunit} = ($me->{params}->{u} =~ m/^d/i) ? $RAD2DEG : 1.0;
  print "radial: conversion is $me->{params}->{angunit}\n" if($PDL::Transform::debug);

  $me->{name} = "radial (direct)";

  $me->{idim} = 2;
  $me->{odim} = 2;

  if($me->{params}->{r0}) {
    $me->{otype} = ["Azimuth", "Ln radius" . ($me->{params}->{r0} != 1.0 ? "/$me->{params}->{r0}" : "")];
    $me->{ounit} = [$me->{params}->{u},'']; # true-but-null prevents copying
  } else {
    $me->{otype} = ["Azimuth","Radius"];
    $me->{ounit} = [$me->{params}->{u},''];  # false value copies prev. unit
  }

  $me->{func} = sub {

      my($data,$o) = @_;

      my($out) = ($data->new_or_inplace);

      my($d) = $data->copy;
      my $tmp; # work around perl -d "feature"
      ($tmp = $d->slice("0:1")) -= $o->{origin};

      my($d0) = $d->slice("(0)");
      my($d1) = $d->slice("(1)");

      # (mod operator on atan2 puts everything in the interval [0,2*PI).)
      ($tmp = $out->slice("(0)")) .= (atan2(-$d1,$d0) % (2*$PI)) * $me->{params}->{angunit};

      ($tmp = $out->slice("(1)")) .= (defined $o->{r0}) ?
              0.5 * log( ($d1*$d1 + $d0 * $d0) / ($o->{r0} * $o->{r0}) ) :
              sqrt($d1*$d1 + $d0*$d0);

      $out;
  };

  $me->{inv} = sub {

    my($d,$o) = @_;
    my($d0,$d1,$out)=
        ( ($d->is_inplace) ?
          ($d->slice("(0)")->copy, $d->slice("(1)")->copy->dummy(0,2), $d) :
          ($d->slice("(0)"),       $d->slice("(1)")->dummy(0,2),       $d->copy)
          );

    $d0 /= $me->{params}->{angunit};

    my($os) = $out->slice("0:1");
    $os .= append(cos($d0)->dummy(0,1),-sin($d0)->dummy(0,1));
    $os *= defined $o->{r0}  ?  ($o->{r0} * exp($d1))  :  $d1;
    $os += $o->{origin};

    $out;
  };


  $me;
}




=head2 t_quadratic

=for usage

  $t = t_quadratic(<options>);

=for ref

Quadratic scaling -- cylindrical pincushion (n-d; with inverse)

Quadratic scaling emulates pincushion in a cylindrical optical system:
separate quadratic scaling is applied to each axis.  You can apply
separate distortion along any of the principal axes.  If you want
different axes, use L<t_wrap|/t_wrap> and L<t_linear|/t_linear> to rotate
them to the correct angle.  The scaling options may be scalars or
vectors; if they are scalars then the expansion is isotropic.

The formula for the expansion is:

    f(a) = ( <a> + <strength> * a^2/<L_0> ) / (abs(<strength>) + 1)

where <strength> is a scaling coefficient and <L_0> is a fundamental
length scale.   Negative values of <strength> result in a pincushion
contraction.

Note that, because quadratic scaling does not have a strict inverse for
coordinate systems that cross the origin, we cheat slightly and use
$x * abs($x)  rather than $x**2.  This does the Right thing for pincushion
and barrel distortion, but means that t_quadratic does not behave exactly
like t_cubic with a null cubic strength coefficient.

OPTIONS

=over 3

=item o,origin,Origin

The origin of the pincushion. (default is the, er, origin).

=item l,l0,length,Length,r0

The fundamental scale of the transformation -- the radius that remains
unchanged.  (default=1)

=item s,str,strength,Strength

The relative strength of the pincushion. (default = 0.1)

=item honest (default=0)

Sets whether this is a true quadratic coordinate transform.  The more
common form is pincushion or cylindrical distortion, which switches
branches of the square root at the origin (for symmetric expansion).
Setting honest to a non-false value forces true quadratic behavior,
which is not mirror-symmetric about the origin.

=item d, dim, dims, Dims

The number of dimensions to quadratically scale (default is the
dimensionality of your input vectors)


=back

=cut

sub t_quadratic {
    my($class) = 'PDL::Transform';
    my($o) = $_[0];
    if(ref $o ne 'HASH') {
        $o = {@_};
    }
    my($me) = PDL::Transform::new($class);

    $me->{params}->{origin} = _opt($o,['o','origin','Origin'],pdl(0));
    $me->{params}->{l0} = _opt($o,['r0','l','l0','length','Length'],pdl(1));
    $me->{params}->{str} = _opt($o,['s','str','strength','Strength'],pdl(0.1));
    $me->{params}->{dim} = _opt($o,['d','dim','dims','Dims']);
    $me->{name} = "quadratic";

    $me->{func} = sub {
        my($data,$o) = @_;
        my($dd) = $data->copy - $o->{origin};
        my($d) =  (defined $o->{dim}) ? $dd->slice("0:".($o->{dim}-1)) : $dd;
        $d += $o->{str} * ($d * abs($d)) / $o->{l0};
        $d /= (abs($o->{str}) + 1);
        $d += $o->{origin};
        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        }
        $dd;
    };

    $me->{inv} = sub {
        my($data,$opt) = @_;
        my($dd) = $data->copy ;
        my($d) = (defined $opt->{dim}) ? $dd->slice("0:".($opt->{dim}-1)) : $dd;
        my($o) = $opt->{origin};
        my($s) = $opt->{str};
        my($l) = $opt->{l0};

        $d .= ((-1 + sqrt(1 + 4 * $s/$l * abs($d-$o) * (1+abs($s))))
            / 2 / $s * $l) * (1 - 2*($d < $o));
        $d += $o;
        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        }
        $dd;
    };
    $me;
}




=head2 t_cubic

=for usage

  $t = t_cubic(<options>);

=for ref

Cubic scaling - cubic pincushion (n-d; with inverse)

Cubic scaling is a generalization of t_quadratic to a purely
cubic expansion.

The formula for the expansion is:

    f(a) = ( a' + st * a'^3/L_0^2 ) / (1 + abs(st)) + origin

where a'=(a-origin).  That is a simple pincushion
expansion/contraction that is fixed at a distance of L_0 from the
origin.

Because there is no quadratic term the result is always invertible with
one real root, and there is no mucking about with complex numbers or
multivalued solutions.


OPTIONS

=over 3

=item o,origin,Origin

The origin of the pincushion. (default is the, er, origin).

=item l,l0,length,Length,r0

The fundamental scale of the transformation -- the radius that remains
unchanged.  (default=1)


=item d, dim, dims, Dims

The number of dimensions to treat (default is the
dimensionality of your input vectors)

=back

=cut

sub t_cubic {
    my ($class) = 'PDL::Transform';
    my($o) = $_[0];
    if(ref $o ne 'HASH') {
        $o = {@_};
    }
    my($me) = PDL::Transform::new($class);

    $me->{params}->{dim} = _opt($o,['d','dim','dims','Dims'],undef);
    $me->{params}->{origin} = _opt($o,['o','origin','Origin'],pdl(0));
    $me->{params}->{l0} = _opt($o,['r0','l','l0','length','Length'],pdl(1));
    $me->{params}->{st} = _opt($o,['s','st','str'],pdl(0));
    $me->{name} = "cubic";

    $me->{params}->{cuberoot} = sub {
        my $x = shift;
        my $as = 1 - 2*($x<0);
        return $as * (  abs($x) ** (1/3) );
    };

    $me->{func} = sub {
        my($data,$o) = @_;
        my($dd) = $data->copy;
        my($d) = (defined $o->{dim}) ? $dd->slice("0:".($o->{dim}-1)) : $dd;

        $d -= $o->{origin};

        my $dl0 = $d / $o->{l0};

        # f(x) = x + x**3 * ($o->{st} / $o->{l0}**2):
        #     A = ($o->{st}/$dl0**2)
        #     B = 0
        #     C = 1
        #     D = -f(x)
        $d += $o->{st} * $d * $dl0 * $dl0;
        $d /= ($o->{st}**2 + 1);

        $d += $o->{origin};

        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        }
        return $dd;
    };

    $me->{inv} = sub {
        my($data,$o) = @_;
        my($l) = $o->{l0};

        my($dd) = $data->copy;
        my($d) = (defined $o->{dim}) ? $dd->slice("0:".($o->{dim}-1)) : $dd;

        $d -= $o->{origin};
        $d *= ($o->{st}+1);

        # Now we have to solve:
        #  A x^3 + B X^2 + C x + D dd = 0
        # with the assignments above for A,B,C,D.
        # Since B is zero, this is greatly simplified - the discriminant is always negative,
        # so there is always exactly one real root.
        #
        # The only real hassle is creating a symmetric cube root; for convenience
        # is stashed in the params hash.

        # First: create coefficients for mnemonics.
        my ($A, $C, $D) = ( $o->{st} / $l / $l, 1, - $d );
        my $alpha =  27 * $A * $A * $D;
        my $beta =  3 * $A * $C;

        my $inner_root = sqrt( $alpha * $alpha   +   4 * $beta * $beta * $beta );

        $d .= (-1 / (3 * $A)) *
            (
              + &{$o->{cuberoot}}( 0.5 * ( $alpha + $inner_root ) )
              + &{$o->{cuberoot}}( 0.5 * ( $alpha - $inner_root ) )
            );

        $d += $origin;

        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        } else {
            return $dd;
        }
    };

    $me;
}




=head2 t_quartic

=for usage

  $t = t_quartic(<options>);

=for ref

Quartic scaling -- cylindrical pincushion (n-d; with inverse)

Quartic scaling is a generalization of t_quadratic to a quartic
expansion.  Only even powers of the input coordinates are retained,
and (as with t_quadratic) sign is preserved, making it an odd function
although a true quartic transformation would be an even function.

You can apply separate distortion along any of the principal axes.  If
you want different axes, use L<t_wrap|/t_wrap> and
L<t_linear|/t_linear> to rotate them to the correct angle.  The
scaling options may be scalars or vectors; if they are scalars then
the expansion is isotropic.

The formula for the expansion is:

    f(a) = ( <a> + <strength> * a^2/<L_0> ) / (abs(<strength>) + 1)

where <strength> is a scaling coefficient and <L_0> is a fundamental
length scale.   Negative values of <strength> result in a pincushion
contraction.

Note that, because quadratic scaling does not have a strict inverse for
coordinate systems that cross the origin, we cheat slightly and use
$x * abs($x)  rather than $x**2.  This does the Right thing for pincushion
and barrel distortion, but means that t_quadratic does not behave exactly
like t_cubic with a null cubic strength coefficient.

OPTIONS

=over 3

=item o,origin,Origin

The origin of the pincushion. (default is the, er, origin).

=item l,l0,length,Length,r0

The fundamental scale of the transformation -- the radius that remains
unchanged.  (default=1)

=item s,str,strength,Strength

The relative strength of the pincushion. (default = 0.1)

=item honest (default=0)

Sets whether this is a true quadratic coordinate transform.  The more
common form is pincushion or cylindrical distortion, which switches
branches of the square root at the origin (for symmetric expansion).
Setting honest to a non-false value forces true quadratic behavior,
which is not mirror-symmetric about the origin.

=item d, dim, dims, Dims

The number of dimensions to quadratically scale (default is the
dimensionality of your input vectors)


=back

=cut

sub t_quartic {
    my($class) = 'PDL::Transform';
    my($o) = $_[0];
    if(ref $o ne 'HASH') {
        $o = {@_};
    }
    my($me) = PDL::Transform::new($class);

    $me->{params}->{origin} = _opt($o,['o','origin','Origin'],pdl(0));
    $me->{params}->{l0} = _opt($o,['r0','l','l0','length','Length'],pdl(1));
    $me->{params}->{str} = _opt($o,['s','str','strength','Strength'],pdl(0.1));
    $me->{params}->{dim} = _opt($o,['d','dim','dims','Dims']);
    $me->{name} = "quadratic";

    $me->{func} = sub {
        my($data,$o) = @_;
        my($dd) = $data->copy - $o->{origin};
        my($d) =  (defined $o->{dim}) ? $dd->slice("0:".($o->{dim}-1)) : $dd;
        $d += $o->{str} * ($d * abs($d)) / $o->{l0};
        $d /= (abs($o->{str}) + 1);
        $d += $o->{origin};
        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        }
        $dd;
    };

    $me->{inv} = sub {
        my($data,$opt) = @_;
        my($dd) = $data->copy ;
        my($d) = (defined $opt->{dim}) ? $dd->slice("0:".($opt->{dim}-1)) : $dd;
        my($o) = $opt->{origin};
        my($s) = $opt->{str};
        my($l) = $opt->{l0};

        $d .= ((-1 + sqrt(1 + 4 * $s/$l * abs($d-$o) * (1+abs($s))))
            / 2 / $s * $l) * (1 - 2*($d < $o));
        $d += $o;
        if($data->is_inplace) {
            $data .= $dd;
            return $data;
        }
        $dd;
    };
    $me;
}




=head2 t_spherical

=for usage

    $t = t_spherical(<options>);

=for ref

Convert Cartesian to spherical coordinates.  (3-D; with inverse)

Convert 3-D Cartesian to spherical (theta, phi, r) coordinates.  Theta
is longitude, centered on 0, and phi is latitude, also centered on 0.
Unless you specify Euler angles, the pole points in the +Z direction
and the prime meridian is in the +X direction.  The default is for
theta and phi to be in radians; you can select degrees if you want
them.

Just as the L<t_radial|/t_radial> 2-D transform acts like a 3-D
cylindrical transform by ignoring third and higher dimensions,
Spherical acts like a hypercylindrical transform in four (or higher)
dimensions.  Also as with L<t_radial|/t_radial>, you must manually specify
the origin if you want to use more dimensions than 3.

To deal with latitude & longitude on the surface of a sphere (rather
than full 3-D coordinates), see
L<t_unit_sphere|PDL::Transform::Cartography/t_unit_sphere>.

OPTIONS:

=over 3

=item o, origin, Origin [default (0,0,0)]

This is the Cartesian origin of the spherical expansion.  Pass in a PDL
or an array ref.

=item e, euler, Euler [default (0,0,0)]

This is a 3-vector containing Euler angles to change the angle of the
pole and ordinate.  The first two numbers are the (theta, phi) angles
of the pole in a (+Z,+X) spherical expansion, and the last is the
angle that the new prime meridian makes with the meridian of a simply
tilted sphere.  This is implemented by composing the output transform
with a PDL::Transform::Linear object.

=item u, unit, Unit (default radians)

This option sets the angular unit to be used.  Acceptable values are
"degrees","radians", or reasonable substrings thereof (e.g. "deg", and
"rad", but "d" and "r" are deprecated).  Once genuine unit processing
comes online (a la Math::Units) any angular unit should be OK.

=back

=cut

sub t_spherical {
    my($class) = 'PDL::Transform';
    my($o) = $_[0];
    if(ref $o ne 'HASH') {
        $o = { @_ } ;
    }

    my($me) = PDL::Transform::new($class);

    $me->{idim}=3;
    $me->{odim}=3;

    $me->{params}->{origin} = _opt($o,['o','origin','Origin']);
    $me->{params}->{origin} = PDL->zeroes(3)
        unless defined($me->{params}->{origin});
    $me->{params}->{origin} = PDL->pdl($me->{params}->{origin});

    $me->{params}->{deg} = _opt($o,['d','degrees','Degrees']);

    my $unit = _opt($o,['u','unit','Unit']);
    $me->{params}->{angunit} = ($unit =~ m/^d/i) ?
        $DEG2RAD : undef;

    $me->{name} = "spherical";

    $me->{func} = sub {
        my($data,$o) = @_;
        my($d) = $data->copy - $o->{origin};

        my($d0,$d1,$d2) = ($d->slice("(0)"),$d->slice("(1)"),$d->slice("(2)"));
        my($out) =   ($d->is_inplace) ? $data : $data->copy;

        my $tmp; # work around perl -d "feature"
        ($tmp = $out->slice("(0)")) .= atan2($d1, $d0);
        ($tmp = $out->slice("(2)")) .= sqrt($d0*$d0 + $d1*$d1 + $d2*$d2);
        ($tmp = $out->slice("(1)")) .= asin($d2 / $out->slice("(2)"));

        ($tmp = $out->slice("0:1")) /= $o->{angunit}
          if(defined $o->{angunit});

        $out;
      };

    $me->{inv} = sub {
        my($d,$o) = @_;

        my($theta,$phi,$r,$out) =
    ( ($d->is_inplace) ?
              ($d->slice("(0)")->copy, $d->slice("(1)")->copy, $d->slice("(2)")->copy, $d) :
              ($d->slice("(0)"),       $d->slice("(1)"),       $d->slice("(2)"),       $d->copy)
              );


        my($x,$y,$z) =
            ($out->slice("(0)"),$out->slice("(1)"),$out->slice("(2)"));

        my($ph,$th);
        if(defined $o->{angunit}){
          $ph = $o->{angunit} * $phi;
          $th = $o->{angunit} * $theta;
        } else {
          $ph = $phi;
          $th = $theta;
        }

        $z .= $r * sin($ph);
        $x .= $r * cos($ph);
        $y .= $x * sin($th);
        $x *= cos($th);
        $out += $o->{origin};

        $out;
      };

    $me;
  }




=head2 t_projective

=for usage

    $t = t_projective(<options>);

=for ref

Projective transformation

Projective transforms are simple quadratic, quasi-linear
transformations.  They are the simplest transformation that
can continuously warp an image plane so that four arbitrarily chosen
points exactly map to four other arbitrarily chosen points.  They
have the property that straight lines remain straight after transformation.

You can specify your projective transformation directly in homogeneous
coordinates, or (in 2 dimensions only) as a set of four unique points that
are mapped one to the other by the transformation.

Projective transforms are quasi-linear because they are most easily
described as a linear transformation in homogeneous coordinates
(e.g. (x',y',w) where w is a normalization factor: x = x'/w, etc.).
In those coordinates, an N-D projective transformation is represented
as simple multiplication of an N+1-vector by an N+1 x N+1 matrix,
whose lower-right corner value is 1.

If the bottom row of the matrix consists of all zeroes, then the
transformation reduces to a linear affine transformation (as in
L<t_linear|/t_linear>).

If the bottom row of the matrix contains nonzero elements, then the
transformed x,y,z,etc. coordinates are related to the original coordinates
by a quadratic polynomial, because the normalization factor 'w' allows
a second factor of x,y, and/or z to enter the equations.

OPTIONS:

=over 3

=item m, mat, matrix, Matrix

If specified, this is the homogeneous-coordinate matrix to use.  It must
be N+1 x N+1, for an N-dimensional transformation.

=item p, point, points, Points

If specified, this is the set of four points that should be mapped one to the other.
The homogeneous-coordinate matrix is calculated from them.  You should feed in a
2x2x4 PDL, where the 0 dimension runs over coordinate, the 1 dimension runs between input
and output, and the 2 dimension runs over point.  For example, specifying

  p=> pdl([ [[0,1],[0,1]], [[5,9],[5,8]], [[9,4],[9,3]], [[0,0],[0,0]] ])

maps the origin and the point (0,1) to themselves, the point (5,9) to (5,8), and
the point (9,4) to (9,3).

This is similar to the behavior of fitwarp2d with a quadratic polynomial.

=back

=cut

sub t_projective {
  my($class) = 'PDL::Transform';
  my($o) = $_[0];
  if(ref $o ne 'HASH') {
    $o = { @_ };
  }

  my($me) = PDL::Transform::new($class);

  $me->{name} = "projective";

  ### Set options...


  $me->{params}->{idim} = $me->{idim} = _opt($o,['d','dim','Dim']);

  my $matrix;
  if(defined ($matrix=_opt($o,['m','matrix','Matrix']))) {
    $matrix = pdl($matrix);
    die "t_projective: needs a square matrix"
      if($matrix->dims != 2 || $matrix->dim(0) != $matrix->dim(1));

    $me->{params}->{idim} = $matrix->dim(0)-1
      unless(defined($me->{params}->{idim}));

    $me->{idim} = $me->{params}->{idim};

    die "t_projective: matrix not compatible with given dimension (should be N+1xN+1)\n"
      unless($me->{params}->{idim}==$matrix->dim(0)-1);

    my $inv = $matrix->inv;
    print STDERR "t_projective: warning - received non-invertible matrix\n"
      unless(all($inv*0 == 0));

    $me->{params}->{matrix} = $matrix;
    $me->{params}->{matinv} = $inv;

  } elsif(defined ($p=pdl(_opt($o,['p','point','points','Point','Points'])))) {
    die "t_projective: points array should be 2(x,y) x 2(in,out) x 4(point)\n\t(only 2-D points spec is available just now, sorry)\n"
      unless($p->dims==3 && all(pdl($p->dims)==pdl(2,2,4)));

    # Solve the system of N equations to find the projective transform
    my ($p0,$p1,$p2,$p3) = ( $p->slice(":,(0),(0)"), $p->slice(":,(0),(1)"), $p->slice(":,(0),(2)"), $p->slice(":,(0),(3)") );
    my ($P0,$P1,$P2,$P3) = ( $p->slice(":,(1),(0)"), $p->slice(":,(1),(1)"), $p->slice(":,(1),(2)"), $p->slice(":,(1),(3)") );
#print "declaring PDL...\n"    ;
    my $M = pdl( [ [$p0->at(0), $p0->at(1), 1,        0,        0, 0,  -$P0->at(0)*$p0->at(0), -$P0->at(0)*$p0->at(1)],
                   [       0,        0, 0, $p0->at(0), $p0->at(1), 1,  -$P0->at(1)*$p0->at(0), -$P0->at(1)*$p0->at(1)],
                   [$p1->at(0), $p1->at(1), 1,        0,        0, 0,  -$P1->at(0)*$p1->at(0), -$P1->at(0)*$p1->at(1)],
                   [       0,        0, 0, $p1->at(0), $p1->at(1), 1,  -$P1->at(1)*$p1->at(0), -$P1->at(1)*$p1->at(1)],
                   [$p2->at(0), $p2->at(1), 1,        0,        0, 0,  -$P2->at(0)*$p2->at(0), -$P2->at(0)*$p2->at(1)],
                   [       0,        0, 0, $p2->at(0), $p2->at(1), 1,  -$P2->at(1)*$p2->at(0), -$P2->at(1)*$p2->at(1)],
                   [$p3->at(0), $p3->at(1), 1,        0,        0, 0,  -$P3->at(0)*$p3->at(0), -$P3->at(0)*$p3->at(1)],
                   [       0,        0, 0, $p3->at(0), $p3->at(1), 1,  -$P3->at(1)*$p3->at(0), -$P3->at(1)*$p3->at(1)]
                   ] );
#print "ok.  Finding inverse...\n";
    my $h = ($M->inv x $p->slice(":,(1),:")->flat->slice("*1"))->slice("(0)");
#    print "ok\n";
    my $matrix = ones(3,3);
    my $tmp; # work around perl -d "feature"
    ($tmp = $matrix->flat->slice("0:7")) .= $h;
    $me->{params}->{matrix} = $matrix;

    $me->{params}->{matinv} = $matrix->inv;
  }


  $me->{params}->{idim} = 2 unless defined $me->{params}->{idim};
  $me->{params}->{odim} = $me->{params}->{idim};
  $me->{idim} = $me->{params}->{idim};
  $me->{odim} = $me->{params}->{odim};

  $me->{func} = sub {
    my($data,$o) = @_;
    my($id) = $data->dim(0);
    my($d) = $data->glue(0,ones($data->slice("0")));
    my($out) = ($o->{matrix} x $d->slice("*1"))->slice("(0)");
    return ($out->slice("0:".($id-1))/$out->slice("$id"));
  };

  $me->{inv} = sub {
    my($data,$o) = @_;
    my($id) = $data->dim(0);
    my($d) = $data->glue(0,ones($data->slice("0")));
    my($out) = ($o->{matinv} x $d->slice("*1"))->slice("(0)");
    return ($out->slice("0:".($id-1))/$out->slice("$id"));
  };

  $me;
}



;


=head1 AUTHOR

Copyright 2002, 2003 Craig DeForest.  There is no warranty.  You are allowed
to redistribute this software under certain conditions.  For details,
see the file COPYING in the PDL distribution.  If this file is
separated from the PDL distribution, the copyright notice should be
included in the file.

=cut

package PDL::Transform;
use Carp;
use overload '""' => \&_strval;
use overload 'x' => \&_compose_op;
use overload '**' => \&_pow_op;
use overload '!'  => \&t_inverse;

use PDL;
use PDL::MatrixOps;

our $PI = 3.1415926535897932384626;
our $DEG2RAD = $PI / 180;
our $RAD2DEG = 180/$PI;
our $E  = exp(1);


#### little helper kludge parses a list of synonyms
sub _opt {
  my($hash) = shift;
  my($synonyms) = shift;
  my($alt) = shift;  # default is undef -- ok.
  local($_);
  foreach $_(@$synonyms){
    return (UNIVERSAL::isa($alt,'PDL')) ? PDL->pdl($hash->{$_}) : $hash->{$_}
    if defined($hash->{$_}) ;
  }
  return $alt;
}

######################################################################
#
# Stringification hack.  _strval just does a method search on stringify
# for the object itself.  This gets around the fact that stringification
# overload is a subroutine call, not a method search.
#

sub _strval {
  my($me) = shift;
  $me->stringify();
}

######################################################################
#
# PDL::Transform overall stringifier.  Subclassed stringifiers should
# call this routine first then append auxiliary information.
#
sub stringify {
  my($me) = shift;
  my($mestr) = (ref $me);
  $mestr =~ s/PDL::Transform:://;
  my $out = $mestr . " (" . $me->{name} . "): ";
  $out .= "fwd ". ((defined ($me->{func})) ? ( (ref($me->{func}) eq 'CODE') ? "ok" : "non-CODE(!!)" ): "missing")."; ";
  $out .= "inv ". ((defined ($me->{inv})) ?  ( (ref($me->{inv}) eq 'CODE') ? "ok" : "non-CODE(!!)" ):"missing").".\n";
}





# Exit with OK status

1;

		   