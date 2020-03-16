function [RestEMG]=ExtractRestEMG(address,ID, begin, opt)

% in=[address '\EMG\' ID '\' ID '_S1R' int2str(run)];
%in=[address '\EMG\' ID '\' ID '_S1REST'];
in=[address '\EMG\' ID '\' ID '_S1R0'];
load(in);

% Ancho de la ventana de inactividad
Window=0.25;

% Índices de comienzo de señal de EMG a considerar
startIdx=round(begin*samplingFreqEMG);
stopIdx=round((begin+Window)*samplingFreqEMG);

%% filtering
%% nocht
Fs = samplingFreqEMG; Fo = 50;  Q = 35; BW = (Fo/(Fs/2))/Q;
[b,a] = iircomb(Fs/Fo,BW,'notch');  
samplesEMGfilt=filtfilt(b,a,samplesEMG);

%% high pass
[z,p,k]= butter(opt.order, opt.fc/(samplingFreqEMG/2), 'high');
[sos,g] = zp2sos(z,p,k);          % Convert to SOS form
samplesEMGfilt=filtfilt(sos,g,samplesEMGfilt);
%%

samplesEMGfilt=samplesEMGfilt(startIdx:stopIdx-1,:);
RestEMG.x=samplesEMGfilt;
RestEMG.s=samplingFreqEMG;
end
