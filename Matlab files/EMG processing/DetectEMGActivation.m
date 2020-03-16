%% Detect EMG activation 

% This function provides the EMG analysis for detectiong EEG corrupted via 
% EMG activity. Note that here we considered data from 11 subjects. After
% this analysis we dismissed EEG data of subject S13 given the highly
% number of EEG trials contaminated by EMG activity [1].

% References
%   -------
% [1] V. Peterson, C.M. Galván, H.S.U. Hernández and R.D. Spies. A feasibility study of a complete low-cost consumer-grade brain-computer interface system,
%Heliyon, 6(3), 2020.
%%
clearvars
close all
clc;

% uncomment and change this line
% address='YOUR\ADDRESS\';

optEMG.window=5; %due to manual syncronization, we took 0.5 sec more in each tail of the window
optEMG.offset=0.5;

subjects={'S02','S03','S04','S05','S06','S07','S08', 'S09', 'S10', 'S12', 'S13'};

nSubjects=length(subjects);
runs=1:4;
sessions=1;
Rest_begin=10.2;
opt.fc=10;
opt.order=5;
%% 
for s=1:nSubjects
    for ss=1:length(sessions)
        for r=1:4
            
            %% FILTER DATA 
            [DataEMG_filt, DataEMG]=filterRawEMG(address,subjects{s}, runs(r), opt);
            %% Extract EMG Rest 
            RestEMG=ExtractRestEMG(address,subjects{s}, Rest_begin, opt);
            %% Envelope
            DataEMGenv=EnvelopeEMG(DataEMG_filt,40);
            RestEMGenv=EnvelopeEMG(RestEMG,40);
           
            %% Extract trials
            [epochEMG]=ExtractTrialsEMG(address,subjects{s}, runs(r), DataEMGenv);
            [epochEMG_raw]=ExtractTrialsEMG(address,subjects{s}, runs(r), DataEMG_filt);
            %% rename
            epochEMGn=epochEMG;
            RestEMGn=RestEMGenv;

            %% Detect corrupted EMG trials 
            EMGLabel= EMGdetect(epochEMGn,RestEMGn);
            EMGnumber1=sum(EMGLabel(:,1));
            EMGnumber2=sum(EMGLabel(:,2));
            EMGnumber=sum(EMGLabel(:,1)|EMGLabel(:,2));
            disp([ subjects{s} ' S' int2str(sessions(ss)) ' R' int2str(runs(r)) ': ' int2str(EMGnumber1) ' Trials corruptos canal 1']);
            disp([ subjects{s} ' S' int2str(sessions(ss)) ' R' int2str(runs(r)) ': ' int2str(EMGnumber2) ' Trials corruptos canal 2']);
        end
    end
end