#!/usr/bin/env perl -w

use strict;
use Test::Simple tests => 2;
use IO::All;
use Graph;
use Graph::Writer::GraphViz;

sub normalized {
    my $s = shift;
    $s =~ s/\d+/0/g;
    $s =~ s/\s+/ /g;
    # Sort the the graph output, as it comes out
    # in hash order which isn't necessarily stable.
    $s = join "\n", sort split /\n/, $s;
    return $s;
}

my @v = qw/Alice Bob Crude Dr/;
my $g = Graph->new;
$g->add_vertices(@v);

my $wr = Graph::Writer::GraphViz->new(-format => 'plain');
$wr->write_graph($g,'t/graph.simple.dot');

ok(-f 't/graph.simple.dot');

$/ = undef;
my $g1 = <DATA>;
my $g2 = io('t/graph.simple.dot')->slurp;

$g1 = normalized($g1);
$g2 = normalized($g2);

ok($g1 eq $g2);
unlink('t/graph.simple.dot');

__DATA__
graph 1 4.3624 0.5
node Alice 3.884 0.25 0.95686 0.5 Alice solid ellipse black black
node Bob 2.759 0.25 0.79437 0.5 Bob solid ellipse black black
node Crude 0.55065 0.25 1.1013 0.5 Crude solid ellipse black black
node Dr 1.7312 0.25 0.75 0.5 Dr solid ellipse black black
stop
