function [EMGLabel] = EMGdetect(DataEMG,RestEMG)
    
         
     [Nsamples, ~, Ntrials]=size(DataEMG.x);
     Window=0.05; %Duración temporal de la ventana
     EMGLabel=zeros(Ntrials,2);
     stdRest=std(RestEMG.x);
     T=floor(Nsamples)/(Window*DataEMG.s);
     
     for i=1:Ntrials
         EMGnumber1=0;
         EMGnumber2=0;
     for t=1:T %windows
         rango=round((t-1)*Window*DataEMG.s+1):round((t-1)*Window*DataEMG.s+Window*DataEMG.s);
         if mean(DataEMG.x(rango,1,i))>5*stdRest(1)
                 EMGnumber1=EMGnumber1+1;
         end
         if mean(DataEMG.x(rango,2,i))>5*stdRest(2)
                 EMGnumber2=EMGnumber2+1;
         end
     end
     
%          if EMGnumber1>12 || EMGnumber2>12
%             EMGLabel(i)=1;
%          end
         if sum(EMGnumber1)>50
             EMGLabel(i,1)=1;
         end
         if sum(EMGnumber2)>50
            EMGLabel(i,2)=1;
         end
     end
         
end

