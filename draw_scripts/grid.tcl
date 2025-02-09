autodisplay 0

source configure.tcl

#grid path
set base_straight [expr {$base_length - $base_diameter}]
set r $base_bottom_fillet
set r2 [expr {$base_diameter/2}]
set disp [expr {$base_bottom_fillet + $base_upper_fillet}]
profile grid_path P 0 0 1 1 0 0  F $r2 0 X $base_straight C $r2 90   Y $base_straight C $r2  90  X -$base_straight   c $r2  90 Y -$base_straight  c $r2 90 W

#grid profile
set d [expr {$base_bottom_fillet * 2}]
profile grid_profile P 0 -1 0 1 0 0  \
O [expr {$base_length - $disp}] $r2 0 \
T $base_bottom_fillet $base_bottom_fillet \
Y $base_mid_height \
T $base_upper_fillet $base_upper_fillet  \
T $base_upper_fillet -$base_upper_fillet  \
Y -$base_mid_height \
T $base_bottom_fillet -$base_bottom_fillet \
X -[expr {$base_bottom_fillet + $base_upper_fillet}] \
W
mkplane fp grid_profile
pipe bp grid_path fp

# add holes
source holes.tcl
ttranslate bp 0 0 $holes_height
bfuse bp bp base_holes

# creating a rows x columns units plate
for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $columns} {incr j} {
        set name [format "r%d%d" $i $j]
        set x [expr {$i * 42}]
        set y [expr {$j * 42}]
        copytranslate v$name bp $x $y 0
    }
}

shape m So
for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $columns} {incr j} {
        bfuse m m [format "vr%d%d" $i $j]
    }
}

box c $base_length*$rows $base_length*$columns 10
bop c m
bopcommon baseplate 

autodisplay 1
incmesh baseplate .1
writestl baseplate  [eval format "baseplate_%dx%d.stl" $rows $columns]