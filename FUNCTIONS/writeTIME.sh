#!/bin/bash
if [ -e t.dat ]; then
	rm t.dat
fi
for i in numbers                                           
do 
	if [ -e WorkDIR/Q${i}solvents_REACTANTS/output ] && [ -e WorkDIR/Q${i}solvents_PRODUCTS/output ]; then
		T1=$(grep "TIME" WorkDIR/Q${i}solvents_REACTANTS/output | tail -n 1 | awk '{print $3}')
		T2=$(grep "TIME" WorkDIR/Q${i}solvents_PRODUCTS/output | tail -n 1 | awk '{print $3}')
		TC=$(echo $T1+$T2 |bc -l)
		printf "N= %3.0f \t tR= %+.2f \t tP= %+.2f \t tC=tR+tP= %+.2f\n" $i $T1 $T2 $TC  
		printf "%3.0f %+.2f %+.2f %+.2f\n" $i $T1 $T2 $TC >> t.txt
	fi
done
