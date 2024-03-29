#!/bin/bash

start=`date`
START=$(date +"%s")

export MAIN_FOLDER=`pwd`

########## Introduction ########## 
while true; do
  echo "-------------------------------------------------- "
  echo " "
  echo "This Bash will install WRF-CMAQ models automatically with all necessary libraries under GNU compiler configuration."
  echo "You need the Internet connection to use this bash, but most of the libraries will be downloaded from a Could storage server."
  echo " "
  echo "-------------------------------------------------- "
  echo " "
  echo "Do you want to continue? (Y/N)"
  read -r -p "(Y/N)   " yn
  case $yn in
    [Yy]* )
      break
      ;;
    [Nn]* )
      exit
      ;;
    * ) echo "Please answer Y or N";;
  esac
done




########## System Architecture Type ########## 
export SYS_ARCH=$(uname -m)

if [ "$SYS_ARCH" = "x86_64" ]; then
  export SYSTEMBIT="64"
else
  export SYSTEMBIT="32"
fi

export SYSTEMOS="Linux"


########## Centos Test ########## 
if [ "$SYSTEMOS" = "Linux" ]; then
   export YUM=$(command -v yum)
    if [ "$YUM" != "" ]; then
     echo " yum found"
     read -r -p "Your system is a CentOS based system which is not compatible with this script"
     exit ;
    fi

fi



if [ "$SYSTEMBIT" = "64" ] && [ "$SYSTEMOS" = "Linux" ]; then
    echo "Your system is 64bit version of Debian Linux Kernal"
    echo " "
    echo "GNU compiler is selected for installation"
    export Ubuntu_64bit_GNU=1
fi

if [ "$SYSTEMBIT" = "32" ] && [ "$SYSTEMOS" = "Linux" ]; then
  echo "Your system is not compatibile with this script."
  exit ;
fi

########## System Information Tests ########## 

if [ "$SYSTEMOS" = "Linux" ]; then

  export HOME=`cd;pwd`
  export Storage_Space_Size=$(df -h --output=avail ${HOME} | awk 'NR==2 {print $1}' | tr -cd '[:digit:]')
  export Storage_Space_Units=$(df -h --output=avail ${HOME} | awk 'NR==2 {print $1}' | tr -cd '[:alpha:]')
  export Storage_Space_Required="50"
  echo "-------------------------------------------------- "
  echo " "
  echo " Testing for Storage Space for installation"
  echo " "

  case $Storage_Space_Units in
      [Pp]* )

        echo " "
        echo "Sufficient storage space for installation found"
        echo "-------------------------------------------------- " ;;
      [Tt]* )
        echo " "
        echo "Sufficient storage space for installation found"
        echo "-------------------------------------------------- " ;;
      [Gg]* )
        if [[ ${Storage_Space_Size} -lt ${Storage_Space_Required} ]]; then
          echo " "
          echo "Not enough storage space for installation"
          echo "-------------------------------------------------- "
          exit
        else
          echo " "
          echo "Sufficient storage space for installation found."
          echo "-------------------------------------------------- "
        fi ;;
      [MmKk]* )
        echo " "
        echo "Not enough storage space for installation."
        echo "-------------------------------------------------- "
        exit ;;
      * )
      echo " "
      echo "Not enough storage space for installation."
      echo "-------------------------------------------------- "
      exit ;;
    esac

  echo " "
fi



########## Chose OpenGrADS ########## 
echo "OpenGrADS is selected\n"
echo " "
GRADS_PICK=1

echo "-------------------------------------------------- "

########## Auto Configuration ########## 
echo "Auto Configuration is selected\n"
echo " "
export auto_config=1


echo "-------------------------------------------------- "

########## GEOG WPS Geographical Input Data Mandatory for Specific Applications ########## 

while true; do
  echo "-------------------------------------------------- "
  echo " "
  echo "Would you like to download the WPS Geographical Input Data for Specific Applications? (Optional)/It needs Internet Connenction to be downloaded"
  echo " "
  echo "Specific Applicaitons files can be viewed here:  "
  echo " "
  printf '\e]8;;https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html\e\\Specific GEOG Applications Website (right click to open link) \e]8;;\e\\\n'
  echo " "
  read -r -p "(Y/N)   " yn
  case $yn in
    [Yy]* )
      export WPS_Specific_Applications=1  
      break
      ;;
    [Nn]* )
      export WPS_Specific_Applications=0  
      break
      ;;
    * ) echo "Please answer yes or no.";;
  esac
done




echo "-------------------------------------------------- "

##########  GEOG Optional WPS Geographical Input Data ########## 

while true; do
    echo "-------------------------------------------------- "
    echo " "
    echo "Would you like to download the GEOG Optional WPS Geographical Input Data? (Optional) It needs Internet Connenction to be downloaded"
    echo " "
    echo "Optional Geogrpahical files can be viewed here:  "
    echo " "
    printf '\e]8;;https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html\e\\Optional GEOG File Applications Website (right click to open link) \e]8;;\e\\\n'
    echo " "
    read -r -p "(Y/N)    " yn
    echo " "
  case $yn in
    [Yy]* )
      export Optional_GEOG=1  
      break
      ;;
    [Nn]* )
      export Optional_GEOG=0 
      break
      ;;
    * ) echo "Please answer yes or no.";;
  esac
done

echo "-------------------------------------------------- "



##########  WRF ########## 
WRF_PICK=1


##########  Enter sudo users information ########## 
echo "-------------------------------------------------- "

while true; do
  echo " "
  read -r -s -p "
  Password is only save locally and will not be seen when typing.
  Please enter your sudo password:

  " yn
  export PASSWD=$yn
  echo "-------------------------------------------------- "
  break
done

echo " "
echo "Beginning Installation"
echo " "



########## DTC's MET & METPLUS ##########


