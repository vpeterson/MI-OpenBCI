function [ TrialsEMGfilter ] = EnvelopeEMG( TrialsEMG, fc )
%FILTEREMG Summary of this function goes here
%   Detailed explanation goes here

TrialsEMG.x=TrialsEMG.x-mean(TrialsEMG.x); % le quitamos la media
TrialsEMGrect=abs(TrialsEMG.x); % rectificamos
[z,p,k]=butter(4, fc/(TrialsEMG.s/2)); %filtro pasa-bajo
[sos,g]=zp2sos(z,p,k);
TrialsEMGfilter.x=filtfilt(sos,g,TrialsEMGrect);
TrialsEMGfilter.s=TrialsEMG.s;

end

