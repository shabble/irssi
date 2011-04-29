#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/say/;

sub fg ($) {
    my ($val) = @_;
    return sprintf("\e[38;5;%dm", $val);
}
sub bg ($) {
    my ($val) = @_;
    return sprintf("\e[48;5;%dm", $val);
}

sub rst () {
    return "\e[0m";
}

sub test16 {
    say ""; print " ";
    for (0..7) {
        print bg($_) . " ";
    }
    say rst; print " ";
    for (8..15) {
        print bg($_) . " ";
    }
    say rst;
    say "";
}

sub test256 {

    for my $x (0..15) {
        for my $y (0..15) {
            my $z = ($x * 16) + ($y);
            print bg($z) . " ";
        }
        say rst;
    }
}
test256();
#test16();
