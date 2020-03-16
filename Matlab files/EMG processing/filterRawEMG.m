function [DataEMGfilt, samplesEMG]=filterRawEMG(address,ID, run, opt)
in_EMG=[address '\EMG\' ID '\' ID '_S1R' int2str(run)];
load(in_EMG);

if ~exist('opt','var') || isempty(opt)
opt.order=5;
opt.fc=10;
end

%% nocht
Fs = samplingFreqEMG; Fo = 50;  Q = 35; BW = (Fo/(Fs/2))/Q;
[b,a] = iircomb(Fs/Fo,BW,'notch');  
% fvtool(b,a);

aux=filtfilt(b,a,samplesEMG);
% n=length(samplesEMG);
% range = (1:round(n/2))*(Fs/n);  
% fft_1=fftshift(abs(fft(aux(:,1))));
% plot(range, fft_1(round(n/2):end));
%%
% high-pass
[z,p,k]= butter(opt.order, opt.fc/(samplingFreqEMG/2), 'high');
[sos,g] = zp2sos(z,p,k);          % Convert to SOS form
% fvtool(sos);                % Plot magnitude response
% b= fir1(opt.order, opt.high/(samplingFreqEMG/2));
% fvtool(b,1);                % Plot magnitude response
% samplesEMGfilt=filtfilt(b,1,aux);
% 
samplesEMGfilt=filtfilt(sos,g,aux);
% figure();
% n=length(samplesEMG);
% range = (1:round(n/2))*(Fs/n);  
% fft_2=fftshift(abs(fft(samplesEMGfilt(:,1))));
% plot(range, fft_2(round(n/2):end));
DataEMGfilt.x=samplesEMGfilt;
DataEMGfilt.s=samplingFreqEMG;
end