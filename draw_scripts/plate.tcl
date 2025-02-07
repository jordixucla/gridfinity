# Before running this script, invoke the following commands:
# pload ALL
autodisplay 0

# Define a variable to store the length
set length 41.5
set diameter 7.5
set height 5
set unit_height 7

set profile_bottom_fillet 0.8
set profile_mid_height 1.8
set profile_upper_fillet 2.15

set stacking_upper_fillet 1.9

set base_length 42
set base_diameter 8 
set base_height 5

set base_bottom_fillet 0.7
set base_mid_height 1.8
set base_upper_fillet 2.15

set rows 1
set columns 2
set units 4 

# Create a base unit
set profile_straight [expr {$length - $diameter}]
set r1 $profile_bottom_fillet
set r2 [expr {$diameter/2}]
set disp -[expr {$profile_bottom_fillet + $profile_upper_fillet}]
profile unit_path P 0 0 1 1 0 0  F $r2 [expr {$r2 - $profile_bottom_fillet}]  X $profile_straight C $r1 90   Y $profile_straight C $r1  90  X -$profile_straight   c $r1  90 Y -$profile_straight  c $r1 90 W
profile b2 O 0 0 $height P 0 0 1 1 0 0  F $r2 0 X $profile_straight C $r2 90   Y $profile_straight  C $r2 90  X -$profile_straight    c $r2 90 Y -$profile_straight   c $r2 90 W
prism pb2 b2 0 0 -[expr {$height - $profile_bottom_fillet - $profile_upper_fillet-$profile_mid_height}]
mkplane fb2 b2

set d [expr {$profile_bottom_fillet * 2}]
profile unit_section  P 0 -1 0 1 0 0  O $length $r2 [expr {$profile_bottom_fillet + $profile_upper_fillet + $profile_mid_height}]  T -$profile_upper_fillet -$profile_upper_fillet  Y -$profile_mid_height  T -$profile_bottom_fillet -$profile_bottom_fillet  WW
pipe r unit_path unit_section
mkplane fb unit_path
sewing base_unit r fb fb2 pb2 
mkvolume base_unit base_unit

# holes
source holes.tcl
bcut base_unit base_unit holes

# creating a rows x columns units plate
set blength [expr {$base_length*$rows}]
set bwidth [expr {$base_length*$columns}]
box c $blength $bwidth [expr {2 + $unit_height*$units}]
ttranslate c -.25 -.25 [expr {$unit_height - 2}]
explode c e
set r2 [expr {$base_diameter/2}]
blend bc c $r2 c_1 $r2 c_3 $r2 c_5 $r2 c_7
explode bc f
offsetcompshape bc bc -1 bc_2 

# merging alltogether
set bx_list {}
for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $columns} {incr j} {
        set name [format "b%d_%d" $i $j]
        set x [expr {$i * $base_length}]
        set y [expr {$j * $base_length}]
        copytranslate v$name base_unit $x $y 0
        lappend bx_list v$name
    }
}
compound  {*}$bx_list base
bfuse plate base bc

# # create the stacking lip
set lp [expr {$base_length*$rows - $base_diameter}]
set wp [expr {$base_length*$columns - $base_diameter}]
profile lip_path P 0 0 1 1 0 0  \
F $r2 0 \
X $lp C $r2 90 \
Y $wp C $r2 90 \
X -$lp C $r2 90 \
Y -$wp C $r2 90 W

profile lip_section  P 0 -1 0 1 0 0  \
O [expr {$lp + $base_diameter }] $r2 0 \
Y [expr {$stacking_upper_fillet + $base_mid_height + $base_bottom_fillet}]  \
T -$stacking_upper_fillet -$stacking_upper_fillet \
Y -$base_mid_height \
T -$base_bottom_fillet -$base_bottom_fillet  \
TT 0 -1 W
mkplane lip_section lip_section

ttranslate lip_path -.25 -.25 [expr {$unit_height*($units+1)}]
ttranslate lip_section -.25 -.25 [expr {$unit_height*($units+1)}]
pipe lip lip_path lip_section

bfuse plate plate lip

autodisplay 1
display plate

# save the file to stl
incmesh plate .1
writestl plate  [eval format "plate_%dx%dx%d.stl" $rows $columns $units]