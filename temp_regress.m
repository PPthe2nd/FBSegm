clear all
warning off
%addpath(genpath('/DATA/Lab/STRUMENTI/MATLAB/'));
load('Berk_stimuli.mat')
load('mask.mat')
load('index_all.mat')
load('RDMs_medio.mat')
load('distro_nulla_Null_1000_snr_V1V2.mat', 'Null')    

param.imageSize = [256 256]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
bin_0 = 40;
angle = 360;
L=4;
roi = [1;300;1;300];

for f = 1:3
    tic
    parfor i = 1:334
        
        %clear eh name genny
        eh = index_all(i);
        name = strcat('stim',mat2str(eh));
        pippo = Shape.(name);
        genny = Berk.(name);
        %deh = genny.*(pippo);
        
        %clear bin_1 bin_masked Img_bin_1 Img_single_bin_1 p_bin_1 f_bin_1 d_bin_1 l_bin_1 g_bin_1
        
        if f == 1
            bin_1 = double(genny);%intact
        elseif f == 2
            bin_1 = double(genny.*(pippo)); %fore
        else
            bin_1 = double(genny.*(1-pippo)); %back
        end
        
        bin_masked = bin_1;
        
        Img_bin_1 = mat2gray(bin_masked);
        Img_single_bin_1 = single(vl_imdown(Img_bin_1));
        p_bin_1 = anna_phog(Img_bin_1,bin_0,angle,L,roi);
        [f_bin_1,d_bin_1] = vl_dsift(Img_single_bin_1,'size',78,'Fast');
        l_bin_1 = lbp(Img_bin_1);
        [g_bin_1] = LMgist(Img_bin_1, '', param);
        GIST_feat_bin_1(i,f,:) = g_bin_1;
        DSIFT_feat_bin_1(i,f,:) = d_bin_1(:)';
        PHOG_feat_bin_1(i,f,:) = p_bin_1;
        LBP_feat_bin_1(i,f,:) = l_bin_1;
        i
    end
    
    clear RDM_gist_corr_bin_1 RDM_phog_corr_bin_1 RDM_lbp_corr_bin_1 RDM_dsift_corr_bin_1 n_gist_corr_bin_1 n_lbp_corr_bin_1 n_phog_corr_bin_1 n_dsift_corr_bin_1 n_app_mean n_app_weight
    
    RDM_gist_corr_bin_1 = squareform(pdist(squeeze(GIST_feat_bin_1(:,f,:)),'correlation'));
    RDM_phog_corr_bin_1 = squareform(pdist(squeeze(PHOG_feat_bin_1(:,f,:)),'correlation'));
    RDM_lbp_corr_bin_1 = squareform(pdist(squeeze(LBP_feat_bin_1(:,f,:)),'correlation'));
    RDM_dsift_corr_bin_1 = squareform(pdist(squeeze(DSIFT_feat_bin_1(:,f,:)),'correlation'));
    
    n_gist_corr_bin_1 = (RDM_gist_corr_bin_1 - min2(RDM_gist_corr_bin_1))/(max2(RDM_gist_corr_bin_1) - min2(RDM_gist_corr_bin_1));
    n_lbp_corr_bin_1 = (RDM_lbp_corr_bin_1 - min2(RDM_lbp_corr_bin_1))/(max2(RDM_lbp_corr_bin_1) - min2(RDM_lbp_corr_bin_1));
    n_phog_corr_bin_1 = (RDM_phog_corr_bin_1 - min2(RDM_phog_corr_bin_1))/(max2(RDM_phog_corr_bin_1) - min2(RDM_phog_corr_bin_1));
    n_dsift_corr_bin_1 = (RDM_dsift_corr_bin_1 - min2(RDM_dsift_corr_bin_1))/(max2(RDM_dsift_corr_bin_1) - min2(RDM_dsift_corr_bin_1));
    
    n_app_weight = ([squareform(n_phog_corr_bin_1);squareform(n_gist_corr_bin_1);squareform(n_lbp_corr_bin_1);squareform(n_dsift_corr_bin_1)]);
    %n_app_weight = n_app_weight-mean(n_app_weight);
    
    names = {'V1','V2','V3','V3A','V3B','V4','LOC'};
    rng(7)
    indices = crossvalind('KFold',55611);
    for cv = 1:5
        clear ind_perm ind_perm_ts y_temp
        ind_perm = (indices ~= cv);
        ind_perm_ts = (indices == cv);
        x_weigth = n_app_weight(:,ind_perm)';
        x_weigth = x_weigth-mean(x_weigth);
        x_weigth_ts = n_app_weight(:,ind_perm_ts)';
        x_weigth_ts = x_weigth_ts-mean(x_weigth_ts);
        for roi = 1:7
            clear name_temp y_temp y_brain y_brain_ts B STATS weight_cv
            name_temp = names{roi};
            y_temp = squareform(RDMs_medio.(name_temp))';
            y_brain = y_temp(ind_perm);
            y_brain = y_brain-mean(y_brain);
            y_brain_ts = y_temp(ind_perm_ts);
            y_brain_ts = y_brain_ts-mean(y_brain_ts);
            
            [B,~,~,~,STATS] = regress(y_brain,x_weigth);
            
            betas_weigth(cv,roi,:) = B;
            r2_weight(cv,roi) = STATS(1);
            
            weigth_cv = B'*x_weigth_ts';
            
            r_test_weigth(cv,roi) = corr(y_brain_ts,weigth_cv','type','Spearman');
        end
    end
    
    corrs_weigth{f} = r_test_weigth;
    betas_all{f} = betas_weigth;
    r2_all{f} = r2_weight;
    
    rng(7)
    for i = 1:1000
        boot_ind(i,:) = randi(11122,[1 11122]);
    end
    
    parfor z = 1:1000
        for cv = 1:5
            %clear ind_perm ind_perm_ts y_temp
            ind_perm = (indices ~= cv);
            ind_perm_ts = (indices == cv);
            x_weigth = n_app_weight(:,ind_perm)';
            x_weigth = x_weigth-mean(x_weigth);
            x_weigth_ts = n_app_weight(:,ind_perm_ts)';
            
            for roi = 1:7
                %clear boot_ind name_temp y_temp y_brain y_brain_ts B STATS weight_cv
                boot_temp = (boot_ind(z,:));
                name_temp = names{roi};
                y_temp = squareform(RDMs_medio.(name_temp))';
                y_brain = y_temp(ind_perm);
                y_brain = y_brain-mean(y_brain);
                y_brain_ts = y_temp(ind_perm_ts);
                
                B = regress(y_brain,x_weigth);
                
                betas_weigth_boot(z,cv,roi,:) = B;
                
                weigth_cv = B'*x_weigth_ts';
                
                r_boot_weigth(z,cv,roi) = corr(y_brain_ts(boot_temp),weigth_cv(boot_temp)','type','Spearman');
            end
        end
    end
    
    boots_weigth{f} = r_boot_weigth;
    boots_betas_all{f} = betas_weigth_boot;
    
    nperms = 1000;
    parfor z = 1:nperms
        for cv = 1:5
            %                 clear ind_perm ind_perm_ts y_temp
            ind_perm = (indices ~= cv);
            ind_perm_ts = (indices == cv);
            x_weigth = n_app_weight(:,ind_perm)';
            x_weigth = x_weigth-mean(x_weigth);
            x_weigth_ts = n_app_weight(:,ind_perm_ts)';
            for roi = 1:7
                name1 = names{roi};
                nullo = Null.(name1)(z,:);
                y_nullo = nullo(ind_perm)-mean(nullo(ind_perm));
                y_nullo_ts = nullo(ind_perm_ts);
                
                B = regress(y_nullo',x_weigth);
                
                betas_nette_perm(z,cv,roi,:) = B;
                weigth_cv = B'*x_weigth_ts';
                
                r_test_nette_perm(z,cv,roi) = corr(y_nullo_ts',weigth_cv','type','Spearman');
            end
        end
    end
    
    perms_weigth{f} = r_test_nette_perm;
    perms_betas_all{f} = betas_nette_perm;
    
    for roi = 1:7
        temp_perm = squeeze(mean(r_test_nette_perm,2));
        temp_perm_sort = squeeze(temp_perm(:,roi));
        temp_perm_sort = sort(temp_perm_sort);
        step_temp = squeeze(mean(r_test_weigth(:,roi)));
        if isempty(find(temp_perm_sort(temp_perm_sort >= step_temp))) == 1
            pvals_nette(f,roi) = 0;
        else
            p_temp = max(find(temp_perm_sort(temp_perm_sort >= step_temp)));
            pvals_nette(f,roi) = (1/nperms*p_temp);
        end
    end
    toc
end

save results_nette_regress_demean_boot_perm_retest.mat