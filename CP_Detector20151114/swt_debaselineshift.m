%% test denoise
% remove baselineshift
function denoised_sig=swt_debaselineshift(sig)

    % swt remove noise
    
    level=7;
    Lo_D=1/8.*[1 3 3 1];
    Hi_D=2.*[0 1 -1 0];
    % swt
%     swc = swt(sig,level,Lo_D,Hi_D);
    swc = swt(sig,level,'coif2');
    swc(level+1,:)=zeros([1,length(swc)]);
%     dsig=iswt(swc,Lo_D,Hi_D);
    denoised_sig=iswt(swc,'coif2');
    
%     plot(sig);
%     hold on;
%     plot(dsig);
%     legend('original','denoised');
 

end
