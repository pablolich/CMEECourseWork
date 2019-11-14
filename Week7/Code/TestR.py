#!/usr/bin/env python3 

#Calling R from python

import subprocess

subprocess.Popen("Rscript --verbose Test.R > ../Results/TestR.Rout 2> \
                 ../Results/TestR_errFile.Rout", shell=True).wait()


