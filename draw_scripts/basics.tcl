# Before running this script, invoke the following commands:
# pload ALL

profile b P 0 0 1 1 0 0   T 0 35.6  T 35.6 0 T 0 -35.6 W
profile p P 0 -1 0 1 0 0 F 35.6 0  T 0.8 0.8   Y 1.8  T 2.15 2.15  WW

# Profile creation
profile b P 0 0 1 1 0 0  X 34 C .8 90   Y 34 C .8  90  X -34   c .8  90 Y -34  c .8 90 W
profile b2 O 0 0 7 P 0 0 1 1 0 0  F 0 -2.95 X 34 C 3.75 90   Y 34  C 3.75 90  X -34    c 3.75 90 Y -34   c 3.75 90 W
prism pb2 b2 0 0 -2.25
profile p P 0 -1 0 1 0 0 O 34.8 1.6 0 F o 0  T 0.8 0.8   Y 1.8  T 2.15 2.15  WW
pipe r b p
mkplane fb b
mkplane fb2 b2
sewing r2 r fb fb2 pb2 

# Creating a copy of the shape
copytranslate r3 r2 41.5 0 0

# Create the volumes and fuse them
mkvolume v2 r2
mkvolume v3 r3

bfuse x v2 v3