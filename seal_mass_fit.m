clear
clc
close all

data = readmatrix('seals_data.txt');
d = data(:,3)/39.37;
m = data(:,4)/2.205;
f = fit(d, m, 'power1')
plot(f, d, m)
