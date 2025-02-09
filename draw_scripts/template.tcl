source configure.tcl

set sx [expr {$base_length*$rows - $base_diameter -.5}]
set sy [expr {$base_length*$columns - $base_diameter -.5}]
set r [expr {$r2 - .25}]
profile p P 0 0 1 1 0 0  \
F 0 0  \
X $sx C $r 90   \
Y $sy C $r 90  \
X -$sx C $r  90 \
Y -$sy C $r 90 W
ttranslate p $r2 .25 0

mkplane fr p
prism content fr  0 0 10
ttranslate content 0 0 $height

set r 7.5
set sep 16.75
set h 50
pcylinder h1 $r $h
ttranslate h1 [ expr {$r + 1}] [ expr {$r + .5 }] $height
copytranslate h2 h1 $sep 0 0
copytranslate h3 h2 $sep 0 0
copytranslate h4 h3 $sep 0 0
copytranslate h5 h4 $sep 0 0

copytranslate h1_2 h1 [ expr {$r +1}] [ expr {$r * 2-2.2}] 0 
copytranslate h2_2 h1_2 $sep 0 0
copytranslate h3_2 h2_2 $sep 0 0
copytranslate h4_2 h3_2 $sep 0 0

copytranslate h1_1 h1 0 [ expr {$r * 3+3}] 0 
copytranslate h2_1 h1_1 $sep 0 0
copytranslate h3_1 h2_1 $sep 0 0
copytranslate h4_1 h3_1 $sep 0 0
copytranslate h5_1 h4_1 $sep 0 0

compound h1 h2 h3 h4 h5 h1_1 h2_1 h3_1 h4_1 h5_1 h1_2 h2_2 h3_2 h4_2 holes
bcut payload content holes