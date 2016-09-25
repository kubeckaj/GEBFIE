#!/bin/bash  
# IF YOU HAVE PROBLEMS, RUN:  prepare.sh --help
clear
RED='\033[0;31m'
GREEN='\033[0;32m'
X='\033[0;34m'
NC='\033[0m'
echo "##############################################################"
echo -e "# ${X}GEBFIE${NC} - ${X}G${NC}eneralized ${X}E${NC}nergy-${X}B${NC}ased ${X}F${NC}ragmentation for ${X}IE${NC}     #"
echo "# by Jacob Kubecka                                           #"
echo "# 12.9.2016                                                  #"
echo "##############################################################"
#
function PRINT_Help {	
	echo -e "-------------------------------------------------------------- 
	HELP	
-------------------------------------------------------------- 
 usage : ${GREEN}prepare.sh [ FILE ] [ NUMBEROFCOREATOMS ] [ OPTIONS ]${NC}
--------------------------------------------------------------
	 FILE: - file with structure (for example from molden)
	       - it is neccessary to have:
	       			1.ROW=number_of_all_atoms
				2.ROW=some random comment
				3    =first atom	
			       ...   =structure
			       end   =last atom
	 NUMBEROFCOREATOMS: - number of atoms of ionized molecule 
	 OPTION: 
	 	-cut		analyse X solvents around core
	 	(Na toto jsem se zatim vysral)
	 	-sa [ X ]	X solvent's atom {default=3 (WATER)}  	 
		-n [ X ]	X CPUs {default=1}

	 EXAMPLES:
	 	prepare.sh structure.xyz 13
		prepare.sh structure.xyz -cut
		(Na toto jsem se zatim vysral)
		prepare.sh structure.xyz 6 -n 4 -sa 8
"
}
if [ -z $1 ] || [ $1 == "--help" ]; then
	PRINT_Help
	exit 
fi
FILE="$1" 
if [ ! -e "$FILE" ]; then
	echo -e "${RED}File $FILE doesn't exist!${NC}"
	exit
fi
NUMBEROFCOREATOMS="$2"
if [ -z $NUMBEROFCOREATOMS ] || [ ! $NUMBEROFCOREATOMS -gt 0 ]; then
	echo -e "${RED}OMG, please, fill properly also number of core atoms${NC}"
	PRINT_Help
	exit
fi
NUMBEROFATOMS=$(head -n 1 $FILE)
NUMBEROFATOMS=$(echo $NUMBEROFATOMS+0 |bc )
if [ -z $NUMBEROFATOMS ] || [ ! $NUMBEROFATOMS -gt 0 ]; then
	echo -e "${RED}OMG, please, the first row of structure file should be number${NC}"
	PRINT_Help
	exit
fi
##
test=0
for i in $* test; do
	if [[ $test -eq 1 ]]; then	
		NUMBEROFSOLVENTATOMS=$i
		break
	fi	
	if [[ "$i" == "-sa" ]]; then
		test=1
	fi
done
if [[ $test -eq 0 ]]; then 
	NUMBEROFSOLVENTATOMS=3
fi;
##
NUMBEROFSOLVENTS=$(echo $NUMBEROFATOMS-$NUMBEROFCOREATOMS|bc)
NUMBEROFSOLVENTS=$(echo $NUMBEROFSOLVENTS/$NUMBEROFSOLVENTATOMS|bc)
##
test=0
for i in $*; do
if [[ "$i" == "-cut" ]]; then
	test=1
	break
fi
done
if [[ $test -eq 1 ]]; then 
	echo "Insert number of solvent molecules (Default=0 1 2 3 5 10 15 20 25 50 75 100 125 150 175 200): "
	read numbers
	if [ -z "$numbers" ]; then   
		numbers="0 1 2 3 5 10 15 20 25 50 75 100 125 150 175 200"
	fi
else 
	numbers=$NUMBEROFSOLVENTS
