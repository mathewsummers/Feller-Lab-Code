%%%%% expRetina
% general data on experimental conditions, contains neurons and stims

%%%%% expNeuron
% ID'd neurons containing stims and that neuron's corresponding data

%%%%% expStim
%%% expStim > [expFlash, expBars]
% stim parameters and acquisition number, specific subclasses for different
% stims. Proccesses and plots stim specific experiments.

%%%%% expData
%%% expData > expSpikes 
% recording parameters, processed data, transiently holds raw data.
% Exectues plotting and processing functions through wrapper functions to
% stim objects.