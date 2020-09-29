#!/bin/sh

cat $1 | tr . - | cut -c1-19 | xargs -I{} date --date "{}" +%s > tmp_a
cat $1 | cut -c21-23 > tmp_b
paste --delimiters='' tmp_a tmp_b > tmp_c
paste --delimiters=' ' tmp_c $1 | sort -k1 | cut -c15-

rm tmp_a tmp_b tmp_c
