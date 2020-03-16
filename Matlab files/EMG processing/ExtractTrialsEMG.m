function [epochEMG]=ExtractTrialsEMG(address,ID, run, DataEMG,opt)
% cargamos los datos de EEG para sincronizar los segmentos de EMG
in_EEG=[address '\EEG\' ID '\' ID '_FILT_S1R' int2str(run)];
load(in_EEG);


target_ind=stims(:,2)==770;
nontarget_ind=stims(:,2)==772;
ind=logical(target_ind+nontarget_ind);
CantTrials=sum(ind);

%%
%.----Label epochs
label=double(ind);
label(nontarget_ind)=2;
label(target_ind)=1;
label=label(label~=0);
%%
if ~exist('opt','var') || isempty(opt)
    opt.window=5; 
    opt.offset=0.5;
    
end
samplingFreqEMG=DataEMG.s;
% Índices de comienzo y fin de trials de EMG
startIdx=round((stims(ind,1)-opt.offset)*samplingFreqEMG);
stopIdx=startIdx+round((opt.window)*samplingFreqEMG);
samplesEMG=DataEMG.x;
for i=1:CantTrials
    if stopIdx(i)<length(samplesEMG)
        epoch=samplesEMG(startIdx(i):stopIdx(i)-1,:);
        data(:,:,i)=epoch;
    end
end

epochEMG.x=data;
epochEMG.s=samplingFreqEMG;
epochEMG.y=label;


end 



