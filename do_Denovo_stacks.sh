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

#cstacks
cstacks -n 6 -P ./output_stacks/ -M ./popumap/popumap.txt -p 8 --k_len 15

#sstacks
sstacks -P ./output_stacks/ -M ./popumap/popumap.txt -p 8


#tsv2bam
tsv2bam -P ./output_stacks/ -M ./popumap/popumap.txt  -t 8

#gstacks
gstacks -P ./output_stacks/ -M ./popumap/popumap.txt  -t 8 

#populations
populations -P ./output_stacks/ -M ./popumap/popumap.txt -r 0.65 --vcf --genepop --structure --fstats --hwe -t 8

#vcftools
vcftools --vcf ./output_stacks/populations.snps.vcf  --max-missing 0.5 --maf 0.05  --recode --recode-INFO-all --out ./output_stacks1/filtered_popnovo_snps_005maf


#populations(convert)
populations -V ./output_stacks4/filtered_popnovo_snps_005maf.recode.vcf -O ./out_treemix/ -M ./popumap/popumap.txt --treemix --structure  --phylip --hwe  -t 8

