param.imageSize = [256 256]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
bin_0 = 40;
angle = 360;
L=4;
roi = [1;300;1;300];

ranges = linspace(0.01,1,6);

parfor i = 1:334
    %clear eh name genny 
    eh = index_all(i);
    name = strcat('stim',mat2str(eh));
    pippo = Shape.(name);
    genny = Berk.(name);
    deh = genny.*(1-pippo);
    
    for j = 1:6
            
        %clear bin_1 Img_bin_1 Img_single_bin_1 p_bin_1 f_bin_1 d_bin_1 l_bin_1 g_bin_1 

        bin_1 = double(pippo);
        bin_1(bin_1 == 1) = ranges(j);
        bin_masked = bin_1.*genny+deh;
        
        Img_bin_1 = mat2gray(bin_masked);
        Img_single_bin_1 = single(vl_imdown(Img_bin_1));
        p_bin_1 = anna_phog(Img_bin_1,bin_0,angle,L,roi);
        [f_bin_1,d_bin_1] = vl_dsift(Img_single_bin_1,'size',78,'Fast');
        l_bin_1 = lbp(Img_bin_1);
        [g_bin_1] = LMgist(Img_bin_1, '', param);
        GIST_feat_bin_1(i,j,:) = g_bin_1;
        DSIFT_feat_bin_1(i,j,:) = d_bin_1(:)';
        PHOG_feat_bin_1(i,j,:) = p_bin_1;
        LBP_feat_bin_1(i,j,:) = l_bin_1;
    end
    i
end

for i = 1:6

    clear RDM_gist_corr_bin_1 RDM_phog_corr_bin_1 RDM_lbp_corr_bin_1 RDM_dsift_corr_bin_1 n_gist_corr_bin_1 n_lbp_corr_bin_1 n_phog_corr_bin_1 n_dsift_corr_bin_1 n_app_corr_bin_1 rsa_app_feat_pearson_bin_1
    
    RDM_gist_corr_bin_1 = squareform(pdist(squeeze(GIST_feat_bin_1(:,i,:)),'correlation'));
    RDM_phog_corr_bin_1 = squareform(pdist(squeeze(PHOG_feat_bin_1(:,i,:)),'correlation'));
    RDM_lbp_corr_bin_1 = squareform(pdist(squeeze(LBP_feat_bin_1(:,i,:)),'correlation'));
    RDM_dsift_corr_bin_1 = squareform(pdist(squeeze(DSIFT_feat_bin_1(:,i,:)),'correlation'));

    n_gist_corr_bin_1 = (RDM_gist_corr_bin_1 - min2(RDM_gist_corr_bin_1))/(max2(RDM_gist_corr_bin_1) - min2(RDM_gist_corr_bin_1));
    n_lbp_corr_bin_1 = (RDM_lbp_corr_bin_1 - min2(RDM_lbp_corr_bin_1))/(max2(RDM_lbp_corr_bin_1) - min2(RDM_lbp_corr_bin_1));
    n_phog_corr_bin_1 = (RDM_phog_corr_bin_1 - min2(RDM_phog_corr_bin_1))/(max2(RDM_phog_corr_bin_1) - min2(RDM_phog_corr_bin_1));
    n_dsift_corr_bin_1 = (RDM_dsift_corr_bin_1 - min2(RDM_dsift_corr_bin_1))/(max2(RDM_dsift_corr_bin_1) - min2(RDM_dsift_corr_bin_1));

    n_app_corr_bin_1 = ([squareform(n_phog_corr_bin_1);squareform(n_gist_corr_bin_1);squareform(n_lbp_corr_bin_1);squareform(n_dsift_corr_bin_1)]);

    feats_cntr_fore{i} = n_app_corr_bin_1;
    
end

save('feats_cntr_fore','feats_cntr_fore');

clear all