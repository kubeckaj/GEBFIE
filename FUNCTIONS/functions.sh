####################################################
# Generalized Energy-Based Fragmentation           #
# Jakub Kubecka                                    #
# 19.9.2016					   #
####################################################
function CALCULATE_ChargesDifferences {
	echo " - " 			 > CHARGES/differences$step
	echo "charges differences "	>> CHARGES/differences$step	
        for i in `seq 1 $NumberOfAtoms`; do
		row=$(echo $i+2 |bc)
		stepback=$(echo $step-1 |bc)
		value1=$(head -n $row CHARGES/charges$stepback |tail -n 1)
		value2=$(head -n $row CHARGES/charges$step |tail -n 1)
		diff=$(echo $value2-1*$value1 |bc)
		echo $diff >> CHARGES/differences$step
	done
}
function CALCULATE_ElectrostaticEnergy {
	# IF YOU CAN NOT USE PYTHON, UNCOMENT THIS BELLOW
	#ElectrostaticEnergy=0
	#for i in `seq 0 $NumberOfSolvents`
	#do
	#	for j in `seq 1 ${AtomsInFragments[$i]}`
	#	do
	#		k=i
	#		for l in `seq $(echo $j+1 |bc) ${AtomsInFragments[$k]}`
	#		do
	#			row1=$(echo ${FragmentsRowFrom[$i]}-1+$j |bc)
        #			ch1=$(head -n $row1 CHARGES/charges$step |tail -n 1)
        #			x1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $2}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #			y1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $3}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #			z1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $4}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #			row2=$(echo ${FragmentsRowFrom[$k]}-1+$l |bc)
        #			ch2=$(head -n $row2 CHARGES/charges$step |tail -n 1)
        #			x2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $2}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #                        y2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $3}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #                        z2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $4}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #			dx=$(echo $x2-1.*$x1 |bc -l)
        #			dy=$(echo $y2-1.*$y1 |bc -l)
        #			dz=$(echo $z2-1.*$z1 |bc -l)
        #			r=$(echo "sqrt($dx*$dx+1.*$dy*$dy+1.*$dz*$dz)" |bc -l)
        #			r=$(echo $r*1.889725989 |bc -l)
        #			elst=$(echo $ch1*$ch2/$r |bc -l)
        #			ElectrostaticEnergy=$(echo $ElectrostaticEnergy+$NumberOfSolvents*$elst |bc)
	#		done
	#		for k in `seq $(echo $i+1 |bc) $NumberOfSolvents`
	#		do
	#			for l in `seq 1 ${AtomsInFragments[$k]}`
	#			do
	#				row1=$(echo ${FragmentsRowFrom[$i]}-1+$j |bc)
	#				ch1=$(head -n $row1 CHARGES/charges$step |tail -n 1)
	#				x1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $2}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
	#				y1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $3}' | sed -e 's/[eE]+*/\*10\^/' | bc -l) 
	#				z1=$(head -n $row1 structure.xyz |tail -n 1 | awk '{print $4}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
	#				row2=$(echo ${FragmentsRowFrom[$k]}-1+$l |bc)
	#				ch2=$(head -n $row2 CHARGES/charges$step |tail -n 1)
	#				x2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $2}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #                                y2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $3}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
        #                                z2=$(head -n $row2 structure.xyz |tail -n 1 | awk '{print $4}' | sed -e 's/[eE]+*/\*10\^/' | bc -l)
	#				dx=$(echo $x2-1.*$x1 |bc -l)
	#				dy=$(echo $y2-1.*$y1 |bc -l)
	#				dz=$(echo $z2-1.*$z1 |bc -l)
	#				r=$(echo "sqrt($dx*$dx+1.*$dy*$dy+1.*$dz*$dz)" |bc -l)
	#				r=$(echo $r*1.889725989 |bc)
	#				elst=$(echo $ch1*$ch2/$r |bc -l)
	#				ElectrostaticEnergy=$(echo $ElectrostaticEnergy+$NumberOfSolvents*$elst |bc)
	#			done
	#		done
	#	done
	#done
	ElectrostaticEnergy=$($PYTHON $GEBFIE/FUNCTIONS/CalculateElectostaticEnergy.py $stepback)
	ElectrostaticEnergy=$(echo $ElectrostaticEnergy*$NumberOfSolvents | bc -l)
}
function CALCULATE_EnergyDifferences {
	echo " - " 			 > ENERGIES/differences$step
	echo "energy differences "	>> ENERGIES/differences$step	
        for i in `seq 1 $NumberOfFragments`; do
		row=$(echo $i+2 |bc)
		value1=$(head -n $row ENERGIES/energies$stepback |tail -n 1)
		value2=$(head -n $row ENERGIES/energies$step |tail -n 1)
		diff=$(echo $value2-1*$value1 |bc)
		echo $diff >> ENERGIES/differences$step
	done
}
function CALCULATE_TotalEnergy {
	TotalEnergy=0
	for i in `seq 3 $(echo $NumberOfSolvents+3 |bc)`; do 
		value=$(head -n $i ENERGIES/energies$step |tail -n 1)
		TotalEnergy=$(echo $TotalEnergy+$value |bc -l)
	done
}
function CALL_AtomsInFragments {
	AtomsInFragments[0]=$NumberOfCoreAtoms
	for i in `seq 1 $NumberOfSolvents`; do
		AtomsInFragments[$i]=$NumberOfSolventAtoms
	done
}
function CALL_FragmentsRowFrom {
	FragmentsRowFrom[0]=3
	for i in `seq 1 $NumberOfSolvents`; do
		j=$(echo $i-1 |bc)
		FragmentsRowFrom[$i]=$(echo ${FragmentsRowFrom[$j]}+${AtomsInFragments[$j]} |bc)
	done
}
function CALL_FragmentsRowTo {
	for i in `seq 0 $NumberOfSolvents`; do
		FragmentsRowTo[$i]=$(echo ${FragmentsRowFrom[$i]}+${AtomsInFragments[$i]}-1 |bc)
	done
}
function CALL_NumberOfAtoms {
	NumberOfAtoms=$(head -n 1 structure.xyz)
}
function CALL_NumberOfFragments {
	NumberOfFragments=$(echo $NumberOfSolvents+1 |bc)
}
function CALL_NumberOfSolvents {
	NumberOfNonCoreAtoms=$(echo $NumberOfAtoms-$NumberOfCoreAtoms |bc)
	NumberOfSolvents=$(echo $NumberOfNonCoreAtoms/$NumberOfSolventAtoms |bc)
}
function CHECK_CalculationFiles_Finished {
	while [ ! -e job.log ]; do
		sleep 2
	done
	while [ $(grep -c "Normal termination of Gaussian 09" job.log) -eq 0 ];	do
    		sleep 2
		if [ ! $(grep -c "Error" job.log) -eq 0 ]; then
			echo "Error in job.log." >> output
			exit
		fi
	done
}
function CHECK_Convergency {
	if [ $step -gt 1 ]; then
		EnergyDifferences=$(echo 1.0*$TotalEnergyCorrelated-1.0*$PreviousEnergy |bc -l)
		echo "Energy differences: $EnergyDifferences" >> output
		if [[ $(echo "$EnergyDifferences<0.001" |bc -l) -eq 1 ]];	then 
			EnergyDifferences=$(echo -1.0*$EnergyDifferences |bc -l)
		fi
		if [[ $(echo "$EnergyDifferences<0.001" |bc -l) -eq 1 ]];	then
			echo "Converged" >> results
			break
		fi
	else
		echo "Energy differences: ---" >> output
	fi
	echo $TotalEnergyCorrelated
	PreviousEnergy=$TotalEnergyCorrelated
	echo $PreviousEnergy
}
function GET_Energy {
	grep "SCF Done:" job.log | tail -n 1 | awk '{print $5}' >> ENERGIES/energies$step
}
function GET_Charges {
	if [[ $POP == "MULLIKEN" ]] || [[ $POP == "Mulliken" ]] || [[ $POP == "mulliken" ]]; then
		grep -C $(echo ${AtomsInFragments[$selected]}+1 |bc) "Mulliken atomic charges:" job.log | tail -n ${AtomsInFragments[$selected]} | awk '{print $3}' >> CHARGES/charges$step
	elif [[ $POP == "CHELPG" ]] || [[ $POP == "chelpg" ]] || [[ $POP == "Chelpg" ]] || [[ $POP == "ChelpG" ]]; then
		grep -C $(echo ${AtomsInFragments[$selected]}+3 |bc) "Fitting point charges to electrostatic potential" job.log | tail -n ${AtomsInFragments[$selected]} | awk '{print $3}' >> CHARGES/charges$step
	fi
}
function PREPARE_Directories {
	#cp $JOBDIR/STRUCTURES/$STRUCTURE structure.xyz
	mkdir CHARGES
	mkdir ENERGIES
	mkdir CHECKPOINTS
}
function PREPARE_Parameters {
	CALL_NumberOfAtoms
	CALL_NumberOfSolvents
	CALL_NumberOfFragments
	CALL_AtomsInFragments
	CALL_FragmentsRowFrom
	CALL_FragmentsRowTo
	step=0
}
function PREPARE_StepWorkspace {
	echo " - "     		 > CHARGES/charges$step
	echo "charges" 		>> CHARGES/charges$step
	echo " - "      	 > ENERGIES/energies$step
	echo "fragment energie" >> ENERGIES/energies$step
        if [ -e job.com ]
        then
                rm job.com
        fi
        if [ -e job.log ]
        then
                rm job.log
        fi
	stepback=$(echo $step-1 |bc)
	echo " "
	echo "Step number " $step
}
function PREPARE_CalculationFiles {
	echo -n -e "-""$selected""/""$NumberOfSolvents"
        echo "%NprocShared=$CPUS"            > job.com
	echo "%Mem=$MEMORY"		    >> job.com
	echo "%Chk=CHECKPOINTS/chkp$selected.chkp" >> job.com
	# CALCULATION PARAMETERS
	if [ $step -eq 0 ]; then
		echo "# $PREMETHOD $PREBASIS" >> job.com
	else
		echo "# $METHOD $BASIS "      >> job.com
	fi
	echo ""				      >> job.com
	echo "QMMM/QMQM ... GEBFIE"	      >> job.com
	echo ""				      >> job.com
	if [ $selected -eq 0 ]; then
		echo "$Q_CORE $M_CORE"          >> job.com
	else
		echo "$Q_SOLVENT $M_SOLVENT"    >> job.com
	fi
	# STRUCTURE
        head -n ${FragmentsRowTo[$selected]} structure.xyz |tail -n  ${AtomsInFragments[$selected]} >> job.com
	echo "" >> job.com
	# POINT CHARGES
	if [ $NumberOfSolvents -gt 0 ] && [ ! $step -eq 0 ]; then
		row4=$(head -n 4 job.com | tail -n 1)
		sed -i "4s/.*/$row4 Charge/" job.com
		for i in `seq 0 $NumberOfSolvents`; do
			if [ $i -ne $selected ]; then 
				for j in `seq ${FragmentsRowFrom[$i]} ${FragmentsRowTo[$i]}`; do
					str=$(head -n $j structure.xyz | tail -n 1 |awk '{print $2 " "$3 " " $4}')
					ch=$(head -n $j CHARGES/charges$stepback | tail -n 1)
					echo "$str $ch" >> job.com
				done
			fi
		done
		echo "" >> job.com
	fi
	# CHECKPOINT
	if [ -e CHECKPOINTS/chkp$selected.chkp ]; then
		row4=$(head -n 4 job.com | tail -n 1)
		sed -i "4s/.*/$row4 Guess=Read/" job.com
	fi
	# ADDITIVES TO ROW4
	row4=$(head -n 4 job.com | tail -n 1)
	sed -i "4s/.*/$row4 ${ADDITIVES[*]}/" job.com	
	# ADDITIVES TO THE END OF FILE
	#for i in `seq 1 ${ENDFIELADDITIVES[@]}`; do	
	#	echo $i                    >> job.com
	#done
}
function SEND_CalculationFiles_Run {
	$G09 job.com > job.log
}
function SET_InitialCharges {
	if [ $InitialCharges == "COMPUTE" ] || [ $InitialCharges == "compute" ] || [ $InitialCharges == "Compute" ]; then
		PREPARE_StepWorkspace
		for selected in `seq 0 $NumberOfSolvents`; do #also includes core molecule
		       	PREPARE_CalculationFiles
	        	SEND_CalculationFiles_Run
	        	CHECK_CalculationFiles_Finished
	        	GET_Charges
		done
	elif [ $InitialCharges == "TIP" ] || [ $InitialCharges == "Tip" ] || [ $InitialCharges == "tip" ]; then
		for i in `seq 0 $NumberOfSolvents`; do
			for j in `seq ${FragmentsRowFrom[$i]} ${FragmentsRowTo[$i]}`; do
				atom=$(head -n $j structure.xyz | tail -n 1 | awk '{print $1}')
				case "$atom" in
					"c" | "C" )
						naboj=$TIP_C
						;;
					"o" | "O" )
						naboj=$TIP_O
						;;
					"h" | "H" )
						naboj=$TIP_H
						;;
					"s" | "S" )
						naboj=$TIP_S
			       			;;
					"p" | "P" )
						naboj=$TIP_P
			       			;;
					"n" | "N" )
						naboj=$TIP_N
			       			;;
					"Cl" | "cl" | "CL" )
						naboj=$TIP_CL
			       			;;
					"fe" | "Fe" | "FE" )
						naboj=$TIP_FE
						;;
					*)
						echo "Unknown atom -> used 0.0"
						echo "If you do not agree. Let's call Jacob or just use COMPUTE."
						naboj=0.0
						;;
					esac	
				echo $naboj >> CHARGES/charges$step
			done
		done
	else
		for i in `seq 0 $NumberOfSolvents`; do
			for j in `seq ${FragmentsRowFrom[$i]} ${FragmentsRowTo[$i]}`; do
				atom=$(head -n $j structure.xyz | tail -n 1 | awk '{print $1}')
				naboj=0.0
				echo $naboj >> CHARGES/charges$step
			done
		done
	fi
}
function START_Timer {
	res1=$(date +%s.%N)
}
function WRITE_Energies {
	echo " "
	echo " " >> output
	echo "---------------------" >> output
	echo "step numeber " "$step" >> output
	echo -e "FragmentsEnergy:\t" $TotalEnergy >> output
	#echo -e "SumOfSquaredEnergyDifferences:\t" $SumOfSquaredEnergyDifferences >> output
	#echo -e "SumOfSquaredChargesDifferences:\t" $SumOfSquaredChargesDifferences >> output
	echo -e "ElectrostaticEnergy:\t" $ElectrostaticEnergy >> output
	echo "Do not use Fragm. or El. energy if you do not understand them!!!" >> output
	TotalEnergyCorrelated=$(echo $TotalEnergy-1.0*$ElectrostaticEnergy |bc -l)
	echo -e "TotalEnergyCorrelated:\t\t" $TotalEnergyCorrelated >> output
}
function WRITE_Parameters {
	echo "---------------------------------------------"
	echo -e "NameOfDir:\t\t" $JOBDIR
	echo -e "Structure:\t\t" $STRUCTURE
	echo -e "NumberOfAtoms:\t\t" $NumberOfAtoms
	echo -e "NumberOfSolvents:\t" $NumberOfSolvents
	echo -e "NumberOfFragments:\t" $NumberOfFragments
	echo -e "AtomsInFragments:\t" ${AtomsInFragments[*]}
	echo -e "FragmentsRowFrom:\t" ${FragmentsRowFrom[*]}
	echo -e "FragmentsRowTo:\t\t" ${FragmentsRowTo[*]}
	echo "---------------------------------------------"
	echo ""
}
function WRITE_Results {
	echo "---------------------------------------------" >> output
	echo "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII" >> output
	echo "---------------------------------------------" >> output
	echo "JOB FINISHED" >> output
	echo "ENERGY = $TotalEnergyCorrelated" >> output
	res2=$(date +%s.%N)
	dt=$(echo "$res2 - $res1" | bc)
	hours=$(echo "$dt/3600." | bc -l)
	echo "TIME = $hours hours" >> output
}
function WRITE_Time {
	res2=$(date +%s.%N)
	dt=$(echo "$res2 - $res1" | bc)
	dd=$(echo "$dt/86400" | bc)
	dt2=$(echo "$dt-86400*$dd" | bc)
	dh=$(echo "$dt2/3600" | bc)
	dt3=$(echo "$dt2-3600*$dh" | bc)
	dm=$(echo "$dt3/60" | bc)
	ds=$(echo "$dt3-60*$dm" | bc)
	printf "runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds >> output
	printf "runtime: %d:%02d:%02d:%02.4f\n" $dd $dh $dm $ds
}
############################
