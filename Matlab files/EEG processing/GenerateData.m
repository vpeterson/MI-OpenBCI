%% Generate Data from raw EEG records
% for running this demo, please uncomment and change the address
% this script is intended to convert the raw EEG files in data matrices.
% Per each subject, the output file is an EEG data struct in which the EEG
% trials are stored in EEG.x, the labels are saved in EEG.y, and the 
% sampling frequency as well as the channels name are saved in EEG.s and
% EEG.c, respectively. 
%
clearvars 
close all
clc


%% 
runs=1:4;
subjects={'S02','S03','S04','S05','S06','S07','S08', 'S09','S10', 'S12'};
nSubjects=length(subjects);
% address='YOUR\ADDRESS\';
%% dependencies
addpath(genpath('ov2mat')); %OpenViBe toolbox

%% convert files

for s=1:nSubjects
    for r=1:length( runs)
    disp(['Converting S' int2str(sessions(ss)) 'R' int2str(runs(r)) 'records'])
    in=[address subjects{s} '\' subjects{s} '_FILT_S' int2str(sessions(ss)) 'R' int2str(runs(r)) '.ov'];
    out=[address subjects{s} '\' subjects{s} '_FILT_S' int2str(sessions(ss)) 'R' int2str(runs(r)) '.mat'];

    convert_ov2mat(in, out)
    save(out) %save the .mat files for further usage
    end
clc
end
%% option setting
opt.window=4; %window length
opt.offset=0; % sec after visual cue
opt.downsamp=0; %if downsamp==0, then no downsampling, if downsamp~=0, then
                %the integrer is the downsampling number to be considered.

opt.channels='all'; %all, take all registered channels. If you want to use
                    %an specific channel count, indicate the names.
opt.filt=0; %no filtering

% for more information about the different configuration for the EEG signal
% processing, refer to 'ExtractTrialMI' documentation.
%%
for s=1:nSubjects
    disp(['Processing Data Subject' int2str(s)])
    EEG.x=[];
    EEG.y=[];

        for r=1:4
            out=[address subjects{s} '\' subjects{s} '_FILT_S' int2str(sessions(ss)) 'R' int2str(runs(r))];
            [EEGaux, elecIndex]=ExtractTrialsMI(out, opt, false); %PRE-PROCESSING, output: Data Matrix
            EEG.s=EEGaux.s;
            EEG.c=EEGaux.c;
            EEG.x=cat(3,EEG.x, EEGaux.x);
            EEG.y=cat(1,EEG.y, EEGaux.y);
        end
       DataEEG{s}=EEG; %a cell array for the whole dataset.
       

end

save('Data_openbci_4s', 'DataEEG')