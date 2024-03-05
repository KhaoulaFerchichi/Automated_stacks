#!/bin/bash

#automate stacks
#test from Khaoula
mkdir -p -f   output_stacks
read -r -a samples < samples_ID.txt

for i in "${samples[@]}"
do
  echo "$i"
done
#ustacks
	
i=1
for sample in $samples
do
   ustacks -t fastq -f ./clean_data/${sample}.fastq -o ./output_stacks/ -i $i -m 3 -M 2 -p 16 --force-diff-len 
   let "i+=1";
done
