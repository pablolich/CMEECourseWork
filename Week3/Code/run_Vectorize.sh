touch ../Results/vectorize_comp.txt
touch ../Results/temp.txt

echo -e '\n' > ../Results/vectorize_comp.txt
python3 Vectorize1.py >> ../Results/vectorize_comp.txt
python3 Vectorize2.py >> ../Results/vectorize_comp.txt
Rscript Vectorize1.R >> ../Results/vectorize_comp.txt
Rscript Vectorize2.R >> ../Results/vectorize_comp.txt
echo -e '\n' >> ../Results/vectorize_comp.txt

