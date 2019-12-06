touch ../Results/vectorize_comp.txt
touch ../Results/temp.txt

echo -e '\n' > ../Results/vectorize_comp.txt
python3 Vectorize1.py >> ../Results/vectorize_comp.txt
python3 Vectorize2.py >> ../Results/vectorize_comp.txt
Rscript Vectorize1.R >> ../Results/vectorize_comp.txt
Rscript Vectorize2.R >> ../Results/vectorize_comp.txt
echo -e '\n' >> ../Results/vectorize_comp.txt

echo -e "Comparison between the scripts\n"
cat ../Results/vectorize_comp.txt

touch ../Results/comments.txt
echo "Python scripts are faster than R scripts" > ../Results/comments.txt
echo "when vectorized. However, they are slower" >> ../Results/comments.txt
echo "than R scripts when non-vectorized" >> ../Results/comments.txt 

cat ../Results/comments.txt 

