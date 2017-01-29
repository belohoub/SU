############################################
########## LOAD DATA AND PACKAGES ##########
############################################

########## REQUIRMENTS ##########
#
########## INSTALL
# apt-get install liboctave-dev
# pkg install -forge io
#
########## DATA PATH
# LINUX : data = csv2cell('/home/dzejkob23/Documents/Git/SU/titanic.csv');
# WIN32 : data = csv2cell('D:\Git\SU\titanic.csv');
#
########## ADD SVM LIBRARY
# LINUX and WIN32 : type "make" in ./libsvm-3.22/matlab

function [data] = settings()

# Clean environment
clear ; close all; clc

# Load packages
pkg load io
pkg load statistics
pkg load control

# Path to LIBSVM
addpath './libsvm-3.22/matlab'

data = csv2cell('titanic.csv');

end