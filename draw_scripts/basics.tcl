# Before running this script, invoke the following commands:
# pload ALL

# Define a variable to store the length
set length 41.5
set diameter 7.5
set height 7

set profile_bottom_fillet 0.8
set profile_mid_height 1.8
set profile_upper_fillet 2.15

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

# # Creating a copy of the shape
# copytranslate r3 r2 41.5 0 0

# # Create the volumes and fuse them
# mkvolume v2 r2
# mkvolume v3 r3

# bfuse x v2 v3
# checkshape x
