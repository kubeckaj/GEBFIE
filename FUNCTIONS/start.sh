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
. input.sh
WORKINGDIR="WorkDIR"
if [ -d $WORKINGDIR ]; then
	echo -e "Working directory WorkDIR already exists."
	echo -e "[Press ENTER for continue or Press Ctr+c for stop]"; read x
else 
	mkdir $WORKINGDIR
fi
cd $WORKINGDIR
msg=0
for i in $NumberOfSolvents; do 
 for j in REACTANTS PRODUCTS; do
  CALCDIR="Q${i}solvents_$j"
  if [ -d $CALCDIR ]; then
   echo "$CALCDIR already exists"
   msg=$(echo $msg+1 |bc)
  fi
 done
done
if [ ! $msg -eq 0 ]; then
	echo -e "There are few directories, what already exists (exactly $msg of them)"
	echo -e "[Press ENTER for continue or Press Ctr+c for stop]"; read x
fi
for i in $NumberOfSolvents; do 
 for j in REACTANTS PRODUCTS; do
  CALCDIR="Q${i}solvents_$j"
  if [ ! -d $CALCDIR ]; then mkdir $CALCDIR; fi
  cd    $CALCDIR
  ##PREPARE
  if [ "paralel" = "yes" ]; then
   cp $GEBFIE/FUNCTIONS/runP.sh ./run.sh
  else 
   cp $GEBFIE/FUNCTIONS/runS.sh ./run.sh
  fi
  cp ../../input.sh . 
  cp ../../STRUCTURES/str${i}.xyz structure.xyz
  if [[ $j == "REACTANTS" ]]; then 
   echo "Q_CORE=${Q_CORE_REACTANTS}" >> input.sh
   echo "M_CORE=${M_CORE_REACTANTS}" >> input.sh
  elif [[ $j == "PRODUCTS" ]]; then 
   echo "Q_CORE=${Q_CORE_PRODUCTS}" >> input.sh
   echo "M_CORE=${M_CORE_PRODUCTS}" >> input.sh
  fi
  echo ". \$GEBFIE/FUNCTIONS/gebf.sh" >> input.sh
  ##SEND
  if [ "paralel" = "yes" ] || [ $j = "REACTANTS" ]; then
   $QSUB -cwd -q $QUEUE -pe shm $CPUS run.sh
  fi
  ##
  cd ..
 done
done
