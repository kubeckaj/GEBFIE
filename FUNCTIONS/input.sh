#!/bin/bash
####################################################
#                                                  #
#          GG   EEE  BB   FFF  III  EEE            #
#         G G   E    B B  F     I   E              #
#         G     EE   BB   FF    I   EE             #
#         G GG  E    B B  F     I   E              #
#          GG   EEE  BB   F    III  EEE            #
#                                                  #
####################################################
# Calculation of IE via GEBF                       #
# Jakub Kubecka                                    #
# 19.9.2016                                        #
####################################################
########           CALCULATION              ########
####################################################
## PARAMETERS
Paralel="no"		 #[yes][no] = Run separately?
MaxSteps="30"		 #Max GEBF iteration steps
CPUS="1"		 #Number of CPUs
MEMORY="2000mb"		 #[256mb],[100MW],[1GB]
METHOD="BMK"		 #[HF],[BMK],[B3LYP],[MP2]
BASIS="6-31+g*"		 #[STO-3G],[6-31+g*],[pVDZ]
POP="Mulliken"
#add some additives if you need
#create var[x+1] if you need
ADDITIVES[1]="SCF(XQC)"
ADDITIVES[2]="NoSymm"
ENDFILEADDITIVES[1]=""
## CHARGES AND MULTIPLICITIES 
#in case [paralel="no"] it is better to put
#reactants as closed shell system if it's possible
Q_CORE_REACTANTS="-4"	 #Charge of core
M_CORE_REACTANTS="1"	 #Multiplicity of core 
Q_CORE_PRODUCTS="-3"	 #Charge of core
M_CORE_PRODUCTS="2"	 #Multiplicity of core
Q_SOLVENT="0"		 #Charge of solvents
M_SOLVENT="1"		 #Multiplisity of solvents
## NUMBER OF SOLVENTS
NumberOfSolventAtoms="3" #Solvent's atom
NumberOfSolvents=numberofsolvents
## INITIAL CHARGES
InitialCharges="Tip"	 #[Tip],[Compute]
#Compute
PREMETHOD="HF"		 #[HF],[BMK],[B3LYP],[MP2]
PREBASIS="STO-3G"	 #[STO-3G],[6-31+g*],[pVDZ]
#Tip
TIP_C="0.0"
TIP_O="-0.7"
TIP_H="0.6"
TIP_FE="3.0"
TIP_N="-0.3"
TIP_P="0.0"
TIP_S="0.0"
####################################################
########             CLUSTER                ########
####################################################
QSUB=qsub
QUEUE="sq-8-16"
####################################################
########           EXECUTEBLES              ########
####################################################
PYTHON=python
G09=/home/hollas/PHOTOX/LAUNCH/G09
####################################################
########           DIRECTORIES              ########
####################################################
GEBFIE=gebfie
JOBDIR=jobdir
####################################################
########            STRUCTURE               ########
####################################################
STRUCTURE=file		
NumberOfCoreAtoms=numberofcoreatoms
