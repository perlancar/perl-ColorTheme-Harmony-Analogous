package ColorTheme::Harmony::Analogous;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;
use parent 'ColorThemeBase::Static::FromObjectColors';

# TODO: allow some colors to have a different saturation, like in
# color.adobe.com

our %THEME = (
    v => 2,
    summary => 'Create theme with colors equidistant in hue',
    description => <<'_',

This color theme has a central color (e.g. for 5 colors, `color3`) with the hue
of *central_h*. Half of the other colors are on the left in the color wheel,
with equal distance of *h_distance*, while the other half are on the right.
The colors will have the same saturation and brightness.

Example, for 5 colors, *central_h* of 120 (green) and *h_distance* of 35 then
`color3` will have hue 120, `color2` 90, `color1` 60, `color4` 150, `color5`
180. You can see this on the terminal with:

    % show-color-theme-swatch Harmony::Analogous=central_h,120,h_distance,35,s,0.8

_
    dynamic => 1,
    args => {
        n => {
            summary => 'Number of colors in the theme',
            schema => ['posodd*', max=>99], # give a sane maximum
            default => 5,
        },
        central_h => {
            summary => 'Hue of the central color',
            schema => ['num*', between=>[0, 360]],
            req => 1,
        },
        h_distance => {
            summary => 'Hue distance between one color and the next, in degrees',
            schema => ['num*', between=>[0, 360]],
            default => 30,
        },
        s => {
            summary => 'Saturation of the colors',
            schema => ['num*', between=>[0, 1]],
            default => 1,
        },
        v => {
            summary => 'Brightness of the colors',
            schema => ['num*', between=>[0, 1]],
            default => 1,
        },
    },
    examples => [
        {
            summary => 'An analogous theme around red',
            args => {central_h=>0},
        },
    ],
);

sub new {
    require Color::RGB::Util;

    my $class = shift;
    my $self = $class->SUPER::new(@_);

    my %colors;

    my $central_h = $self->{args}{central_h};
    my $h_distance = $self->{args}{h_distance};
    my $s = $self->{args}{s};
    my $v = $self->{args}{v};
    my $n = $self->{args}{n};

    my $i_central = int($n/2)+1;
    $colors{"color$i_central"} = Color::RGB::Util::hsv2rgb("$central_h $s $v");
    for my $i (1..$i_central-1) {
        $colors{"color" . ($i_central-$i)} = Color::RGB::Util::hsv2rgb(sprintf "%d %.4f %.4f", $central_h-$i*$h_distance, $s, $v);
        $colors{"color" . ($i_central+$i)} = Color::RGB::Util::hsv2rgb(sprintf "%d %.4f %.4f", $central_h+$i*$h_distance, $s, $v);
    }

    $self->{items} = \%colors;
    $self;
}

1;
# ABSTRACT:

=head1 SEE ALSO

Other C<ColorTheme::Harmony::*> modules.
