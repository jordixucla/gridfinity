# Before running this script, invoke the following commands:
# pload ALL

# Define a variable to store the length
set length 41.5
set diameter 7.5
set height 5
set unit_height 7

set profile_bottom_fillet 0.8
set profile_mid_height 1.8
set profile_upper_fillet 2.15

set rows 3
set columns 1
set units 2 

profile b P 0 0 1 1 0 0   T 0 $length  T $length 0 T 0 -$length W
profile p P 0 -1 0 1 0 0 F $length 0  T 0.8 0.8   Y 1.8  T 2.15 2.15  WW

# Profile creation
# Calculate the sum of length and profile_bottom_fillet
set profile_straight [expr {$length - $diameter}]
set r $profile_bottom_fillet
set r2 [expr {$diameter/2}]
set disp -[expr {$profile_bottom_fillet + $profile_upper_fillet}]
profile b P 0 0 1 1 0 0  F $r2 [expr {$r2 - $profile_bottom_fillet}]  X $profile_straight C $r 90   Y $profile_straight C $r  90  X -$profile_straight   c $r  90 Y -$profile_straight  c $r 90 W
profile b2 O 0 0 $height P 0 0 1 1 0 0  F $r2 0 X $profile_straight C $r2 90   Y $profile_straight  C $r2 90  X -$profile_straight    c $r2 90 Y -$profile_straight   c $r2 90 W
prism pb2 b2 0 0 -[expr {$height - $profile_bottom_fillet - $profile_upper_fillet-$profile_mid_height}]

set d [expr {$profile_bottom_fillet * 2}]
profile p  P 0 -1 0 1 0 0  O $length $r2 [expr {$profile_bottom_fillet + $profile_upper_fillet + $profile_mid_height}]  T -$profile_upper_fillet -$profile_upper_fillet  Y -$profile_mid_height  T -$profile_bottom_fillet -$profile_bottom_fillet  WW
pipe r b p
mkplane fb b
mkplane fb2 b2
sewing base r fb fb2 pb2 
mkvolume base base

# creating a 4x4 plate
box c 42*$rows 42*$columns [expr {2 + $unit_height*$units}]
explode c e
blend bc c $r2 c_1 $r2 c_3 $r2 c_5 $r2 c_7
explode bc f
offsetcompshape bc bc -1 bc_2 
ttranslate bc -.25 -.25 [expr {$unit_height - 2}]

set bx_list {}
for {set i 0} {$i < $rows} {incr i} {
    for {set j 0} {$j < $columns} {incr j} {
        set name [format "b%d_%d" $i $j]
        set x [expr {$i * 42}]
        set y [expr {$j * 42}]
        copytranslate v$name base $x $y 0
        lappend bx_list v$name
    }
}
compound  {*}$bx_list base

bfuse plate base bc

# save the file to stl
writestl plate  [eval format "plate_%d_%d_%d.stl" $rows $columns $units]