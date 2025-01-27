set s [expr {$base_length - $base_diameter -.5}]
set r [expr {$r2 - .25}]
profile p P 0 0 1 1 0 0  \
F 0 0  \
X $s C $r 90   \
Y $s C $r 90  \
X -$s C $r  90 \
Y -$s C $r 90 W
ttranslate p $r2 .25 0
