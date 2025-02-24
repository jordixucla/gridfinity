source plate.tcl

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

set r 5.75
set sep 12.75
set h 50
pcylinder h1 $r $h
ttranslate h1 [ expr {$r + 4}] [ expr {$r + 4 }] $height
copytranslate h2 h1 $sep 0 0
copytranslate h3 h2 $sep 0 0
copytranslate h4 h3 $sep 0 0
copytranslate h5 h4 $sep 0 0
copytranslate h6 h5 $sep 0 0

copytranslate h1_2 h1 [ expr {$r +.5}] [ expr {$r * 2-0.5}] 0 
copytranslate h2_2 h1_2 $sep 0 0
copytranslate h3_2 h2_2 $sep 0 0
copytranslate h4_2 h3_2 $sep 0 0
copytranslate h5_2 h4_2 $sep 0 0

copytranslate h1_1 h1 0 [ expr {$r * 3+4.5}] 0 
copytranslate h2_1 h1_1 $sep 0 0
copytranslate h3_1 h2_1 $sep 0 0
copytranslate h4_1 h3_1 $sep 0 0
copytranslate h5_1 h4_1 $sep 0 0
copytranslate h6_1 h5_1 $sep 0 0

compound h1 h2 h3 h4 h5 h6 h1_1 h2_1 h3_1 h4_1 h5_1 h6_1 h1_2 h2_2 h3_2 h4_2 h5_2 holes
bcut payload content holes
bfuse AAA_holder plate payload 
donly AAA_holder
fit

set curdir [eval pwd]
cd $output_path
incmesh AAA_holder .1
writestl AAA_holder [eval format "AA_holder_%dx%d.stl" $rows $columns] 
cd $curdir