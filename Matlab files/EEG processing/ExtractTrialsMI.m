function [DataEEG, elecIndex]=ExtractTrialsMI(archive, opt, verbose)
%--------------------------------------------------------------------------
%Extract EEG trials from the data that have been converted from ov to mat. 
% for MI. We are using only two type of codes:
% 770-rigth hand (MI)
% 772-tonge (REST)

%outputs:
%data: a N x C x M matrix, where M is the number of observations (trials,
%epochs), N is the number of samples and C is the number of channels. 
%label: a M x 1 vector containing class labels. 1=MI, 2=REST. 

%inputs:
%archive: string. Name (if needed, with the direction) of the archive where the
%data in mat format is located. 
%opt: struct containing the options for the pre-processing steps. 
%If opt is empty or is not given then the default options are used:

%opt.filt.make=1; 1=do Butterworth filter, 0=do not filter, raw data
%opt.filt.cof=[0.1 12]; low and high cutoff frequencies
%opt.filt.order=2; order of the desired filter 
%(the final filter order is twice the opt.filt.order see 'help butter'). 
%opt.norm=0; 1=zscore normalization and windzoring, 0=raw data
%opt.window=1; Duration Time in seconds of the EEG trials
%(they are extrated from the begining of the intecification). 
%opt.downsamp=1; 1=no downsampling. It have to be any divider of sampleFreq.



%Victoria Peterson
%August 2017 . 
%--------------------------------------------------------------------------
if nargin < 3
    verbose=true;
end
if ~exist('opt','var') || isempty(opt)
    opt.window=2; 
    opt.offset=0.5;
    opt.downsamp=0;
    opt.channels='all';
end

load(archive)


%---Select channels
if strcmp(opt.channels, 'all')
    if verbose
        disp('all channels are going to be used...')
    end
    signals=samples; 
    FinalChNames=cellstr(channelNames);
    elecIndex=ones(size(channelNames));


else
    if verbose;    disp('Selecting desired channels...'); end
    elecIndex = ismember(cellstr(channelNames),opt.channels)'; 
    channelNames=channelNames(elecIndex);
    FinalChNames=cellstr(channelNames);
    signals=samples(:, elecIndex);
end

if opt.filt==1

    [b,a]=butter(5, [1 40]./(samplingFreq/2) );
    signals=filtfilt(b,a,signals);
end




%----Epoching---
if verbose; disp('Inicializating epoching...'); end

target_ind=stims(:,2)==770;
nontarget_ind=stims(:,2)==772;
ind=logical(target_ind+nontarget_ind);
CantTrials=sum(ind);

startIdx =round((stims(ind,1) +opt.offset)* samplingFreq);
stopIdx = startIdx + round(opt.window * samplingFreq);

%.----Label epochs
label=double(ind);
label(nontarget_ind)=2;
label(target_ind)=1;
label=label(label~=0);

for i=1:CantTrials
    epoch=signals(startIdx(i):stopIdx(i),:);

    %-----Downsampling----
    if opt.downsamp==1
        if verbose; disp('decimation is being done'); end
        if mod(samplingFreq, opt.downsamp) ~=0
            error('Decimation factor need to be a factor of the samplig frequency');
        end
        aux=downsample(epoch(:), opt.downsamp);
        epoch=reshape(aux, (vf-vi)/opt.downsamp,CantChannels); 
       
          
    end
     data(:,:,i)=epoch;

    
DataEEG.x = data;
DataEEG.c = FinalChNames;
DataEEG.s=samplingFreq;
DataEEG.y=label;
end
if verbose; disp('Done')  ; end 
end
