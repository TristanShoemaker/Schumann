Standard procedure is:
=============================
```
DAT_converter.m (both sets) 
	     v
DAT_merger.m (both sets)
	     v
CPSD_PSD_CALC.m (only once)
 	     v
PSD_merger.m (both sets) + CPSD_merger.m (only once)
	     v
COHE_calc.m (only once)
	     v
    dependant on:
	     v
  time_clean.m + clean.m
	     v
	dependant on:
	     v			     
	 bandRMS.m
```
=============================

Most interesting parameters for adjusting the data selection and therefore the resulting coherence plot are in COHE\_calc.m.
