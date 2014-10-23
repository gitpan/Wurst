# 6 Dec 2001
# rcsid = $Id: Simplex.pm,v 1.3 2003/02/07 15:33:04 torda Exp $
=head1 NAME

Simplex - multidimensional optimiser

=head1 SYNOPSIS

  use Simplex;

=head1 DESCRIPTION

This performs a multidimensional simplex.
It needs 

=over

=item *
reference to a function

=item *
starting point

=item *
maximum number of steps

=item *
maximumn number of starts

=item *
tolerance for recognising convergence

=back

It can also use

=over

=item *
lower bound

=item *
upper bound

=item *
output file for recording progress

=item *
amount of spread/scatter on initial simplex

=back

=head1 PARAMETERS

Parameters are passed by a reference to a single hash like this

    my %simplex_arg;
    $simplex_arg {max_iter} = 1000;

    my %result = simplex (\%simplex_arg);

In detail:

=head2 Obligatory Parameters

=over

=item *
function

  %simplex_arg {func} = \&myfunc;

This is a reference to a function to be minimised.

   sub myfunc () {
       my $a = shift;
       my $b = shift;
       return ($a * $a + ($b - 2) * ($b - 2);
   }
   ...
       %simplex_arg{func} = \&myfunc;

=item *
Initial guess

    my @initial_guess = (1, 3, 5, 4);
    %simplex_arg {ini_pt} = \@initial_guess

This must be a reference to an array.
The number of dimensions should be correct for the function being optimised.

=item *
Maximum iterations

This is the maximum number of iterations per restart. The
optimisation may restart many times.

    %simplex_arg {max_iter} = 1000;

This is single integer;

=item *
Maximum restarts

This is the maximum number of times the simplex may be
started.
It is not really the number of restarts.
If you set it to 1, you will get an initial minimisation only
and no restarts.

=item *
Tolerance

Convergence criteria are always fun.  Currently, we stop when

=over 8

=item

The difference between best and worst corners of the simplex
is less than C<f_tol> and

=item

The difference between the worst value and previous worst value
is less than C<f_tol>.

=back

To set this

    %simplex_args {f_tol} = 10e-5;

=back

=head2 Optional Parameters

=over

=item *
Lower bounds

You can specify lower bounds for the search. If the simplex
tries to go below this in any dimension, it will reject the
point.

    my @lower = (-2, -3, -4, -5);
    %simplex_arg {lower} = \@lower;

This must be a reference to an array. The dimensions must
agree with those of C<@ini_pt>.

=item *
Upper bounds.

This has corresponding behaviour to the lower bounds array.

    my @upper = (10, 20, 10, 3000);
    %simplex_arg {upper} = \@upper;

=item *
Output file

This is not essential. If you want to record the progress,
then set this like

    %simplex_arg {o_file} = 'splx_out';

This example would end up creating two files

=over

=item splx_out_hi.out

=item splx_out_low.out

=back

This first lists the cycle number, function value and test
point for the worst corner of the simplex. The second gives
the same information for the best point on the simplex

When reading this, the worst (highest) point should change from
step to step. The best point will only change every so often.

=item *
Initial Scatter

The simplex is initialised by taking your guess and spreading
corners of the simplex around it, perfectly evenly. In two dimensions,
This would correspond to surrounding your initial guess by a
triangle.

This parameter controls the width of the spread.

    %simplex_args{scatter} = 0.2;

Would result in a spread of 20 % of the size in each
dimension, going S<10 %> up and S<10 %> down. If your initial
guess is C<10>, then the simplex would span a range of C<9> to
C<11> in this dimension. If you have a two dimensional
problem, the initial values would be S<9, 10 and 11>.
If you have a four dimensional problem, the values would be
S<9, 9.5, 1, 10.5, and 11>.

If you do not specify a value, some default like 0.2 will be used.

=back

=head1 RETURN

The routine returns a reference to a hash with three elements

=over

=item *
success / failure

=item *
array containing best point

=item *
value at best point

=back

Access them like this:

    my $result = simplex (\%simplex_arg);
    if ($$result {success} == $SPLX_SUCCESS) {
        print "Simplex happy \n"; }

    my $success = $$result{success};
    my @best = @{${$s_arg{result}}{best}};
    my $best_value = $$result {value};
    print "best value of $best_value at \n@best\n";

The element, C<$$result{success}> can have one of three values
which are exported to the caller:

=over

=item $SPLX_SUCCESS

No problems.

=item $SPLX_TOO_MANY

The routine did not converge within the maximum number of iterations.

=item $SPLX_BROKEN

A programming bug.

=back


=head1 NOTES and OPERATION

=over

=item *

The code is taken from Numerical recipes, but much changed.

=item *

On each restart, the simplex is centred at the best value
previously found.

=item *

If the simplex hits a plateau, nothing terrible should happen.
If the best and worst points are on the plateau, it will just
return, which is a bummer. If some of the points are on a
plateau, the whole simplex will just contract about the best
point.

=item *

Do not look for a parameter with the number of dimensions.
Since perl arrays know how big they are, there is no point
in adding another parameter. We get the dimensionality by
looking at the size of the C<@ini_pt> array.

=head1 EXAMPLE

We have a small function like this:

    sub toyfunc ( \@)
    {
        my ($a, $b) = @_;
        return (($a + 8) * ($a + 8) + ($a - 40) * ($a - 40) + 30 * $a * sin($a)
                + $b * $b * $b * $b_);

    }

Then try
    my $fref = \&toyfunc;
    my @guess = (1, 14);
    my @lower = (-10, -3000);
    my @upper = (20, 230);
    my $max_iter = 1000;
    my $max_restart = 5;
    my $f_tol = 10e-7;

    my %result;
    my %s_arg = (
        func        => \&toyfunc,
        ini_pt      => \@guess,
        lower       => \@lower,
        upper       => \@upper,
        max_iter    => $max_iter,
        max_restart => $max_restart,
        o_file      => 'splx_out',
        scatter     => 0.20,
        f_tol       => $f_tol,
        result      => \%result
                 
    );
    
    my $result = simplex (\%s_arg);

    if ($result {success} == $SPLX_SUCCESS) {
        print "Simplex happy \n";
    } elsif ($result {success} == $SPLX_TOO_MANY) {
        print "Simplex too many\n"; }
    for (my $i = 0; $i < $s_arg{n_dim}; $i++) {
        printf '%4g ', "${${$s_arg{result}}{best}}[$i]"; }
    print "\n";


=cut


package Simplex;

use strict;
use POSIX qw(EXIT_SUCCESS EXIT_FAILURE);

use vars qw ($VERSION @ISA @EXPORT);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(simplex $SPLX_SUCCESS $SPLX_TOO_MANY $SPLX_BROKEN);


# ----------------------- Constants     -----------------------------
# INI_SCATTER is the width of the range over which values will be spread.
# If our initial value is 10, and INI_SCATTER = 0.2, then initial
# values will run from 9 .. 11.
use vars qw($INI_SCATTER $ALPHA $BETA $GAMMA);
*INI_SCATTER = \0.20;

# Some values, using names from numerical recipes version
*ALPHA = \-1.0;
*BETA  = \0.5;
*GAMMA = \2.0;

# When checking bounds, we can either fix them or just report them.
use vars qw ($BOUND_OK $BOUND_BROKEN $BOUND_REPORT $BOUND_FIX);
*BOUND_OK     = \0;
*BOUND_BROKEN = \1;

*BOUND_REPORT = \0;
*BOUND_FIX    = \1;

use vars qw($ACCEPT $REJECT
            $SPLX_TOO_MANY $SPLX_SUCCESS $SPLX_BROKEN);

*ACCEPT = \0;
*REJECT = \1;

*SPLX_SUCCESS  = \0;
*SPLX_TOO_MANY = \1;
*SPLX_BROKEN   = \2;

# ----------------------- print_simplex  ----------------------------
# For debugging
sub
print_simplex ($)
{
    my $simplex = shift;
    my $n_dim = $#$simplex;
    for (my $row = 0; $row <= $n_dim; $row++) {
        for (my $i = 0; $i < $n_dim; $i++) {
            printf ("%7g ", $$simplex[$row][$i]); }
        print "\n";
    }
}

# ----------------------- spread_simplex ----------------------------
# Given a simplex and central point, spread values evenly around in
# all dimensions.
# If any dimension is 0.0, then this method will fail, so give it
# a non-zero value.
sub spread_simplex ($ $ $)
{
    my $simplex = shift;
    my $s_arg   = shift;
    my $scatter = shift;

    my $n_dim  = $$s_arg {n_dim};
    my $delta = 1.0 / $n_dim;
    my $ini_pt = $$s_arg {ini_pt};

    my @tmp_row;

    for (my $i = 0; $i < $n_dim; $i++) {
        if ($$ini_pt[$i] == 0.0) {
            $$ini_pt[$i] = 0.1; } }

    for (my $i = 0; $i <= $n_dim; $i++) {
        $tmp_row[$i] = $i * $delta ;          # Spread evenly across range
        $tmp_row[$i] -= 0.5;                  # Shift to range -0.5 .. 0 .. 0.5
    }
    for (my $row = 0; $row <= $n_dim; $row++) {
        for ( my $i = 0; $i < $n_dim; $i++) {
            my $tmp = $$ini_pt[$i];                        # Central point
            $tmp = $tmp + $tmp_row[$i] * $tmp * $scatter;  # add the shift
            $$simplex[$row][$i] = $tmp;
        }
        push (@tmp_row, shift (@tmp_row));
    }
    if (bound_check ($s_arg, $simplex, $BOUND_FIX) == $BOUND_BROKEN) {
        print STDERR "Bound violation setting up initial simplex\n"; }
#   print_simplex ($simplex);
}

# ----------------------- init_y   ----------------------------------
# At start of the day, you have to calculate the function value for
# each of the $ndim+1 points on the simplex.  Return them in the
# $y array.
sub
init_y ($ $ $)
{
    my ($simplex, $y, $func) = @_;
    my $n_dim = $#$simplex;
    for (my $i = 0; $i < $n_dim + 1; $i++) {     # bugger me pink and silly
        $$y[$i] = &$func (@{$$simplex[$i]}); }    # @{$$.. nothing easier ?
}

# ----------------------- get_three     -----------------------------
# Given a list of numbers, return the indices of the highest,
# second highest and lowest - in that order.
sub
get_three (@)
{
    my $list = \@_;
    my $high = 0;
    my $next = 1;
    my $low  = 1;
    if ($$list[$next] > $$list[$high]) {
        $high = 1;
        $next = 0;
        $low  = 0;
    }

    for (my $i = 2; $i <= $#$list; $i++) {
        if ($$list[$i] > $$list[$high]) {
            $next = $high;
            $high = $i;
        } elsif ($$list[$i] >= $$list[$next] ){
            $next = $i;
        } elsif ($$list[$i] < $$list[$low]) {
            $low = $i;
        }
    }
    return ($high, $next, $low);
}

# ----------------------- point_check -------------------------------
# Check if a trial point is within bounds.
sub
point_check ($ $ )
{
    my $s_arg = shift;
    my $point = shift;
    if (defined ($$s_arg{lower})) {
        my $lower = $$s_arg {lower};
        for (my $i = 0; $i <= $#$point; $i++) {
            if ($$point [$i] < $$lower [$i]) {
                return $BOUND_BROKEN;
            }
        }
    }
    if (defined ($$s_arg{upper})) {
        my $upper = $$s_arg {upper};
        for (my $i = 0; $i <=$#$point; $i++) {
            if ($$point [$i] > $$upper [$i]) {
                return $BOUND_BROKEN;
            }
        }
    }
}

# ----------------------- bound_check -------------------------------
# We are given a simplex as well as upper and lower bounds.
# The last argument tells us if we should fix bounds, or just report
# them.
sub
bound_check ($ $ $)
{
    my $s_arg   = shift;
    my $simplex = shift;
    my $todo    = shift;
    my $result  = $BOUND_OK;

    if (defined ($$s_arg{lower})) {
        my $lower = $$s_arg {lower};
        for (my $i = 0; $i < $#$simplex + 1; $i++) {
            for (my $j = 0; $j < $#$simplex; $j++) {
                if ($$simplex[$i][$j] < $$lower[$j]) {
                    $result = $BOUND_BROKEN;
                    if ($todo == $BOUND_FIX) {
                        $$simplex[$i][$j] = $$lower[$j];
                    }
                }
            }
        }
    }

    if (defined ($$s_arg{upper})) {
        my $upper = $$s_arg{upper};
        for (my $i = 0; $i < $#$simplex + 1; $i++) {
            for (my $j = 0; $j < $#$simplex; $j++) {
                if ($$simplex[$i][$j] > $$upper[$j]) {
                    $result = $BOUND_BROKEN;
                    if ($todo == $BOUND_FIX) {
                        $$simplex[$i][$j] = $$upper[$j];
                    }
                }
            }
        }
    }

    return $result;
}

# ----------------------- get_psum   --------------------------------
sub
get_psum ($ $)
{
    my ($simplex, $n_dim) = @_;
    my @psum;
    for (my $j = 0; $j < $n_dim; $j++) {
        my $sum = 0.0;
        for (my $i = 0; $i < $n_dim + 1; $i++) {
            $sum += $$simplex [$i][$j];
            $psum [$j] = $sum;
        }
    }
    return @psum;
}

# ----------------------- splx_out  ---------------------------------
# Output success or path of simplex.
# We want to be able to look at accepted points and best points at
# each step. These are not the same.
# At any cycle, we may replace the highest point. The new point is
# part of the simplex, but it is not necessarily the best point.
# We also need to keep track of the best point at each step.
# Lets write them to separate files.
sub
splx_out ($ $ $ $ $ $ $ $) {
    my $step     = shift;
    my $low      = shift;
    my $high     = shift;
    my $simplex  = shift;
    my $y        = shift;
    my $bestfile = shift;       # For best current point
    my $highfile = shift;       # Worst (highest) current point
    my $move     = shift;

    my $gfmt = " %.4g";
    printf $bestfile "%d $gfmt",$step, $$y[$low];
    for (my $i = 0; $i < $#$simplex; $i++) {
        printf $bestfile $gfmt, $$simplex[$low][$i]; }
    printf $bestfile "\n";

    printf $highfile "%d $gfmt",$step, $$y[$high];
    for (my $i = 0; $i < $#$simplex; $i++) {
        printf $highfile $gfmt, $$simplex[$high][$i]; }

    print $highfile  " $move\n";
}


# ----------------------- amotry      -------------------------------
sub
amotry ($ $ $ $ $ $)
{
    my $s_arg   = shift;
    my $simplex = shift;
    my $y       = shift;
    my $psum    = shift;
    my $high    = shift;
    my $fac     = shift;
    my $func    = $$s_arg {func};
    my $n_dim = $#$y;
    my @ptry;  # This will be our trial point
    my $ytry;  # Function value at trial point
    my ($fac1, $fac2);
    my $accept = $REJECT;
    $fac1 = (1.0 - $fac) / $n_dim;
    $fac2 = $fac1 - $fac;
    for ( my $j = 0; $j < $n_dim; $j++) {
        $ptry [$j] = $$psum [$j] * $fac1 - $$simplex [$high][$j] * $fac2; }
    if (point_check ($s_arg, \@ptry) == $BOUND_BROKEN) {
        print STDERR "Point out of bounds\n",
        return ($$y[$high] + 1);
    }
    $ytry = &$func ( @ptry);

    if ( $ytry < $$y[$high]) {   # This is good, so replace highest point
        $accept = $ACCEPT;
        $$y[$high] = $ytry;
        for (my $j = 0; $j < $n_dim; $j++) {
            $$psum [$j] += $ptry [$j] - $$simplex[$high] [$j]; }
        @{$$simplex[$high]} = @ptry;
    }
    return ($ytry, $accept);
}

# ----------------------- simplex_once  -----------------------------
sub
simplex_once ($)
{
    my ($s_arg) = @_;
    my $func        = $$s_arg {func};
    my $n_dim       = $$s_arg {n_dim};
    my $ini_pt      = $$s_arg {ini_pt};
    my $f_tol       = $$s_arg {f_tol};
    my $max_iter    = $$s_arg {max_iter};
    my $o_file_low  = $$s_arg {o_file_low};
    my $o_file_hi   = $$s_arg {o_file_hi};
    my $result      = $$s_arg {result};

    my @psum;         # Geometric hack stores vertex sums (saves a nanosecond)
    my $ncycle = 0;   # count of number of cycles through main loop

    my @simplex;
    $simplex[$n_dim][$n_dim - 1] = 0.0;

    my $scatter;
    if (defined ($$s_arg {scatter})) {
        $scatter = $$s_arg {scatter}; }
    else {
        $scatter = $$s_arg {scatter} = $INI_SCATTER / 2.0; }
#   Now, lets build the simplex.
    spread_simplex (\@simplex, $s_arg, $scatter);
#   print "initial simplex\n";
#   print_simplex (\@simplex);
    my @y;                 # Array of function values
    init_y (\@simplex, \@y, $func);
    @psum = get_psum (\@simplex, $n_dim);
    my $prev_worst = $y[0];
    my $move = '';
    while (1) {
        my $ytry;
        my ($high, $next, $ilo) = get_three (@y);
        splx_out( $ncycle,$ilo, $high, \@simplex, \@y,$o_file_low,
                  $o_file_hi, $move);
        $move = '';
        my @foo = @{$simplex[$ilo]};  # Save best point so far
        $$result{best} =   \@foo;
        $$result{value} =  $y[$ilo];
        $$result{ncycle} = $ncycle;
        {
            my $diff = $y[$high] - $y[$ilo];
            if ($diff < $f_tol) {
                $diff = abs ($prev_worst - $y[$high]);
                if ($diff < $f_tol) {
                    $$result { success } = $SPLX_SUCCESS;
                    return ($result) ;
                }
            }
        }
        if ($ncycle >= $max_iter) {
            $$result {success} = $SPLX_TOO_MANY;
            return ($result);
        }
        $prev_worst = $y[$high];
        my $a;
        ($ytry, $a) = amotry ($s_arg, \@simplex, \@y, \@psum, $high, $ALPHA);
        if ($a == $ACCEPT) {
            $move = 'r'; }
        if ($ytry <= $y[$ilo]) {       # Better than best point, try extension
            ($ytry, $a) =amotry ($s_arg,\@simplex, \@y, \@psum, $high, $GAMMA);
            if ($a == $ACCEPT) {$move .= 'e' }
        } elsif ($ytry >= $y[$next]) { # Little progress, so try 1d contract
            my $ysave = $y[$high];
            ($ytry,$a) = amotry ($s_arg, \@simplex, \@y, \@psum, $high, $BETA);
            if ($a == $ACCEPT) {$move .= 'c' }
            if ($ytry >= $ysave) {     # No improvement, do complete contract
                $move .= 'a';
                for (my $i = 0; $i < $n_dim + 1; $i++) {
                    my @tmp;
                    if ( $i != $ilo) {
                        for (my $j = 0; $j < $n_dim; $j++) {
                            $tmp[$j] = 0.5 * ($simplex[$i][$j] +
                                              $simplex[$ilo][$j] );
                        }
                        @{$simplex[$i]} = @tmp;
                        $y[$i] = &$func (@tmp);
                    }
                }
                @psum = get_psum (\@simplex, $n_dim);
            }
        }
        $ncycle++;
    }
}

# ----------------------- input_sane    -----------------------------
# Check for obligatory arguments for simplex
sub
input_sane ($)
{
    my $s_arg = shift;
    my $r = EXIT_SUCCESS;
    if ( ! defined ($$s_arg {func})) {
        print STDERR "Simplex: func not defined. Check args\n";
        $r = EXIT_FAILURE;
    }
    if ( ! defined ($$s_arg {ini_pt})) {
        print STDERR "Simplex: No initial guess (ini_pt). Check args\n";
        $r = EXIT_FAILURE;
    }
    if ( ! defined ($$s_arg {max_iter})) {
        print STDERR "Simplex: max_iter not set. Check args\n";
        $r = EXIT_FAILURE;
    }
    if ( ! defined ($$s_arg {max_restart})) {
        print STDERR "Simplex: max_restart not set. Check args\n";
        $r = EXIT_FAILURE;
    }
    if ( ! defined ($$s_arg {f_tol})) {
        print STDERR "Simplex: f_tol not set. Check args\n";
        $r = EXIT_FAILURE;
    }

    return ($r);
}

# ----------------------- simplex       -----------------------------
# This is the callable simplex interface.
# It will call simplex_once() for up to $max_restart times.
sub
simplex ($)
{
    use IO::Handle;
    my ($s_arg) = @_;
    my $r;

    if (input_sane ($s_arg) == EXIT_FAILURE) {        # Fancy stuff.. return of
        return ({ 'success' => $SPLX_BROKEN }); }     # an anonymous hash

    my $max_restart = $$s_arg {max_restart};

    if (defined ($$s_arg {o_file}) ) {
        my $o_file = $$s_arg {o_file };
        my $o_file_hi  = $o_file . '_hi.out';
        my $o_file_low = $o_file . '_low.out';
        open (O_FILE_HI,  ">$o_file_hi")  || die "Fail open $o_file_hi: $!";
        open (O_FILE_LOW, ">$o_file_low") || die "Fail open $o_file_low: $!";
        O_FILE_HI->autoflush(1);
        O_FILE_LOW->autoflush(1);
    }
    if ( ! defined ($$s_arg {n_dim})) {
        $$s_arg {n_dim} = $#{$$s_arg{ini_pt}} + 1;}
    $$s_arg{o_file_low}  = \*O_FILE_LOW;
    $$s_arg{o_file_hi} =   \*O_FILE_HI;
    my $prev_best = undef;
    my $i;
    for ($i = 0; $i < $max_restart; $i++) {
        $r = simplex_once ($s_arg);
        @{$$s_arg {ini_pt}} = @{$$r{best}};
        my $improve = abs( $prev_best - $$r{value});
        if ($improve < $$s_arg{f_tol}) {
            last; }
        $prev_best = $$r{value};
        $$s_arg {scatter} /= 2.0;
        print O_FILE_HI "\n";
        print O_FILE_LOW "\n";
    }
    close (O_FILE_HI);
    close (O_FILE_LOW);
    $$r{restart} = $i;
    return $r;
}

return 1;
