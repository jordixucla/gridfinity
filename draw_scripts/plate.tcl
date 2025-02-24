# Before running this script, invoke the following commands:
# pload ALL
autodisplay 0

source configure.tcl

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
if {$use_magnets == 1 || $use_screws == 1} {
    source holes.tcl
    bcut base_unit base_unit holes
}

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
if {$use_lip == 1} {
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
}

autodisplay 1
display plate

# save the file to stl
incmesh plate .1
set options ".stl"
if {$use_magnets == 1} {set options "_magnets$options"} 
if {$use_lip == 1} {set options "_lip$options"} 
if {$use_screws == 1} {set options "_screws$options"} 

set curdir [eval pwd]
cd $output_path
writestl plate  [eval format "plate_%dx%dx%d%s" $rows $columns $units $options]
cd $curdir