%% Convert EMG txt files into matlab files

clearvars
close all
clc

%%

%uncomment and change the address
%address='YOUR\ADDRESS\';

subjects={'S02','S03','S04','S05','S06','S07','S08', 'S09','S10', 'S12', 'S13'};

nSubjects=length(subjects);

runs={'EST','0','1','2','3','4'};
sessions=1;

for s=1:nSubjects
    for ss=1:length(sessions)
        for r=1:length( runs)
            data=load([address subjects{s} '\OpenBCI-RAW-' subjects{s} '_S1R' runs{r} '.txt']);
            disp(['Converting ' subjects{s} ' S' int2str(sessions(ss)) ' R' runs{r} ' records'])
            
            samplingFreqEMG=200;
            samplesEMG=data(:,2:3);
            sampleTimeEMG=(0:1/samplingFreqEMG:length(samplesEMG)/samplingFreqEMG-1/samplingFreqEMG)';
            
            out=[address subjects{s} '\' subjects{s} '_S' int2str(sessions(ss)) 'R' runs{r} '.mat'];
            save(out, 'samplingFreqEMG', 'samplesEMG', 'sampleTimeEMG');
        end
    end
end

