# MATLAB

MATLAB functions for reading Hyytiala W-band radar spectra data.
Contact: haoran.li@helsinki.fi

Version 3.5 for Hyytiala RPG W-band radar. Last access: 27th Sep. 2019

Contributor: haoran.li@helsinki.fi
Codes from IGMK and Dmitri Moisseev are partly adopted

Currently for CompEna == 1 && DualPol == 1 

!!! NOTE !!!
Be careful when editing spectra reading, two scenarios
% 1) block loop after all Hspec, Vspec. e.g., Hspec,  Vspec -> block loop
% 2) block loop after each spec variable. e.g., Hspec -> block loop, Vspec -> lock loop 
