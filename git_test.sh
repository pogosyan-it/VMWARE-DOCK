#!/bin/bash

for i in `seq 1 10`; do
if [[ $((i % 2)) = 0 ]]; then
   echo "$i is EVEN"
else
   echo "$i is ODD"
fi
done
