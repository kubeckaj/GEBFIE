#!/bin/bash
#!/sbin/bash
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
export PATH=/home/hollas/PHOTOX/bin:/home/hollas/PHOTOX/LAUNCH/:$PATH
JOBDIR=${PWD}
SCRDIR=/scratch/${USER}/TM_${QUEUE}_${JOB_ID}
mkdir -p ${SCRDIR}
cp $JOBDIR/input.sh $SCRDIR/input.sh
cp $JOBDIR/structure.xyz $SCRDIR/structure.xyz
cd ${SCRDIR}
echo ${PWD}

./input.sh >> results

cd ${JOBDIR}
if cp -a ${SCRDIR}/* . ;  then
  rm -rf ${SCRDIR}
else
  echo "Some error from run.sh" >> results
fi
# ------------------------------------------------------------

