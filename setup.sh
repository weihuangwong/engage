## Adapted from Jon Olmsted's setup at Princeton
## https://github.com/olmjo/tigress-scripts/blob/master/setup/setup.sh

#!/bin/bash
. /etc/profile.d/modules.sh

##
## Functions
##

useVer() {
    echo -e "* Using $1 version $2."
}

ansYN() {
    echo -e "Please answer yes or no."
    }


## Banner ============================================================
echo -e "------------------------------"
echo -e "ENGAGING Setup for R-based HPC"
echo -e "------------------------------"
echo -e ""
## ===================================================================

## ===================================================================
## Set Vars 1
LOCATION=$(hostname)
RMPIVERS=0.6-3

## ===================================================================
## Set Vars 2
GCCVERS=$(gcc --version | grep ^gcc | sed 's/^.* //g' | sed 's/)//g')
export OMPIVERS=1.8.3
## We can set this up to use different version of OpenMPI for different 
## servers

## ===================================================================
## Disclose Version
echo ""
useVer OpenMPI ${OMPIVERS}
useVer Rmpi ${RMPIVERS}
useVer GCC ${GCCVERS}
echo ""

## ===================================================================
## Rmpi DL
while true; do
    read -p "\
@ Do you need to download Rmpi?
[y/n]" yn
    case $yn in
        [Yy]* )
            mkdir ~/R_LIBS
            wget http://www.stats.uwo.ca/faculty/yu/Rmpi/download/linux/Rmpi_${RMPIVERS}.tar.gz -O rmpi.tar.gz -P ~/R_LIBS;
            break;;

        [Nn]* ) break;;
        * ) ansYN ;;
    esac
done
echo ""

while true; do
    read -p "\
@ Do you need to install Rmpi?
[y/n]" yn
    case $yn in
        [Yy]* )
            module use /cm/shared/modulefiles/engaging 
            module add openmpi/${OMPIVERS}
            R CMD INSTALL -l ~/R_LIBS rmpi.tar.gz --configure-args=--with-mpi=/cm/shared/engaging/openmpi/${OMPIVERS}
            break;;

        [Nn]* )
            break;;
        * ) ansYN ;;
    esac
done
echo ""

while true; do
    read -p "\
@ Do you need to install misc. HPC R packages?
[y/n]" yn
    case $yn in
        [Yy]* )          
            source ~/.bashrc
            Rscript install_misc.R;
            break;;
        [Nn]* )
            break;;
        * ) ansYN ;;
    esac
done
echo ""

