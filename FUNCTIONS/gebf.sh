#!/bin/bash  
####################################################  
# Generalized Energy-Based Fragmentation           #
# Jakub Kubecka                                    #
# 19.9.2016				           #
####################################################
. $GEBFIE/FUNCTIONS/functions.sh
####################################################
########           CALCULATION              ########
####################################################
START_Timer

PREPARE_Directories
PREPARE_Parameters

WRITE_Parameters

##############

PREPARE_StepWorkspace
SET_InitialCharges

##############

for step in `seq 1 $MaxSteps`
do
	PREPARE_StepWorkspace
	for selected in `seq 0 $NumberOfSolvents` #also includes core molecule
	do
	        PREPARE_CalculationFiles
	        SEND_CalculationFiles_Run
	        CHECK_CalculationFiles_Finished
	        GET_Charges
	        GET_Energy
	done
	#CALCULATE_ChargesDifferences #not neccesary
	#CALCULATE_EnergyDifferences #not neccesary 
	CALCULATE_ElectrostaticEnergy
	CALCULATE_TotalEnergy
	WRITE_Energies
	WRITE_Time
	echo "step finished"
	CHECK_Convergency
done

WRITE_Results

exit
