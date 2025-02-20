source plate.tcl
source template.tcl
bfuse AA_holder plate payload 
incmesh AA_holder .1

set curdir [eval pwd]
cd $output_path
writestl AA_holder [eval format "AA_holder_%dx%d.stl" $rows $columns] 
cd $curdir