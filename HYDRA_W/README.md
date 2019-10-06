# MATLAB

MATLAB functions for reading Hyytiala W-band radar spectra data.
Contact: haoran.li@helsinki.fi

Version 3.5 for Hyytiala RPG W-band radar. 

Contributor: haoran.li@helsinki.fi

Codes from IGMK and Dmitri Moisseev are partly adopted

Currently for CompEna == 1 && DualPol == 1 

!!! NOTE !!!

1. Be careful when reading spectra (LV0 data). 2 scenarios  
  (1) block loop after all Hspec, Vspec.  e.g., Hspec,  Vspec -> block loop  
  (2) block loop after each spec variable.  e.g., Hspec -> block loop, Vspec -> lock loop 
  
2. The number of FFT may change (LV0 data).  



UPDATES:

20191006: 
1) Saving raw data to netcdf is feasible.

          For LDR mode but not Simultaneous Transmission Simultaneous Reception (STSR) mode

          LV0: level 0 product; mostly for spectra analysis
          
          LV1: level 1 product; e.g., Ze, V, LDR ...
          
20191007: 
1) Retrieving LV0 data from netcdf is feasible.

          For number of chirps == 3 only
          
          Velocity folding and alias are corrected (see two subfunctions)
          
         
2) LV1: A ploting function is added (Ze+LDR+v in one figure)
