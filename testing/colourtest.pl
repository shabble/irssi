#!/usr/bin/env perl

# /* Low-intensity colors. Add 8 for bright */
# /* COLOR_BLACK   0 */
# /* COLOR_RED     1 */
# /* COLOR_GREEN   2 */
# /* COLOR_YELLOW  3 */
# /* COLOR_BLUE    4 */
# /* COLOR_MAGENT  5 */
# /* COLOR_CYAN    6 */
# /* COLOR_WHITE   7 */
	

use strict;
use warnings;
use feature qw/say switch/;

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

sub test16bg {
    say ""; #print " ";
    for my $x (0..7) {
	my $f;
	given ($x) {
	    when (0) {$f = 7 }
	    when (7) {$f = 0 }
	    default { $f = 0 }
	}

        print bg($x) . fg($f) . sprintf("%02d", $x);
    }
    say rst; # print " ";
    for my $x (8..15) {
        print bg($x) . sprintf("%02d", $x);
    }
    say rst;
    say "";
}

sub test256bg {

    for my $x (0..15) {
        for my $y (0..15) {
            my $z = ($x * 16) + ($y);
            print bg($z) . sprintf("%03d", $z);
	    print rst . " ";
        }
        say rst;
    }
}

sub test256fg {

    for my $x (0..15) {
        for my $y (0..15) {
            my $z = ($x * 16) + ($y);
            print fg($z) . sprintf("%03d", $z);
	    print rst . " ";
        }
        say rst;
    }
}

test256bg();
print "\n";
test256fg();
print "\n";
test16bg();
