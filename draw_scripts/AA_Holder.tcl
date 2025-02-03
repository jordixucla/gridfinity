source plate.tcl
source template.tcl
bfuse AA_holder plate payload 
incmesh AA_holder .1
writestl AA_holder [eval format "AA_holder_%dx%d.stl" $rows $columns] 