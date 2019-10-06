# MATLAB

MATLAB functions for reading Hyytiala W-band radar spectra data.
Contact: haoran.li@helsinki.fi

Version 3.5 for Hyytiala RPG W-band radar. 

Contributor: haoran.li@helsinki.fi

Codes from IGMK and Dmitri Moisseev are partly adopted

Currently for CompEna == 1 && DualPol == 1 

!!! NOTE !!!

1. Be careful when editing spectra reading. 2 scenarios  
  (1) block loop after all Hspec, Vspec.  e.g., Hspec,  Vspec -> block loop  
  (2) block loop after each spec variable.  e.g., Hspec -> block loop, Vspec -> lock loop 
  
2. The number of FFT may change.  



UPDATES:

20191005: Saving raw data to netcdf is feasible.

          For LDR mode but not Simultaneous Transmission Simultaneous Reception (STSR) mode

          LV0: level 0 product; mostly for spectra analysis
          
          LV1: level 1 product; e.g., Ze, V, LDR ...
          