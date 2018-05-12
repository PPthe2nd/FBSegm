warning off
clear all
%addpath(genpath('/DATA/Lab/STRUMENTI/MATLAB/'));
%%%% Foreground

%%% contrast
clear all
load('Berk_stimuli.mat')
load('mask.mat')
load('index_all.mat')
load('RDMs_medio.mat')
landout_fore;
pause(10)

%%% low-pass
clear all
load('Berk_stimuli.mat')
load('RDMs_medio.mat')
load('mask.mat')
load('index_all.mat')
frequout_low_cntr_fore
pause(10)

% high-pass
clear all
load('Berk_stimuli.mat')
load('RDMs_medio.mat')
load('mask.mat')
load('index_all.mat')
frequout_high_cntr_fore
pause(10)

%%%% Background

%%% contrast
clear all
load('Berk_stimuli.mat')
load('mask.mat')
load('RDMs_medio.mat')
load('index_all.mat')
landout_back;

%%% low-pass
clear all
load('Berk_stimuli.mat')
load('RDMs_medio.mat')
load('mask.mat')
load('index_all.mat')
frequout_low_cntr_back
pause(10)

% high-pass
clear all
load('Berk_stimuli.mat')
load('RDMs_medio.mat')
load('mask.mat')
load('index_all.mat')
frequout_high_cntr_back
pause(10)

clear all