param.imageSize = [256 256]; % it works also with non-square images
param.orientationsPerScale = [8 8 8 8];
param.numberBlocks = 4;
param.fc_prefilt = 4;
bin_0 = 40;
angle = 360;
L=4;
roi = [1;300;1;300];
ranges = logspace(0.0043,2.698,6);


parfor i = 1:334
    tic
%     clear eh name pippo genny bin_1 deh rsm_orig amin amax
    
    eh = index_all(i);
    name = strcat('stim',mat2str(eh));
    pippo = Shape.(name);
    genny = Berk.(name);
    bin_1 = pippo; % 1- pippo = masking foreground
    deh = genny.*(1-pippo);
    rsm_orig = sqrt(sum(genny(:).^2));
    amin = double(min2(genny));
    amax = double(max2(genny));

    for j = 1:6
            
%         clear b bin_masked rsm_new rsm_fin Img_bin_1 Img_single_bin_1 p_bin_1 f_bin_1 d_bin_1 l_bin_1 g_bin_1 
        
        b = imagefilter(genny,constructbutterfilter(500, [0.01 ranges(j)],5)); % [1 ranges(j)] = add high freq; [ranges(j) 500] = add low freq
        bin_masked = b.*bin_1+deh;
        rsm_new = sqrt(sum(bin_masked(:).^2));
        rsm_fin = rsm_orig/rsm_new;
        bin_masked = bin_masked.*rsm_fin;
        
        Img_bin_1 = mat2gray(bin_masked, [amin amax]);
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
    toc
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

    feats_low_fore{i} = n_app_corr_bin_1;
    
end

save('feats_low_fore','feats_low_fore');

clear all