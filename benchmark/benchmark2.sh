#!/bin/bash

#output_file="3worker.txt"
#output_file="2worker.txt"
#output_file="1worker.txt"

> $output_file

declare -a rps_values

for i in {1..10}
do
    rps=$(ab -n 1000 -c 10 http://harkonen.it13.com/ 2>&1 | grep "Requests per second" | awk '{print $4}')

    echo $rps >> $output_file

    rps_values+=("$rps")

    sleep 0.5
done

total=0
for value in "${rps_values[@]}"
do
    total=$(awk "BEGIN {print $total + $value}")
done
mean=$(awk "BEGIN {print $total / ${#rps_values[@]}}")

echo "Mean: $mean" >> $output_file

echo "Benchmarking completed. Results saved in $output_file."
