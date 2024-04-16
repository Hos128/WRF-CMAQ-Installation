<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Bash script for installing WRF, CMAQ, and SMOKE models. Includes offline installation and library references.">
<meta name="keywords" content="WRF, CMAQ, SMOKE, installation, Bash script, libraries">
<meta name="author" content="Hossein Alizadeh, HOS128, CREATE Group">
<meta name="google-site-verification" content="12hvjbXqFo5VfdqyyvUg6GGPquKydGtLno_Z3584ZwI">
<meta property="og:title" content="Automatic Installation Script for WRF V4.5, CMAQ V5.4, and SMOKE V5.0">
<meta property="og:description" content="Bash script for installing WRF, CMAQ, and SMOKE models. Includes offline installation and library references.">
<meta property="og:type" content="website">
<meta property="og:url" content="URL_OF_YOUR_PAGE">
<meta property="og:image" content="https://www.cmascenter.org/images/site_wide/cmas_logo.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Automatic Installation Script for WRF V4.5, CMAQ V5.4, and SMOKE V5.0">
<meta name="twitter:description" content="Bash script for installing WRF, CMAQ, and SMOKE models. Includes offline installation and library references.">
<meta name="twitter:image" content="https://www.cmascenter.org/images/site_wide/cmas_logo.png">


Automatic Installation Script for WRF V4.5, CMAQ V5.4, and SMOKE V5.0
========================================================

This Bash script is developed in the [CREATE](https://www.sfu.ca/see/research/sustainable-urban-transportation.html) group to streamline the installation process for WRF (Weather Research and Forecasting Model) version 4.5, CMAQ (Community Multi-scale Air Quality Model) version 5.4, and SMOKE (Sparse Matrix Operator Kernel Emissions) models. The script ensures a hassle-free setup by automating the installation of all required libraries and pre-postprocessing software. The WRF installation script is a fork of the main Bash scripts developed by [W. Hatheway](https://github.com/HathewayWill/WRF-MOSIT.git). CMAQ and SMOKE are also added to the bash script to provide an easy way to use and run WRF, SMOKE, and CMAQ models. All necessary modules (including CCTM, Bcon, Icon, and OMI) inside CMAQ are also built by the script for the users.

Features
--------
*   **WRF-CMAQ-SMOKE auto-installation**: The script extends the functionality of the original script by incorporating the IOAPI library and CMAQ/SMOKE models installation.
  
*   **Offline Installation**: It has been modified to enable an offline installation approach, minimizing dependencies on external servers. The script takes advantage of an offline approach by pre-downloading and locally storing almost all necessary files in Google Drive Cloud Storage. This design allows the script to function independently of the specific location of each library. If library paths change in the future, the script remains robust and functional without any adjustments.
    
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
    - [GitHub - WRF-model](https://github.com/wrf-model/)

15. **WPS Domain Setup and WPF Portal Setup Tools**
    - [NOAA - ESRL](https://esrl.noaa.gov/)

16. **IOAPI**
    - [CMAS Center](https://www.cmascenter.org/ioapi/)

17. **CMAQV5.4**
    - [GitHub - USEPA](https://github.com/USEPA/CMAQ/)

18. **SMOKEV5.0**
    - [CMAS Center](https://www.cmascenter.org/ioapi/)



Feel free to contribute, report issues, or provide feedback!
