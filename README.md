Automatic Installation Script for WRF V4.5 and CMAQ V5.4
========================================================

This Bash script streamlines the installation process for WRF (Weather Research and Forecasting Model) version 4.5 and CMAQ (Community Multi-scale Air Quality Model) version 5.4. The script ensures a hassle-free setup by automating the installation of all required libraries and pre-postprocessing software. This script is a fork of the main Bash scripts developed by W. Hatheway for installing the WRF model.

Features
--------
*   **WRF-CMAQ auto-installation**: The script extends the functionality of the original script by incorporating the IOAPI library and CMAQ model installation.
  
*   **Offline Installation**: It has been modified to enable an offline installation approach, minimizing dependencies on external servers.
    
*   **Cloud Storage**: The script takes advantage of an offline approach by pre-downloading and locally storing almost all necessary files in a Google Drive Cloud Storage. This design allows the script to function independently of the specific location of each library. If library paths change in the future, the script remains robust and functional without any adjustments.
    
*   **Reliable and Independent**: Despite its reliance on Internet connectivity for file downloads during installation, this Bash script is designed to operate offline once the necessary files are obtained. This ensures a stable and consistent installation process even in environments with limited Internet access.
    

Usage
-----

1.  Ensure an Internet connection for initial file downloads.
2.  Run the script to automatically install WRF V4.5 and CMAQ V5.4 along with all required libraries.


Installation Instructions
-----

Follow these steps to install WRF V4.5 and CMAQ V5.4 along with the required libraries:

1. **Clone the Repository:**
    ```bash
    cd $HOME
    git clone https://github.com/Hos128/WRF-CMAQ-Installation.git
    cd $HOME/WRF-CMAQ-Installation
    ```

2. **Set Permissions:**
    ```bash
    chmod 775 *.sh
    ```

3. **Run the Installation Script:**
    ```bash
    ./OfflineWRFCMAQ.sh 2>&1 | tee OfflineWRFCMAQ.log
    ```



Library References
------------------

1. **MET and METplus**
   - [DTcenter](https://dtcenter.org/)

2. **Zlib library**
   - [GitHub - zlib](https://github.com/madler/zlib)

3. **HDF5**
   - [GitHub - HDFGroup](https://github.com/HDFGroup/hdf5)

4. **NETCDF**
   - [GitHub - Unidata](https://github.com/Unidata/)

5. **Libpng**
   - [SourceForge - libpng](https://download.sourceforge.net/libpng/)

6. **Jasper**
   - [Jasper Project](https://www.ece.uvic.ca/~frodo/jasper/)

7. **MPICH**
   - [GitHub - mpich](https://github.com/pmodels/mpich/)

8. **Parallel-NetCDF**
   - [Parallel-netcdf](https://parallel-netcdf.github.io/)

9. **Opengrads**
   - [SourceForge - opengrads](https://sourceforge.net/projects/opengrads/)

10. **NCEPlibs**
    - [GitHub - NCAR](https://github.com/NCAR/)

11. **UPPv4.1**
    - [GitHub - NOAA-EMC](https://github.com/NOAA-EMC/EMC_post)

12. **Geographical Input Data, ARWpost, RIP4**
    - [UCAR - MMM](http://www2.mmm.ucar.edu/)

13. **Miniconda**
    - [Anaconda - Miniconda](https://repo.anaconda.com/miniconda/)

14. **WRFv4.5, WPSV4.5, OBSGRID**
    - [GitHub - wrf-model](https://github.com/wrf-model/OBSGRID)

15. **WPS Domain Setup and WPF Portal Setup Tools**
    - [NOAA - ESRL](https://esrl.noaa.gov/)

16. **IOAPI**
    - [CMAS Center](https://www.cmascenter.org/ioapi/)

17. **CMAQV5.4**
    - [GitHub - USEPA](https://github.com/USEPA/CMAQ/)




Feel free to contribute, report issues, or provide feedback!
