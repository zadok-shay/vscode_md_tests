#!/usr/bin/env gnuplot

filename = './resource/piechart.csv'

$DATABLOCK << EOD  
name,age
A,20
B,30
C,90
D,100
EEEEEE,100
EOD  

rowi = 1
rowf = 30

# obtain sum(column(2)) from rows `rowi` to `rowf`
set datafile separator ','
stats $DATABLOCK u 2 every ::rowi::rowf noout prefix "A"

# rowf should not be greater than length of file
rowf = (rowf-rowi > A_records - 1 ? A_records + rowi - 1 : rowf)

angle(x)=x*360/A_sum
percentage(x)=x*100/A_sum

# circumference dimensions for pie-chart
centerX=0
centerY=0
radius=1

# label positions
yposmin = 0.0
yposmax = 0.95*radius
xpos = 1.5*radius
ypos(i) = yposmax - i*(yposmax-yposmin)/(1.0*rowf-rowi)

#-------------------------------------------------------------------
# now we can configure the canvas
set style fill solid 1     # filled pie-chart
unset key                  # no automatic labels
unset tics                 # remove tics
unset border               # remove borders; if some label is missing, comment to see what is happening

set size ratio -1              # equal scale length
set xrange [-radius:2*radius]  # [-1:2] leaves space for labels
set yrange [-radius:radius]    # [-1:1]

#-------------------------------------------------------------------
pos = 0             # init angle
colour = 0          # init colour

# 1st line: plot pie-chart
# 2nd line: draw colored boxes at (xpos):(ypos)
# 3rd line: place labels at (xpos+offset):(ypos)

set terminal svg
set output 'images/piechart.svg'
plot $DATABLOCK u (centerX):(centerY):(radius):(pos):(pos=pos+angle($2)):(colour=colour+1) every ::rowi::rowf w circle lc var,\
     for [i=0:rowf-rowi] '+' u (xpos):(ypos(i)) w p pt 5 ps 4 lc i+1,\
     for [i=0:rowf-rowi] $DATABLOCK u (xpos):(ypos(i)):(sprintf('%2.1f%%, %s, %s', percentage($2), stringcolumn(2), stringcolumn(1))) every ::i+rowi::i+rowi w labels left offset 3,0

set terminal png
set output 'images/piechart.png'
plot $DATABLOCK u (centerX):(centerY):(radius):(pos):(pos=pos+angle($2)):(colour=colour+1) every ::rowi::rowf w circle lc var,\
     for [i=0:rowf-rowi] '+' u (xpos):(ypos(i)) w p pt 5 ps 4 lc i+1,\
     for [i=0:rowf-rowi] $DATABLOCK u (xpos):(ypos(i)):(sprintf('%05.2f%% %s', percentage($2), stringcolumn(1))) every ::i+rowi::i+rowi w labels left offset 3,0
