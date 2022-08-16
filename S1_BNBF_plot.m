clc; clear variables; close all;

snravg_dB = -10:5:20;
load('BNBF.mat');
load('S1.mat');
load('S2.mat');
load('S3.mat');


figure
semilogy(snravg_dB,BNBF,'o-',...
    snravg_dB,S1,'*-', ...
    snravg_dB,S2,'x-', ...
    snravg_dB,S3,'s-')

xlabel('Transmit SNR (dB)')
ylabel('Outage Probability')
legend('BNBF','Scheme 1','Scheme 2','Scheme 3')
set(gca,'XTick',-10:5:20)

