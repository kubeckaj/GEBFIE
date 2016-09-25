#!/bin/bash
if [ -e ie.dat ]; then
	rm ie.dat
fi
for i in numbers                                            
do 
	if [ -e WorkDIR/Q${i}solvents_REACTANTS/output ] && [ -e WorkDIR/Q${i}solvents_PRODUCTS/output ]; then
		E1=$(grep "ENERGY" WorkDIR/Q${i}solvents_REACTANTS/output | tail -n 1 | awk '{print $3}')
		E2=$(grep "ENERGY" WorkDIR/Q${i}solvents_PRODUCTS/output | tail -n 1 | awk '{print $3}')
		IE=$(echo $E2-1.0*$E1 |bc -l)
		IE=$(echo 27.2114*$IE |bc -l)
		printf "N= %3.0f \tIE= %+.2f \n" $i $IE  
		printf "%3.0f %+.2f\n" $i $IE >> ie.txt
	fi
done
