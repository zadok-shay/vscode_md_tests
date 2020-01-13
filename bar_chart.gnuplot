#!/usr/bin/env gnuplot


$DATABLOCK << EOD  
"label"       100
label2      450
"bar label" 75
X 75
y 75
EOD  


set boxwidth 0.5
set style fill solid


set terminal svg
set output 'images/barchart.svg'
plot $DATABLOCK using 2:xtic(1) with boxes

set terminal png
set output 'images/barchart.png'
plot $DATABLOCK using 2:xtic(1) with boxes
