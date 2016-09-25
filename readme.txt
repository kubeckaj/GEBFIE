#####################
# How to use GEBFIE #
# Jakub Kubecka     #
#####################

- crate your folder 
- go to the folder 
- copy your structure(s) there
- run "/[dir to GEBFIE]/prepare.sh"
- visualize input file "vim input.sh"
- run "./start.sh"

##########################################
### PREPARE YOUR SOLVATED STRUCTURE  #####
##########################################

# SOLVATE
If you need to solvate your molecule, then use solvate_1.0
(Look to the folder CALCULATIONS)
- take your .xyz
- convert it through vmd to .pdb 
- run script
- convert back from .pdb to .xyz
- rewrite atoms using sed. Example: 
	sed -i "s/H1/H /" .xyz
- run MD for short time to equilibrate molecules

# DESOLVATE
If you need to cut out some of the solvent molecules, then use cut_sphere. It will keep just specific number of the closest solvent molecules. Use following command:
	/home/kubeckaj/GEBF/NASTROJE/cut_sphere -u $NumberOfAtomsOfSolutant -v $NumberOfSolventMolecules < "$soubor"
or you can just run GEBF via prepare.sh

###########################################
### TAKE OUT RESULTS  #####################
###########################################

for getting IE use
	".vypisIE.sh"
for getting TIMES use 
	"./vypisTIME.sh"
for getting CHARGES look to specific directory on the last chargesX

##########################################
