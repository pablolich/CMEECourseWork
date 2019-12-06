#!/bin/bash 

#Runs both LV1.py and LV2.py
touch file1.txt file2.txt file3.txt file4.txt

echo 'Profiling for LV1.py :' > ../Results/profiling.txt
python3 -m cProfile LV1.py >> file1.txt && 
    sed '1q;d' file1.txt >> ../Results/profiling.txt
echo 'Profiling for LV2.py :' >> ../Results/profiling.txt
python3 -m cProfile LV2.py >> file2.txt && 
    sed '4q;d' file2.txt >> ../Results/profiling.txt 
echo 'Profiling for LV3.py :' >> ../Results/profiling.txt
python3 -m cProfile LV3.py >> file3.txt && 
    sed '1q;d' file3.txt >> ../Results/profiling.txt
echo 'Profiling for LV4.py :' >> ../Results/profiling.txt
python3 -m cProfile LV4.py >> file4.txt && 
    sed '1q;d' file4.txt >> ../Results/profiling.txt

rm file1.txt file2.txt file3.txt file4.txt

#Print results to screen
cat ../Results/profiling.txt

#We can select a more discrete time vector so that there are less integration
#steps. The answer will be qualitatively equal, except for it will be a bit
#less precise.