if [ "$Ubuntu_64bit_GNU" = "1" ]; then

  export HOME=`cd;pwd`

  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install python3 python3-dev emacs flex bison libpixman-1-dev libjpeg-dev pkg-config libpng-dev unzip python2 python2-dev python3-pip pipenv gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git libncurses5 libncurses6 mlocate pkg-config build-essential curl libcurl4-openssl-dev

  pip3 install python-dateutil==2.8

  mkdir $HOME/WRF
  
  export WRF_FOLDER=$HOME/WRF

  mkdir $WRF_FOLDER/MET-11.0.2
  mkdir $WRF_FOLDER/MET-11.0.2/Downloads
  mkdir $WRF_FOLDER/METplus-5.0.1
  mkdir $WRF_FOLDER/METplus-5.0.1/Downloads

  
  cd $MAIN_FOLDER/Downloads/Met/

  cp compile_MET_all.sh $WRF_FOLDER/MET-11.0.2
  tar -xvzf tar_files.tgz -C $WRF_FOLDER/MET-11.0.2
  cp v11.0.2.tar.gz $WRF_FOLDER/MET-11.0.2/tar_files
  
  
    
  cd $WRF_FOLDER/MET-11.0.2
  
  
  export CC=/usr/bin/gcc
  export CXX=/usr/bin/g++
  export FC=/usr/bin/gfortran
  export F77=/usr/bin/gfortran
  export CFLAGS="-fPIC -fPIE -O3"
  
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  export PYTHON_VERSION=$(/usr/bin/python3 -V 2>&1|awk '{print $2}')
  export PYTHON_VERSION_MAJOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $1}')
  export PYTHON_VERSION_MINOR_VERSION=$(echo $PYTHON_VERSION | awk -F. '{print $2}')
  export PYTHON_VERSION_COMBINED=$PYTHON_VERSION_MAJOR_VERSION.$PYTHON_VERSION_MINOR_VERSION


  export FC=/usr/bin/gfortran
  export F77=/usr/bin/gfortran
  export F90=/usr/bin/gfortran
  export gcc_version=$(gcc -dumpfullversion)
  export TEST_BASE=$WRF_FOLDER/MET-11.0.2
  export COMPILER=gnu_$gcc_version
  export MET_SUBDIR=${TEST_BASE}
  export MET_TARBALL=v11.0.2.tar.gz
  export USE_MODULES=FALSE
  export MET_PYTHON=/usr
  export MET_PYTHON_CC=-I${MET_PYTHON}/include/python${PYTHON_VERSION_COMBINED}
  export MET_PYTHON_LD=-L${MET_PYTHON}/lib/python${PYTHON_VERSION_COMBINED}/config-${PYTHON_VERSION_COMBINED}-x86_64-linux-gnu\ -L${MET_PYTHON}/lib\ -lpython${PYTHON_VERSION_COMBINED}\ -lcrypt\ -ldl\ -lutil\ -lm
  export SET_D64BIT=FALSE


  chmod 775 compile_MET_all.sh

  time ./compile_MET_all.sh | tee compile_MET_all.log

  export PATH=$WRF_FOLDER/MET-11.0.2/bin:$PATH


  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade




  mkdir $WRF_FOLDER/METplus-5.0.1
  mkdir $WRF_FOLDER/METplus-5.0.1/Sample_Data
  mkdir $WRF_FOLDER/METplus-5.0.1/Output
  mkdir $WRF_FOLDER/METplus-5.0.1/Downloads


  
  cd $MAIN_FOLDER/Downloads/METplus
    
  tar -xvzf v5.0.1.tar.gz -C $WRF_FOLDER



  cd $WRF_FOLDER/METplus-5.0.1/parm/metplus_config

  sed -i "s|MET_INSTALL_DIR = /path/to|MET_INSTALL_DIR = $WRF_FOLDER/MET-11.0.2|" defaults.conf
  sed -i "s|INPUT_BASE = /path/to|INPUT_BASE = $WRF_FOLDER/METplus-5.0.1/Sample_Data|" defaults.conf
  sed -i "s|OUTPUT_BASE = /path/to|OUTPUT_BASE = $WRF_FOLDER/METplus-5.0.1/Output|" defaults.conf


  
  cd $MAIN_FOLDER/Downloads/METplus
  
  tar -xvzf sample_data-met_tool_wrapper-5.0.tgz -C $WRF_FOLDER/METplus-5.0.1/Sample_Data



  echo 'Testing MET & METPLUS Installation.'
  $WRF_FOLDER/METplus-5.0.1/ush/run_metplus.py -c $WRF_FOLDER/METplus-5.0.1/parm/use_cases/met_tool_wrapper/GridStat/GridStat.conf

  export PATH=$WRF_FOLDER/METplus-5.0.1/ush:$PATH
  read -r -t 5 -p "MET and METPLUS sucessfully installed with GNU compilers."
fi



