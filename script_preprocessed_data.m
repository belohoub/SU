# NACTENI POTREBNYCH BALICKU
# apt-get install liboctave-dev
# pkg install -forge io
pkg load io

# LOAD PREPROCESSED DATA titanic_preprocessing_2.csv FROM titanic.csv
# !!!CHECK CORECT PATH!!!
data = csv2cell('/home/dzejkob23/Documents/SU/titanic_preprocessing_final.csv');

# GET ANSWERS FROM SUPERSVISOR
supervisor = data(:,1);

# DROP SUPERVISOR ANSWERS FROM DATA AND CREATE TRAINING SET
training_set = data(:, 2:10)


toascii('nazdar')
for i = ans
polozka = polozka + i
endfor