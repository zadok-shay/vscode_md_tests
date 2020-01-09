#!/usr/bin/env gnuplot

set output 'images/sin.svg'
set terminal svg
set title "Simple Plots" font ",20"
set key left box
set samples 50
set style data points

plot [-10:10] sin(x),atan(x),cos(atan(x))

set output 'images/sin.png'
set terminal png
plot [-10:10] sin(x),atan(x),cos(atan(x))
