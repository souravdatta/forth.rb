: fac dup 1 = if drop else dup rot * swap 1 - fac endif ;
: factorial 1 swap fac ;
