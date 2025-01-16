# Baseplate
set base_length 42
set base_diameter 8 
set base_height 5

set base_bottom_fillet 0.7
set base_mid_height 1.8
set base_upper_fillet 2.15

set base_straight [expr {$base_length - $base_diameter}]
set r $base_bottom_fillet
set r2 [expr {$base_diameter/2}]
set disp [expr {$base_bottom_fillet + $base_upper_fillet}]
profile b P 0 0 1 1 0 0  F $r2 0 X $base_straight C $r2 90   Y $base_straight C $r2  90  X -$base_straight   c $r2  90 Y -$base_straight  c $r2 90 W

set d [expr {$base_bottom_fillet * 2}]
profile p P 0 -1 0 1 0 0  O [expr {$base_length - $disp}] $r2 0  T $base_bottom_fillet $base_bottom_fillet  Y $base_mid_height  T $base_upper_fillet $base_upper_fillet Y -$base_height  X -[expr {$base_bottom_fillet + $base_upper_fillet}] W

pipe baseplate b p