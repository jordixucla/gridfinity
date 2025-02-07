# set length 41.5
# set separation 7.75

pcylinder h2 3.5 2.5
pcylinder h1 1.5 4  
ttranslate h1 0 0 .5
bfuse h h1 h2

set delta [expr {$length - $separation}]
copytranslate h1 h $separation $separation 0
copytranslate h2 h $separation $delta 0
copytranslate h3 h $delta $separation 0
copytranslate h4 h $delta $delta 0
compound  h1 h2 h3 h4 holes