if [ "$Ubuntu_64bit_GNU" = "1" ] && [ "$WRF_PICK" = "1" ]; then

  #############################basic package managment############################
  echo $PASSWD | sudo -S apt -y update
  echo $PASSWD | sudo -S apt -y upgrade
  echo $PASSWD | sudo -S apt -y install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git python3 python3-dev python2 python2-dev mlocate curl cmake libxml2 libxml2-dev libcurl4-openssl-dev build-essential pkg-config

  echo " "
  ##############################Directory Listing############################
  export HOME=`cd;pwd`

  export WRF_FOLDER=$HOME/WRF
  cd $WRF_FOLDER/
  mkdir Downloads
  mkdir WRFPLUS
  mkdir WRFDA
  mkdir Libs
  export DIR=$WRF_FOLDER/Libs
  mkdir Libs/grib2
  mkdir Libs/NETCDF
  mkdir Libs/MPICH
  mkdir -p Tests/Environment
  mkdir -p Tests/Compatibility

  echo " "
  #############################Core Management####################################

  export CPU_CORE=$(nproc)                                             # number of available threads on system
  export CPU_6CORE="6"
  export CPU_HALF=$(($CPU_CORE / 2))                                   #half of availble cores on system
  export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))              #Forces CPU cores to even number to avoid partial core export.

  if [ $CPU_CORE -le $CPU_6CORE ]                                  #If statement for low core systems.
  then
    export CPU_HALF_EVEN="2"
  else
    export CPU_HALF_EVEN=$(( $CPU_HALF - ($CPU_HALF % 2) ))
  fi


  echo "##########################################"
  echo "Number of Threads being used $CPU_HALF_EVEN"
  echo "##########################################"


  echo " "
  ##############################Downloading Libraries############################
  cd $MAIN_FOLDER/
  
  echo "##########################################"
  echo "##########################################"
  echo "##########################################"
  echo " Wait for the libraries to be downloaded "

  wget --header="Host: drive.usercontent.google.com" --header="User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" --header="Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7" --header="Accept-Language: en-US,en;q=0.9,fa;q=0.8" --header="Connection: keep-alive" "https://drive.usercontent.google.com/download?id=1NkmRAeG7w_LLhh_HDW_X39jZwGYw8mml&export=download&authuser=2&confirm=t&uuid=a4f92a10-cbd5-4064-bb83-d79567b60537&at=APZUnTWngzWjzHFwWurVdIQsFaAL:1711680004113" -c -O 'Downloads.zip'

  echo "##########################################"
  echo "##########################################"
  echo "##########################################"


  unzip Downloads.zip


  echo " "
  ####################################Compilers#####################################
  cd $MAIN_FOLDER/Downloads/
  export CC=gcc
  export CXX=g++
  export FC=gfortran
  export F77=gfortran
  export CFLAGS="-fPIC -fPIE -O3"



  #IF statement for GNU compiler issue
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
    then
      export fallow_argument=-fallow-argument-mismatch
      export boz_argument=-fallow-invalid-boz
    else
      export fallow_argument=
      export boz_argument=
  fi


  export FFLAGS="$fallow_argument -m64"
  export FCFLAGS="$fallow_argument -m64"


  echo "##########################################"
  echo "FFLAGS = $FFLAGS"
  echo "FCFLAGS = $FCFLAGS"
  echo "##########################################"




  echo " "
  
  
  #############################zlib############################
  
  cd $MAIN_FOLDER/Downloads
  tar -xvzf v1.2.13.tar.gz
  cd zlib-1.2.13/
  ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  
  
  ##############################MPICH############################

  cd $MAIN_FOLDER/Downloads
  tar -xvzf mpich-4.1.1.tar.gz
  cd mpich-4.1.1/
  F90= ./configure --prefix=$DIR/MPICH --with-device=ch3 FFLAGS=$fallow_argument FCFLAGS=$fallow_argument

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  # make check

  export PATH=$DIR/MPICH/bin:$PATH
  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx


  echo " "
  
  #############################libpng############################
  
  cd $MAIN_FOLDER/Downloads
  export LDFLAGS=-L$DIR/grib2/lib
  export CPPFLAGS=-I$DIR/grib2/include
  tar -xvzf libpng-1.6.39.tar.gz
  cd libpng-1.6.39/
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check
  echo " "
  
  
  #############################JasPer############################
 
  cd $MAIN_FOLDER/Downloads
  unzip jasper-1.900.1.zip
  cd jasper-1.900.1/
  ./configure --prefix=$DIR/grib2
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export JASPERLIB=$DIR/grib2/lib
  export JASPERINC=$DIR/grib2/include
  echo " "
  
  
  #############################hdf5 library for netcdf4 functionality############################


  cd $MAIN_FOLDER/Downloads
  tar -xvzf hdf5-1_14_0.tar.gz
  cd hdf5-hdf5-1_14_0
  CC=$MPICC FC=$MPIFC F77=$MPIF77 F90=$MPIF90 CXX=$MPICXX ./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran --enable-parallel
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export HDF5=$DIR/grib2
  export PHDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH


  echo " "
  
  #############################Parallel-netCDF##############################


  cd $MAIN_FOLDER/Downloads
  tar -xvzf pnetcdf-1.12.3.tar.gz
  cd pnetcdf-1.12.3
  export MPIFC=$DIR/MPICH/bin/mpifort
  export MPIF77=$DIR/MPICH/bin/mpifort
  export MPIF90=$DIR/MPICH/bin/mpifort
  export MPICC=$DIR/MPICH/bin/mpicc
  export MPICXX=$DIR/MPICH/bin/mpicxx
  ./configure --prefix=$DIR/grib2  --enable-shared --enable-static

  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install
  #make check

  export PNETCDF=$DIR/grib2


  ##############################NETCDF C Library############################
  
  cd $MAIN_FOLDER/Downloads
  tar -xzvf v4.9.2.tar.gz
  cd netcdf-c-4.9.2/
  export CPPFLAGS=-I$DIR/grib2/include
  export LDFLAGS=-L$DIR/grib2/lib
  export LIBS="-lhdf5_hl -lhdf5 -lz -lcurl -lgfortran -lgcc -lm -ldl -lpnetcdf"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --disable-dap --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-pnetcdf --enable-cdf5 --enable-parallel-tests
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  export PATH=$DIR/NETCDF/bin:$PATH
  export NETCDF=$DIR/NETCDF
  echo " "
  
  
  ##############################NetCDF fortran library############################
  
  cd $MAIN_FOLDER/Downloads
  tar -xvzf v4.6.0.tar.gz
  cd netcdf-fortran-4.6.0/
  export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
  export CPPFLAGS="-I$DIR/NETCDF/include -I$DIR/grib2/include"
  export LDFLAGS="-L$DIR/NETCDF/lib -L$DIR/grib2/lib"
  export LIBS="-lnetcdf -lpnetcdf -lcurl -lhdf5_hl -lhdf5 -lz -lm -ldl -lgcc -lgfortran"
  CC=$MPICC FC=$MPIFC CXX=$MPICXX F90=$MPIF90 F77=$MPIF77 ./configure --prefix=$DIR/NETCDF --enable-netcdf-4 --enable-netcdf4 --enable-shared --enable-parallel-tests --enable-hdf5
  make -j $CPU_HALF_EVEN
  make -j $CPU_HALF_EVEN install | tee make.install.log
  #make check

  echo " "
  
  
  #################################### System Environment Tests##############

  cd $MAIN_FOLDER/Downloads/Tests
  tar -xvf Fortran_C_tests.tar -C $WRF_FOLDER/Tests/Environment
  tar -xvf Fortran_C_NETCDF_MPI_tests.tar -C $WRF_FOLDER/Tests/Compatibility

  export one="1"
  echo " "
  
  ############## Testing Environment ##############

  cd $WRF_FOLDER/Tests/Environment

  cp ${NETCDF}/include/netcdf.inc .

  echo " "
  echo " "
  echo "Environment Testing"
  echo "Test 1"
  gfortran TEST_1_fortran_only_fixed.f
  ./a.out | tee env_test1.txt
  export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test1.txt | awk  '{print$1}')
   if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 1 Passed"
      else
        echo "Environment Compiler Test 1 Failed"
        exit
    fi
  read -r -t 3 -p "I am going to wait for 3 seconds only ..."

  echo " "
  echo "Test 2"
  gfortran TEST_2_fortran_only_free.f90
  ./a.out | tee env_test2.txt
  export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test2.txt | awk  '{print$1}')
   if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 2 Passed"
      else
        echo "Environment Compiler Test 2 Failed"
        exit
    fi
  echo " "
  read -r -t 3 -p "I am going to wait for 3 seconds only ..."

  echo " "
  echo "Test 3"
  gcc TEST_3_c_only.c
  ./a.out | tee env_test3.txt
  export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test3.txt | awk  '{print$1}')
   if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 3 Passed"
      else
        echo "Environment Compiler Test 3 Failed"
        exit
    fi
  echo " "
  read -r -t 3 -p "I am going to wait for 3 seconds only ..."

  echo " "
  echo "Test 4"
  gcc -c -m64 TEST_4_fortran+c_c.c
  gfortran -c -m64 TEST_4_fortran+c_f.f90
  gfortran -m64 TEST_4_fortran+c_f.o TEST_4_fortran+c_c.o
  ./a.out | tee env_test4.txt
  export TEST_PASS=$(grep -w -o -c "SUCCESS" env_test4.txt | awk  '{print$1}')
   if [ $TEST_PASS -ge 1 ]
      then
        echo "Enviroment Test 4 Passed"
      else
        echo "Environment Compiler Test 4 Failed"
        exit
    fi
  echo " "
  read -r -t 3 -p "I am going to wait for 3 seconds only ..."

  echo " "
  
  ############## Testing Environment ##############

  cd $WRF_FOLDER/Tests/Compatibility

  cp ${NETCDF}/include/netcdf.inc .

  echo " "
  echo " "
  echo "Library Compatibility Tests "
  echo "Test 1"
  gfortran -c 01_fortran+c+netcdf_f.f
  gcc -c 01_fortran+c+netcdf_c.c
  gfortran 01_fortran+c+netcdf_f.o 01_fortran+c+netcdf_c.o \
       -L${NETCDF}/lib -lnetcdff -lnetcdf

       ./a.out | tee comp_test1.txt
       export TEST_PASS=$(grep -w -o -c "SUCCESS" comp_test1.txt | awk  '{print$1}')
        if [ $TEST_PASS -ge 1 ]
           then
             echo "Compatibility Test 1 Passed"
           else
             echo "Compatibility Compiler Test 1 Failed"
             exit
         fi
       echo " "
       read -r -t 3 -p "I am going to wait for 3 seconds only ..."

  echo " "

  echo "Test 2"
  mpifort -c 02_fortran+c+netcdf+mpi_f.f
  mpicc -c 02_fortran+c+netcdf+mpi_c.c
  mpifort 02_fortran+c+netcdf+mpi_f.o \
  02_fortran+c+netcdf+mpi_c.o \
       -L${NETCDF}/lib -lnetcdff -lnetcdf

  mpirun ./a.out | tee comp_test2.txt
  export TEST_PASS=$(grep -w -o -c "SUCCESS" comp_test2.txt | awk  '{print$1}')
   if [ $TEST_PASS -ge 1 ]
      then
        echo "Compatibility Test 2 Passed"
      else
        echo "Compatibility Compiler Test 2 Failed"
        exit
    fi
  echo " "
  read -r -t 3 -p "I am going to wait for 3 seconds only ..."
  echo " "

  echo " All tests completed and passed"
  echo " "


  ###############################NCEPlibs#####################################

  cd $MAIN_FOLDER/Downloads
  tar -xvzf NCEPlibs.tar.gz
  
  cd NCEPlibs
  mkdir $DIR/nceplibs

  export JASPER_INC=$DIR/grib2/include
  export PNG_INC=$DIR/grib2/include
  export NETCDF=$DIR/NETCDF

  #for loop to edit linux.gnu for nceplibs to install
  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    y="24 28 32 36 40 45 49 53 56 60 64 68 69 73 74 79"
    for X in $y; do
      sed -i "${X}s/= /= $fallow_argument $boz_argument /g" $MAIN_FOLDER/Downloads/NCEPlibs/macros.make.linux.gnu
    done
  else
    echo ""
    echo "Loop not needed"
  fi

  if [ ${auto_config} -eq 1 ]
    then
      echo yes | ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
    else
      ./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp
  fi

  export PATH=$DIR/nceplibs:$PATH

  echo " "
  
  
  ################################UPPv4.1######################################
  
  cd $MAIN_FOLDER/Downloads
  tar -xvzf UPPV4.1.tar.gz -C $WRF_FOLDER/
  
  cd $WRF_FOLDER/UPPV4.1
  mkdir postprd
  export NCEPLIBS_DIR=$DIR/nceplibs
  export NETCDF=$DIR/NETCDF

  if [ ${auto_config} -eq 1 ]
    then
      echo 8 | ./configure  #Option 8 gfortran compiler with distributed memory
    else
      ./configure  #Option 8 gfortran compiler with distributed memory
  fi


  #make if statement for gcc-9 or older
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
    then
      z="58 63"
      for X in $z; do
        sed -i "${X}s/(FOPT)/(FOPT) $fallow_argument $boz_argument  /g" $WRF_FOLDER/UPPV4.1/configure.upp
      done
    else
      echo ""
      echo "Loop not needed"
  fi

  ./compile
  
  cd $WRF_FOLDER/UPPV4.1/scripts
  echo $PASSWD | sudo -S cpan install XML::LibXML
  chmod +x run_unipost

  # IF statement to check that all files were created.
   cd $WRF_FOLDER/UPPV4.1/exec
   n=$(ls ./*.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing UPPV4.1. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "



  ######################## ARWpost V3.1############################

  cd $MAIN_FOLDER/Downloads
  tar -xvzf ARWpost_V3.tar.gz -C $WRF_FOLDER/
  
  cd $WRF_FOLDER/ARWpost
  ./clean -a
  sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $WRF_FOLDER/ARWpost/src/Makefile
  export NETCDF=$DIR/NETCDF


  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi


  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
  then
    sed -i '32s/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4/-ffree-form -O -fno-second-underscore -fconvert=big-endian -frecord-marker=4 ${fallow_argument} /g' configure.arwp
  fi


  sed -i -e 's/-C -P -traditional/-P -traditional/g' $WRF_FOLDER/ARWpost/configure.arwp
  ./compile


  export PATH=$WRF_FOLDER/ARWpost/ARWpost.exe:$PATH

  echo " "
  ################################ OpenGrADS##################################


  if [[ $GRADS_PICK -eq 1 ]]; then
      
    cd $MAIN_FOLDER/Downloads/OpenGrads
    tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $WRF_FOLDER/
    
    cd $WRF_FOLDER/
    mv $WRF_FOLDER/opengrads-2.2.1.oga.1  $WRF_FOLDER/GrADS
    
    cd GrADS/Contents
    cp $MAIN_FOLDER/Downloads/OpenGrads/g2ctl.pl $WRF_FOLDER/GrADS/Contents
    chmod +x g2ctl.pl
    
    cp $MAIN_FOLDER/Downloads/OpenGrads/wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz $WRF_FOLDER/GrADS/Contents
    tar -xzvf wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    cd wgrib2-v0.1.9.4/bin
    mv wgrib2 $WRF_FOLDER/GrADS/Contents
    
    cd $WRF_FOLDER/GrADS/Contents
    rm wgrib2-v0.1.9.4-bin-i686-glib2.5-linux-gnu.tar.gz
    rm -r wgrib2-v0.1.9.4


    export PATH=$WRF_FOLDER/GrADS/Contents:$PATH


  echo " "
  fi
  
  ################################## GrADS ###############################

  if [[ $GRADS_PICK -eq 2 ]]; then

    echo $PASSWD | sudo -S apt -y install grads

  fi

  ##################### NCAR COMMAND LANGUAGE##################

  export Miniconda_Install_DIR=$WRF_FOLDER/miniconda3

  mkdir -p $Miniconda_Install_DIR
  
  cp $MAIN_FOLDER/Downloads/Miniconda/miniconda.sh $Miniconda_Install_DIR/
  
  bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

  rm -rf $Miniconda_Install_DIR/miniconda.sh

  export PATH=$WRF_FOLDER/miniconda3/bin:$PATH

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh

  $Miniconda_Install_DIR/bin/conda init bash
  $Miniconda_Install_DIR/bin/conda init zsh
  $Miniconda_Install_DIR/bin/conda init tcsh
  $Miniconda_Install_DIR/bin/conda init xonsh
  $Miniconda_Install_DIR/bin/conda init powershell

  conda config --add channels conda-forge
  conda config --set auto_activate_base false
  conda update -n root --all -y


  export $PATH


  echo " "

  echo " "
  
  #Installing NCL via Conda
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n ncl_stable -c conda-forge ncl -y
  conda activate ncl_stable
  conda update -n ncl_stable --all -y
  conda deactivate
  conda deactivate
  conda deactivate

  echo " "


  ############################OBSGRID###############################
  
  cd $MAIN_FOLDER/Downloads/
  tar -xzvf OBSGRID.tar.gz -C $WRF_FOLDER/
   
  cd $WRF_FOLDER/OBSGRID

  ./clean -a
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate ncl_stable


  export HOME=`cd;pwd`
  export DIR=$WRF_FOLDER/Libs
  export NETCDF=$DIR/NETCDF


  if [ ${auto_config} -eq 1 ]
    then
        echo 2 | ./configure #Option 2 for gfortran/gcc and distribunted memory
      else
        ./configure   #Option 2 for gfortran/gcc and distribunted memory
  fi


  sed -i '27s/-lnetcdf -lnetcdff/ -lnetcdff -lnetcdf/g' configure.oa

  sed -i '31s/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo -lfontconfig -lpixman-1 -lfreetype -lhdf5 -lhdf5_hl /g' configure.oa

  sed -i '39s/-frecord-marker=4/-frecord-marker=4 ${fallow_argument} /g' configure.oa

  sed -i '44s/=	/=	${fallow_argument} /g' configure.oa

  sed -i '45s/-C -P -traditional/-P -traditional/g' configure.oa


  echo " "
  ./compile

  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/OBSGRID
   n=$(ls ./*.exe | wc -l)
   if (( $n == 3 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing OBSGRID. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi

  echo " "
  
  
  ############################## RIP4 #####################################

  mkdir $WRF_FOLDER/RIP4
 
  
  cd $MAIN_FOLDER/Downloads/
  tar -xvzf RIP_47.tar.gz -C $WRF_FOLDER/RIP4
  cd $WRF_FOLDER/RIP4/RIP_47
  mv * ..
  cd $WRF_FOLDER/RIP4
  rm -rd RIP_47
  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda activate ncl_stable
  conda install -c conda-forge ncl c-compiler fortran-compiler cxx-compiler -y


  export RIP_ROOT=$WRF_FOLDER/RIP4
  export NETCDF=$DIR/NETCDF
  export NCARG_ROOT=$WRF_FOLDER/miniconda3/envs/ncl_stable


  sed -i '349s|-L${NETCDF}/lib -lnetcdf $NETCDFF|-L${NETCDF}/lib $NETCDFF -lnetcdff -lnetcdf -lnetcdf -lnetcdff_C -lhdf5 |g' $WRF_FOLDER/RIP4/configure

  sed -i '27s|NETCDFLIB	= -L${NETCDF}/lib -lnetcdf CONFIGURE_NETCDFF_LIB|NETCDFLIB	= -L</usr/lib/x86_64-linux-gnu/libm.a> -lm -L${NETCDF}/lib CONFIGURE_NETCDFF_LIB -lnetcdf -lhdf5 -lhdf5_hl -lgfortran -lgcc -lz |g' $WRF_FOLDER/RIP4/arch/preamble

  sed -i '31s|-L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz CONFIGURE_NCARG_LIB| -L${NCARG_ROOT}/lib -lncarg -lncarg_gks -lncarg_c -lX11 -lXext -lpng -lz -lcairo -lfontconfig -lpixman-1 -lfreetype -lexpat -lpthread -lbz2 -lXrender -lgfortran -lgcc -L</usr/lib/x86_64-linux-gnu/> -lm -lhdf5 -lhdf5_hl |g' $WRF_FOLDER/RIP4/arch/preamble

  sed -i '33s| -O|-fallow-argument-mismatch -O |g' $WRF_FOLDER/RIP4/arch/configure.defaults

  sed -i '35s|=|= -L$WRF_FOLDER/LIBS/grib2/lib -lhdf5 -lhdf5_hl |g' $WRF_FOLDER/RIP4/arch/configure.defaults


  if [ ${auto_config} -eq 1 ]
    then
      echo 3 | ./configure  #Option 3 gfortran compiler with distributed memory
    else
      ./configure  #Option 3 gfortran compiler with distributed memory
  fi

  ./compile

  conda deactivate
  conda deactivate
  conda deactivate


  echo " "
  
  
  ##################### WRF Python           ##################

  source $Miniconda_Install_DIR/etc/profile.d/conda.sh
  conda init bash
  conda activate base
  conda create -n wrf-python -y
  conda activate wrf-python
  conda install -c conda-forge netcdf4=1.5.8 -y --freeze-installed
  conda install -c conda-forge imageio=2.27.0 -y --freeze-installed
  conda install -c conda-forge basemap=1.3.6 -y --freeze-installed
  conda install -c conda-forge metpy=1.4.1 -y --freeze-installed
  conda install -c conda-forge wrf-python=1.3.4.1 -y --freeze-installed

  conda deactivate
  conda deactivate
  conda deactivate

  echo " "
  
  
  ############################ WRF 4.5#################################
 

  cd $MAIN_FOLDER/Downloads/
  tar -xvzf WRF-4.5.tar.gz -C $WRF_FOLDER/

  # If statment for changing folder name
  if [ -d "$WRF_FOLDER/WRF" ]; then
  mv -f $WRF_FOLDER/WRF $WRF_FOLDER/WRFV4.5
  fi

  cd $WRF_FOLDER/WRFV4.5
  export WRFIO_NCD_LARGE_FILE_SUPPORT=1
  ./clean -a

  #SED statements to fix configure error
  sed -i '186s/==/=/g' $WRF_FOLDER/WRFV4.5/configure
  sed -i '318s/==/=/g' $WRF_FOLDER/WRFV4.5/configure
  sed -i '919s/==/=/g' $WRF_FOLDER/WRFV4.5/configure


  if [ ${auto_config} -eq 1 ]
    then
      echo "34
      1" | ./configure
    else
      ./configure  #Option 34 gfortran compiler with distributed memory option 1 for basic nesting
  fi

  ./compile -j $CPU_HALF_EVEN em_real

  export WRF_DIR=$WRF_FOLDER/WRFV4.5


  # IF statement to check that all files were created.
  cd $WRF_FOLDER/WRFV4.5/main
  n=$(ls ./*.exe | wc -l)
  if (($n >= 3))
   then
   echo "All expected files created."
   read -r -t 5 -p "Finished installing WRF. I am going to wait for 5 seconds only ..."
  else
   echo "Missing one or more expected files. Exiting the script."
   read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
   exit
  fi
  echo " "
  
  
  ############################WPSV4.5#####################################
  
  cd $MAIN_FOLDER/Downloads/
  tar -xvzf WPS-4.5.tar.gz -C $WRF_FOLDER/
  cd $WRF_FOLDER/WPS-4.5
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 1 | ./configure
      else
        ./configure  #Option 3 gfortran compiler with distributed memory
  fi
  ./compile


  echo " "
  
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WPS-4.5
   n=$(ls ./*.exe | wc -l)
   if (($n == 3))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WPS. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
   echo " "
   


  ############################WRFPLUS 4DVAR###############################

  cd $MAIN_FOLDER/Downloads/
  tar -xvzf WRF-4.5.tar.gz -C $WRF_FOLDER/WRFPLUS

  # If statment for changing folder name
  if [ -d "$WRF_FOLDER/WRFPLUS/WRF" ]; then
  mv -f $WRF_FOLDER/WRFPLUS/WRF $WRF_FOLDER/WRFPLUS/WRFV4.5
  fi

  cd $WRF_FOLDER/WRFPLUS/WRFV4.5
  mv * $WRF_FOLDER/WRFPLUS
  cd $WRF_FOLDER/WRFPLUS
  rm -rf WRFV4.5/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 18 | ./configure wrfplus
      else
        ./configure  wrfplus  #Option 18 for gfortran/gcc and distribunted memory
    fi
  echo " "
  ./compile -j $CPU_HALF_EVEN wrfplus
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS


  echo " "
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFPLUS/main
   n=$(ls ./wrfplus.exe | wc -l)
   if (( $n == 1 ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WRF Plus 4DVAR. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
  echo " "
  
  
  ############################WRFDA 4DVAR###############################


  cd $MAIN_FOLDER/Downloads/
  mkdir $WRF_FOLDER/WRFDA
  tar -xvzf WRF-4.5.tar.gz -C $WRF_FOLDER/WRFDA

  # If statment for changing folder name
  if [ -d "$WRF_FOLDER/WRFDA/WRF" ]; then
  mv -f $WRF_FOLDER/WRFDA/WRF $WRF_FOLDER/WRFDA/WRFV4.5
  fi

  cd $WRF_FOLDER/WRFDA/WRFV4.5
  mv * $WRF_FOLDER/WRFDA
  cd $WRF_FOLDER/WRFDA
  rm -rf WRFV4.5/
  export NETCDF=$DIR/NETCDF
  export HDF5=$DIR/grib2
  export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
  export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS
  ./clean -a

  if [ ${auto_config} -eq 1 ]
    then
        echo 18 | ./configure 4dvar
      else
        ./configure  4dvar  #Option 18 for gfortran/gcc and distribunted memory
  fi
  echo " "
  ./compile all_wrfvar | tee compile1.log
  echo " "
  
  # IF statement to check that all files were created.
   cd $WRF_FOLDER/WRFDA/var/da
   n=$(ls ./*.exe | wc -l)
   cd $WRF_FOLDER/WRFDA/var/obsproc/src
   m=$(ls ./*.exe | wc -l)
   if (( ( $n == 43 ) && ( $m == 1) ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing WRFDA 4DVAR. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
   fi
  echo " "

  echo " "
  
  
  ######################## WPS Domain Setup Tools########################
  

  cd $MAIN_FOLDER/Downloads/
  mkdir $WRF_FOLDER/WRFDomainWizard
  unzip WRFDomainWizard.zip -d $WRF_FOLDER/WRFDomainWizard
  chmod +x $WRF_FOLDER/WRFDomainWizard/run_DomainWizard

  echo " "
  
  ######################## WPF Portal Setup Tools########################


  cd $MAIN_FOLDER/Downloads/
  mkdir $WRF_FOLDER/WRFPortal
  unzip wrf-portal.zip -d $WRF_FOLDER/WRFPortal
  chmod +x $WRF_FOLDER/WRFPortal/runWRFPortal


  echo " "

  ######################## Static Geography Data inc/ Optional####################


  mkdir $WRF_FOLDER/GEOG
  mkdir $WRF_FOLDER/GEOG/WPS_GEOG

  echo " "
  echo "Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads"
  echo " "

  
  cd $MAIN_FOLDER/Downloads/
  tar -xvzf geog_high_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/

  
  tar -xvzf geog_low_res_mandatory.tar.gz -C $WRF_FOLDER/GEOG/
  mv $WRF_FOLDER/GEOG/WPS_GEOG_LOW_RES/ $WRF_FOLDER/GEOG/WPS_GEOG


  if [ ${WPS_Specific_Applications} -eq 1 ]
    then
      echo " "
      echo " WPS Geographical Input Data Mandatory for Specific Applications"
      echo " "

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
      tar -xvzf geog_thompson28_chem.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
      tar -xvzf geog_noahmp.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
      tar -xvzf irrigation.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
      tar -xvzf geog_px.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
      tar -xvzf geog_urban.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
      tar -xvzf geog_ssib.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
      tar -xvf lake_depth.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2
      tar -xvf topobath_30s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.bz2
      tar -xvf gsl_gwd.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG
  fi


  if [ ${Optional_GEOG} -eq 1 ]
    then
      echo " "
      echo "Optional WPS Geographical Input Data"
      echo " "


      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
      tar -xvzf geog_older_than_2000.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
      tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
      tar -xvzf geog_alt_lsm.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
      tar -xvf nlcd2006_ll_9s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
      tar -xvf updated_Iceland_LU.tar.gz -C $WRF_FOLDER/GEOG/WPS_GEOG

      wget -c -4 https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
      tar -xvf modis_landuse_20class_15s.tar.bz2 -C $WRF_FOLDER/GEOG/WPS_GEOG


  fi


  ############################ ioapi-3.2 ###############################
  export DIR=$WRF_FOLDER/Libs
  
  cd $MAIN_FOLDER/Downloads/
  
  mkdir $DIR/ioapi-3.2/
  tar -xvzf ioapi-3.2.tar.gz -C $DIR/ioapi-3.2/

  cd $DIR/ioapi-3.2/ioapi
  cp Makefile.nocpl Makefile
  
  export BIN=Linux2_x86_64gfort_gcc
  
  #IF statement for GNU compiler issue
  export GCC_VERSION=$(/usr/bin/gcc -dumpfullversion | awk '{print$1}')
  export GFORTRAN_VERSION=$(/usr/bin/gfortran -dumpfullversion | awk '{print$1}')
  export GPLUSPLUS_VERSION=$(/usr/bin/g++ -dumpfullversion | awk '{print$1}')

  export GCC_VERSION_MAJOR_VERSION=$(echo $GCC_VERSION | awk -F. '{print $1}')
  export GFORTRAN_VERSION_MAJOR_VERSION=$(echo $GFORTRAN_VERSION | awk -F. '{print $1}')
  export GPLUSPLUS_VERSION_MAJOR_VERSION=$(echo $GPLUSPLUS_VERSION | awk -F. '{print $1}')

  export version_10="10"

  if [ $GCC_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GFORTRAN_VERSION_MAJOR_VERSION -ge $version_10 ] || [ $GPLUSPLUS_VERSION_MAJOR_VERSION -ge $version_10 ]
    then
      cp Makeinclude.Linux2_x86_64gfort10dbg Makeinclude.Linux2_x86_64gfort_gcc
    else
      cp Makeinclude.Linux2_x86_64gfort Makeinclude.Linux2_x86_64gfort_gcc
  fi

  sed -i -e 's/-fopenmp/#-fopenmp/g' $DIR/ioapi-3.2/ioapi/Makeinclude.Linux2_x86_64gfort_gcc
  
  mkdir ../$BIN
  cd ../
  ln -s Linux2_x86_64gfort_gcc Linux2_x86_64gfort
  
  cd ioapi
  make 'HOME=${DIR}' |& tee make.log
  
  cd ../m3tools
  cp Makefile.nocpl Makefile
  sed -i '65s|LIBS = -L${OBJDIR} -lioapi -lnetcdff -lnetcdf $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)|LIBS = -L${OBJDIR} -lioapi -L${DIR}/NETCDF/lib -lnetcdff -L${DIR}/NETCDF/lib -lnetcdf $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)|g' $DIR/ioapi-3.2/m3tools/Makefile
  
  make 'HOME=${DIR}' |& tee make.log

  # IF statement to check that all files were created.
  cd ../
  cd $BIN
  m=$(ls -rlt m3xtract | wc -l)
  if (( ( $m == 1) ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing ioapi-3.2. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
  fi
   
  echo " "


  ############################ SMOKEV5 ###############################
  
  cd $MAIN_FOLDER/Downloads/
  mkdir $WRF_FOLDER/SMOKEV5
  tar -xvzf smoke_v5.Linux2_x86_64ifort.tar.gz -C $WRF_FOLDER/SMOKEV5
  
  export BIN=Linux2_x86_64gfort
  export SMK_HOME=$WRF_FOLDER/SMOKEV5
  
  tar -xvzf SMOKEv5_Jun2023.tar.gz -C $SMK_HOME/subsys/
  
  cd $SMK_HOME/subsys/
  cp -r SMOKE-SMOKEv5_Jun2023/assigns smoke
  cp -r SMOKE-SMOKEv5_Jun2023/scripts smoke
  rm -r SMOKE-SMOKEv5_Jun2023
  
  cd $MAIN_FOLDER/Downloads/
  tar -xvzf smoke_v48.nctox.data.tar.gz -C $SMK_HOME/
  
  cd $SMK_HOME/subsys/smoke/
  mkdir $BIN
  
  cd src
  sed -i '35s|IOBASE  = ${SMK_HOME}/subsys/ioapi|IOBASE = ${DIR}/ioapi-3.2|g' Makeinclude
  sed -i '40s|INSTDIR = /somewhere/apps/${BIN}|INSTDIR = ${SMK_HOME}/subsys/smoke/${BIN}|g' Makeinclude
  sed -i '48s| IFLAGS|# IFLAGS|g' Makeinclude
  sed -i '49s|# IFLAGS| IFLAGS|g' Makeinclude
  sed -i '53s| EFLAG|# EFLAG|g' Makeinclude
  sed -i '54s|# EFLAG| EFLAG|g' Makeinclude
  sed -i '59s|MFLAGS  = -traceback|MFLAGS  = -fallow-argument-mismatch -m64|g' Makeinclude
  sed -i '72s|IOLIB = -L$(IOBIN) -lioapi -lnetcdff -lnetcdf|IOLIB = -L$(IOBIN) -lioapi -L${DIR}/NETCDF/lib -lnetcdff -L${DIR}/NETCDF/lib -lnetcdf|g' Makeinclude
  
  make |& tee make.log
  
  cd ../
  cd $BIN
  m=$(ls -rlt aggwndw | wc -l)
  if (( ( $m == 1) ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing SMOKEV5. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
  fi


  ############################ CMAQV5.4 ###############################
  #!/bin/csh
  
  cd $MAIN_FOLDER/Downloads/

  unzip master.zip -d $WRF_FOLDER/
  
  cd $WRF_FOLDER/CMAQ-main
  sed -i "19s|set CMAQ_HOME = /home/username/path|set CMAQ_HOME = ${WRF_FOLDER}/CMAQV5.4|g" $WRF_FOLDER/CMAQ-main/bldit_project.csh
  
  export CMAQ_HOME=$WRF_FOLDER/CMAQV5.4
  
  chmod 775 bldit_project.csh
  ./bldit_project.csh
  
  cd $WRF_FOLDER/CMAQV5.4
  
  sed -i "151s|setenv IOAPI_INCL_DIR   ioapi_inc_gcc|setenv IOAPI_INCL_DIR   ${DIR}/ioapi-3.2/ioapi/fixed_src|g" config_cmaq.csh
  sed -i "152s|setenv IOAPI_LIB_DIR    ioapi_lib_gcc|setenv IOAPI_LIB_DIR    ${DIR}/ioapi-3.2/Linux2_x86_64gfort_gcc|g" config_cmaq.csh
  sed -i "153s|setenv NETCDF_LIB_DIR   netcdf_lib_gcc|setenv NETCDF_LIB_DIR   ${DIR}/NETCDF/lib|g" config_cmaq.csh
  sed -i "154s|setenv NETCDF_INCL_DIR  netcdf_inc_gcc|setenv NETCDF_INCL_DIR  ${DIR}/NETCDF/include|g" config_cmaq.csh
  sed -i "155s|setenv NETCDFF_LIB_DIR  netcdff_lib_gcc|setenv NETCDFF_LIB_DIR  ${DIR}/NETCDF/lib|g" config_cmaq.csh
  sed -i "156s|setenv NETCDFF_INCL_DIR netcdff_inc_gcc|setenv NETCDFF_INCL_DIR ${DIR}/NETCDF/include|g" config_cmaq.csh
  sed -i "157s|setenv MPI_INCL_DIR     mpi_incl_gcc|setenv MPI_LIB_DIR      ${DIR}/MPICH/lib|g" config_cmaq.csh
  sed -i "158s|setenv MPI_LIB_DIR      mpi_lib_gcc|setenv MPI_INCL_DIR 	${DIR}/MPICH/include|g" config_cmaq.csh


  #sed -i "162s|setenv myFC mpifort|setenv myFC mpif90|g" config_cmaq.csh
  
  sed -i '193s|setenv netcdf_lib "-lnetcdf"|setenv netcdf_lib "-lnetcdf -lnetcdff -lgomp"|g' config_cmaq.csh
  sed -i '194s|setenv netcdff_lib "-lnetcdff"|setenv netcdff_lib "-lnetcdf -lnetcdff -lgomp"|g' config_cmaq.csh

  sed -i '197s|setenv mpi_lib "-lmpi"|setenv mpi_lib "-lmpich"|g' config_cmaq.csh

  export compiler=gcc
  source config_cmaq.csh
  
  cd $WRF_FOLDER/CMAQV5.4/CCTM/scripts
  
  sed -i '445s|set shaID|#set shaID|g' bldit_cctm.csh
  sed -i '446s|if (|#if (|g' bldit_cctm.csh
  sed -i '447s|set|#set|g' bldit_cctm.csh
  sed -i '448s|endif|#endif|g' bldit_cctm.csh
  sed -i '466s|echo|#echo|g' bldit_cctm.csh
  
  chmod 775 bldit_cctm.csh
  ./bldit_cctm.csh gcc |& tee bldit.cctm.log

  # IF statement to check that all files were created.

  m=$(find . -type f -name "*.exe" | wc -l)
  if (( ( $m >= 1) ))
    then
      echo "All expected files created."
      read -r -t 5 -p "Finished installing CCTM. I am going to wait for 5 seconds only ..."
   else
     echo "Missing one or more expected files. Exiting the script."
     read -r -p "Please contact script authors for assistance, press 'Enter' to exit script."
     exit
  fi
  
  
  cd $WRF_FOLDER/CMAQV5.4/PREP/mcip/src
  
  sed -i "39s|#FC|FC|g" Makefile
  sed -i "40s|#NETCDF = /usr/local/apps/netcdf-4.6.3/gcc-6.1.0|NETCDF = ${DIR}/NETCDF|g" Makefile
  sed -i "41s|#IOAPI_ROOT = /usr/local/apps/ioapi-3.2_20181011/gcc-6.1.0|IOAPI_ROOT = ${DIR}/ioapi-3.2/|g" Makefile
  sed -i "42s|#FFLAGS|FFLAGS|g" Makefile
  sed -i "42s|Linux2_x86_64|Linux2_x86_64gfort_gcc|g" Makefile
  sed -i "46s|#LIBS|LIBS|g" Makefile
  sed -i "46s|Linux2_x86_64|Linux2_x86_64gfort_gcc|g" Makefile
  sed -i "47s|#| |g" Makefile  
  sed -i "50s|FC|#FC|g" Makefile
  sed -i "51s|NETCDF|#NETCDF|g" Makefile
  sed -i "52s|IOAPI_ROOT|#IOAPI_ROOT|g" Makefile
  sed -i "55s|FFLAGS|#FFLAGS|g" Makefile
  sed -i "56s|LIBS|#LIBS|g" Makefile
  sed -i "57s|-L|#-L|g" Makefile
  
  make -j $CPU_HALF_EVEN
  
  cd $WRF_FOLDER/CMAQV5.4/PREP/bcon/scripts
  chmod 775 *
  ./bldit_bcon.csh gcc |& tee bldit_bcon.log
  
  cd $WRF_FOLDER/CMAQV5.4/PREP/icon/scripts
  chmod 775 *
  ./bldit_icon.csh gcc |& tee bldit_icon.log
  
  
  cd $WRF_FOLDER/CMAQV5.4/PREP/create_omi/scripts
  sed -i "38s|./config_cmaq.csh|./config_cmaq.csh gcc|g" bldit_create_omi.csh
  sed -i '41s|"/home/hwo/CCTM_git_repository"|$WRF_FOLDER/CMAQ-main|g' bldit_create_omi.csh
  chmod 775 *
  ./bldit_create_omi.csh gcc |& tee bldit_create_omi.log
  
  
 
  echo " "
  echo " "



fi




##########################  Export PATH and LD_LIBRARY_PATH ################################
cd $HOME

while read -r -p "Would to append your exports to your terminal profile (bashrc)?
  This will allow users to execute all the programs installed in this script.

  Please note that if users choose YES the user will not be able to install another WRF version in parallel with the one the user installed on the same system.

  For example:  Users could not have WRF AND WRFCHEM installed if YES is chosen.
  if NO is chosen then users could have WRF OR WRFCHEM installed on the same sytem if NO is chosen.

  Please answer (Y/N) )and press enter (case sensative).
  " yn; do

    case $yn in
    [Yy]* )
      echo "-------------------------------------------------- "
      echo " "
      echo "Exporting to bashrc"
      echo "export WRF_FOLDER=$HOME/WRF" >> ~/.bashrc     
      echo "export DIR=$WRF_FOLDER/Libs" >> ~/.bashrc
      echo "export SMK_HOME=$WRF_FOLDER/SMOKEV5" >> ~/.bashrc
      echo "export BIN=Linux2_x86_64gfort" >> ~/.bashrc
      echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
      echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
      echo "export CC=/usr/bin/gcc" >> ~/.bashrc
      echo "export CXX=/usr/bin/g++" >> ~/.bashrc
      echo "export FC=/usr/bin/gfortran" >> ~/.bashrc
      echo "export F77=/usr/bin/gfortran" >> ~/.bashrc
      echo "export F90=/usr/bin/gfortran" >> ~/.bashrc
      echo "export MPIFC=$DIR/MPICH/bin/mpifort" >> ~/.bashrc
      echo "export MPIF77=$DIR/MPICH/bin/mpifort" >> ~/.bashrc
      echo "export MPIF90=$DIR/MPICH/bin/mpifort" >> ~/.bashrc
      echo "export MPICC=$DIR/MPICH/bin/mpicc" >> ~/.bashrc
      echo "export MPICXX=$DIR/MPICH/bin/mpicxx" >> ~/.bashrc
      echo "export LDFLAGS=-L$DIR/grib2/lib" >> ~/.bashrc
      echo "export CPPFLAGS=-I$DIR/grib2/include" >> ~/.bashrc
      echo "export JASPERLIB=$DIR/grib2/lib" >> ~/.bashrc
      echo "export JASPERINC=$DIR/grib2/include" >> ~/.bashrc
      echo "export HDF5=$DIR/grib2" >> ~/.bashrc
      echo "export PHDF5=$DIR/grib2" >> ~/.bashrc
      echo "export PNETCDF=$DIR/grib2" >> ~/.bashrc
      echo "export NETCDF=$DIR/NETCDF" >> ~/.bashrc
      echo "export JASPER_INC=$DIR/grib2/include" >> ~/.bashrc
      echo "export PNG_INC=$DIR/grib2/include" >> ~/.bashrc
      echo "export NCEPLIBS_DIR=$DIR/nceplibs" >> ~/.bashrc
      echo "export Miniconda_Install_DIR=$WRF_FOLDER/miniconda3" >> ~/.bashrc
      echo "export RIP_ROOT=$WRF_FOLDER/RIP4" >> ~/.bashrc
      echo "export NCARG_ROOT=$WRF_FOLDER/miniconda3/envs/ncl_stable" >> ~/.bashrc
      echo "export WRFPLUS_DIR=$WRF_FOLDER/WRFPLUS" >> ~/.bashrc
      echo "export CMAQ_HOME=$WRF_FOLDER/CMAQV5.4" >> ~/.bashrc
      echo "export compiler=gcc" >> ~/.bashrc
      break
      ;;
    [Nn]* )
      echo "-------------------------------------------------- "
      echo " "
      echo "Exports will NOT be added to bashrc"
      break
      ;;
      * )
     echo " "
     echo "Please answer YES or NO (case sensative).";;

  esac
done







#####################################BASH Script Finished##############################



end=`date`
END=$(date +"%s")
DIFF=$(($END-$START))
echo "Install Start Time: ${start}"
echo "Install End Time: ${end}"
echo "Install Duration: $(($DIFF / 3600 )) hours $((($DIFF % 3600) / 60)) minutes $(($DIFF % 60)) seconds"