fi
##
JOBDIR=$(pwd)
GEBFIE=$(dirname "$0")
cd $GEBFIE
GEBFIE=$(pwd)
cd $JOBDIR
cp $GEBFIE/FUNCTIONS/input.sh $JOBDIR/
sed -i "s@gebfie@\"$GEBFIE\"@" input.sh
sed -i "s@jobdir@\"$JOBDIR\"@" input.sh
sed -i "s@file@\"$FILE\"@" input.sh
sed -i "s/numberofcoreatoms/\"$NUMBEROFCOREATOMS\"/" input.sh
sed -i "s/numberofsolvents/\"$numbers\"/" input.sh
#sed -i "s/numberofatoms/\"$NUMBEROFATOMS\"/" input.sh
#sed -i "s/numberofsolventatoms/\"$NUMBEROFSOLVENTATOMS\"/" input.sh
##
#echo -n "Zadejte metodu vypoctu (D=BMK): "; read method
#if [ -z "$method" ] 
#then   
#	method="BMK"
#fi 
##
#echo -n "Zadejte bazi vypoctu (D=6-31+g*): "; read basis
#if [ -z "$basis" ]
#then 
#	basis="6-31+g*"
#fi
##
#echo -n "Zadejte velikost pameti (D=2000mb): "; read memory
#if [ -z "$memory" ]
#then
#        memory="2000mb"
#fi
##
#echo -n "Zadejte pocet procesoru (D=1): "; read cpu
#if [ -z "$cpu" ]
#then
#        cpu="1"
#fi
##
#echo -n "Bezet vypocty paralelne (D=no): "; read paralel
#if [ -z "$paralel" ]
#then
#        paralel="no"
#fi
##################
if [[ ! -d STRUCTURES ]]; then
	mkdir STRUCTURES
fi
for i in $numbers; do	
	if [[ $i -eq $NUMBEROFSOLVENTS ]]; then
		cp $FILE STRUCTURES/str$i.xyz
	elif [[ $i -eq 0 ]]; then
		echo " $NUMBEROFCOREATOMS" > STRUCTURES/str0.xyz
		echo "" >> STRUCTURES/str0.xyz
		rows=$(echo $NUMBEROFCOREATOMS+2 | bc)
		head -n $rows $FILE | tail -n $NUMBEROFCOREATOMS >> STRUCTURES/str0.xyz
	else
	$GEBFIE/FUNCTIONS/cut_sphere -u $NUMBEROFCOREATOMS -va $NUMBEROFSOLVENTATOMS -v $i < "$FILE"
	mv cut_qm.xyz STRUCTURES/str$i.xyz
	rm cut_mm.xyz
	fi
done
###
cp $GEBFIE/FUNCTIONS/start.sh .
cp $GEBFIE/FUNCTIONS/write* .
sed -i "s/numbers/$numbers/" write*
#sed -i "s/molecule/$molecule/" start.sh
#sed -i "s/paralel/$paralel/" start.sh
#sed -i "s/shm 1/shm $cpu/" start.sh
#cp -r /home/kubeckaj/GEBF/NASTROJE/VSTUP/ .
#sed -i "s/B3LYP/$method/" VSTUP/*
#sed -i "s@pwd@$PWD@" VSTUP/*
#sed -i "s/NOCA/$molecule/" VSTUP/*
#sed -i "s/CHfrom Mfrom/$parametersRED/" VSTUP/*
#sed -i "s/CHto Mto/$parametersOX/" VSTUP/*
#sed -i "s/6-31+g\*/$basis/" VSTUP/*
#sed -i "s/Shared = 1/Shared = $cpu/" VSTUP/*
#sed -i "s/mem=256MB/mem=$memory/" VSTUP/*
#cp /home/kubeckaj/GEBF/NASTROJE/vypisIE.sh .
#sed -i "s/numbers/$numbers/" vypisIE.sh
#cp /home/kubeckaj/GEBF/NASTROJE/vypisTIME.sh .
#sed -i "s/numbers/$numbers/" vypisTIME.sh
echo -e "If you want, check input file: 
		${GREEN}vim input.sh${NC}
For calculation run:
		${GREEN}./start.sh${NC}
GOOD LUCK"
