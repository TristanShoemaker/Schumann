# Schumann Resonances

Data analysis scripts. 

Standard procedure is:
=============================
DAT\_converter.m (both sets)
	     v
DAT\_merger.m (both sets)
	     v
CPSD\_PSD\_CALC.m (only once)
 	     v
PSD\_merger.m (both sets) + CPSD\_merger.m (only once)
	     v
COHE_calc.m (only once)
	     v
       dependant on:
	     v
  time\_clean.m + clean.m
	     v
       dependant on:
	     v			     
	 bandRMS.m
=============================

Most interesting parameters for adjusting the data selection and therefore the resulting coherence plot are in COHE\_calc.m.
