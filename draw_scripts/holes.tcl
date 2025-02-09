source configure.tcl

# create 4 holes
pcylinder h $magnet_hole_radius $magnet_hole_heigth
pcylinder h1 $screw_hole_radius 4  
ttranslate h1 0 0 .5
if {$use_screws == 1} {bfuse h h1 h}

set delta [expr {$length - $separation}]
copytranslate h1 h $separation $separation 0
copytranslate h2 h $separation $delta 0
copytranslate h3 h $delta $separation 0
copytranslate h4 h $delta $delta 0
compound  h1 h2 h3 h4 holes

# create platform for the holes
box b $base_length $base_length $holes_height
pcylinder bl [expr {$base_length/3}] 4
ttranslate bl [expr {$base_length/2}] [expr {$base_length/2}] 0
bcut b b bl
copy holes mholes
tmirror mholes  0 0 [expr {$holes_height/2}]  0 0 1

bcut base_holes b mholes
