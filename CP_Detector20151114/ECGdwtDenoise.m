function  sigout=ECGdwtDenoise(signal,lowSuppress_level,H_Thres)
    %% Use DWT to denoise ECG
    if nargin ==2
        H_Thres = 9;
    end
    
    low_thres=lowSuppress_level;% 最低分解级：对应最高频段 ,取值范围[1,high_thres]
    high_thres=H_Thres;%% 最高分解级：对应最低频段 取值范围>1
    
    dwtcA=[];
    dwtcD=[];
    cA=signal;
    for ind=1:high_thres
        [cA,cD]=dwt(cA,'coif2');
        if ind<=low_thres
            cD=zeros(size(cD));
        end
        if ind==high_thres
            cA=zeros(size(cA));
        end
        dwtcA(ind).sig=cA;
        dwtcD(ind).sig=cD;
    end
    %% idwt
    sigout=dwtcA(high_thres).sig;
    for ind=high_thres:-1:1

        lc=size(sigout,1);
        ld=size(dwtcD(ind).sig,1);
        sig_cD=dwtcD(ind).sig;
        if lc>ld
            sig_cD(end+1:end+lc-ld)=zeros(lc-ld,1);
        elseif lc<ld
            sigout(end+1:end+ld-lc)=zeros(ld-lc,1);
        end
        
        sigout=idwt(sigout,sig_cD,'coif2');
    end
    
end