#!/bin/bash 

#Runs both LV1.py and LV2.py
echo 'Profiling for LV1.py :' > ../Results/profiling.txt
python3 -m cProfile LV1.py | head -1 >> ../Results/profiling.txt
echo 'Profiling for LV2.py :' >> ../Results/profiling.txt
python3 -m cProfile LV2.py | head -1 >> ../Results/profiling.txt
echo 'Profiling for LV3.py :' >> ../Results/profiling.txt
python3 -m cProfile LV3.py | head -1 >> ../Results/profiling.txt
echo 'Profiling for LV4.py :' >> ../Results/profiling.txt
python3 -m cProfile LV4.py | head -1 >> ../Results/profiling.txt

#Print results to screen
cat ../Results/profiling.txt

#We can select a more discrete time vector so that there are less integration
#steps. The answer will be qualitatively equal, except for it will be a bit
#less precise.

