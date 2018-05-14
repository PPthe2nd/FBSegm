# FBSegm

### N.B.: Code is not properly commented yet. I will improve comments/variable names and work on an essential documentation.

This code has been used in this work: https://www.biorxiv.org/content/early/2017/06/26/109496

Honestly, the code was intended to be understood just by me and by a couple of other people (i.e., myself and I) and to work on my workstation, with my path, my OS (Ubuntu 17.04) and with my MATLAB version (r2017a). However, I was asked to share it, and since it has been used to work on public data, this seemed a reasonable request. Note that the paper underwent several rounds of revision and all the pipeline has changed several times, I've just uploaded the last one. Thus, I'm working a bit to let this stuff being comprehensible by other human beings. Still, there is no guarantee that the code will work on a different OS or Matlab version. For any problem, issue or bug, just write me (paolo.papale [at] imtlucca.it). 

**There are some preliminary steps that you should do before getting this working.** 

The most important of all: get the fMRI data. You should create an account on https://crcns.org/; then download the vim-1 dataset; unzip everything and put it in the folder with the code.

Second, download the 'Berk_stimuli.mat', 'distro_nulla_Null_1000_snr_V1V2.mat' and 'Boot_rois_snr_1000_OK.mat' from here: https://osf.io/zrctd/?view_only=d2d7edf8cfde438da8868a1a6d6c0870 and place them in the main folder with the data. 

Then, you should download the computational models and place them in your path. For the Dense SIFT I've used the VLfeat implementation. You should go here (http://www.vlfeat.org/install-matlab.html) and follow the instructions. For the GIST, the code is provided here: http://people.csail.mit.edu/torralba/code/spatialenvelope/. For the PHOG, download the code here (http://www.robots.ox.ac.uk/~vgg/research/caltech/phog.html). For the LBP, get this function https://github.com/adikhosla/feature-extraction/blob/master/features/lbp/lbp.m.

Finally, be sure to add to your path the following things. I've used a couple of functions by Kendrick Kay, so, place this repository (github.com/kendrickkay/knkutils) in your path. I've also used the 'min2' and 'max2' functions by John D'Errico: https://it.mathworks.com/matlabcentral/fileexchange/22995-min2--max2

**What to do next** 

N.B. Detailed methods are described in the paper, for what is not clear from it or from this readme, feel free to write me.
N.B.B. Be aware that most of the following steps requires several hours with 6-8 CPUs (there are several parfor loops within the code, most of them start on the local profile, without further specifing the number of threads) and a lot of RAM (up to 64gb). The most intensive step (creation of ROI-specific null distros and bootstrapping) is not included since it would require days. I have uploaded the null distros and bootstrapped CIs instead - but write me for additional code/info. 

1. Build the RDMs by running 'script_rdm_kay2008.m'
2. Proceeding as in the paper, you may wanto to look at the correlations for the 3 versions (intact, foreground and background) by running 'temp_regress.m'.
3. Then, it's time for the annoying foreground enhancement permutation test: run 'permutation_SEGM.m' and have a nice weekend!
4. It's monday! So, you can produce the results and plots of Figure 4 by launching 'meta_script_filtering.m' and then 'temp_regress_filtering.m'. Consider that the latter will also compute significance and bootstrapped CIs. Significance and CIs are not needed for the correlation images, so if you are satisfied with the mean I have inserted a comment for you at the right point: open it, find my comment (it's the only one in english) and comment what comes after (but the last line). 
5. Since you have arrived here, you would like to see some segmented giraffe here and there - as in Figure 5. 'neural_images.m' is made for you, enjoy!
6. Cite the paper, because "tengo famiglia!!" (cit. "I have a family!!") 

**References** 

Code: 
* Papale et al., 2017. Foreground-background segmentation revealed during natural image viewing, bioRxiv.

fMRI data and stimuli: 
* Kay, et al., 2008. Identifying natural images from human brain activity. Nature, 452(7185), 352-355.
* Naselaris, et al., 2009. Bayesian reconstruction of natural images from human brain activity. Neuron, 63(6), 902-915.
* Kay, Naselaris, & Gallant, 2011. fMRI of human visual areas in response to natural images. CRCNS.org.

Berkeley Segmentation Dataset: 
* Arbelaez et al., 2011. Contour detection and hierarchical image segmentation. IEEE Trans Pattern Anal Mach Intell. 33: 898-916.

Computational models:
* Gist: Oliva A, Torralba A. 2001. Modeling the shape of the scene: A holistic representation of the spatial envelope. International journal of computer vision. 42: 145-175.
* Dense SIFT: Lazebnik S, Schmid C, Ponce J. 2006. Beyond bags of features: Spatial pyramid matching for recognizing natural scene categories. In: IEEE. p 2169-2178.
* LBP: Ojala T, Pietikäinen M, Mäenpää T. 2001. A generalized local binary pattern operator for multiresolution gray scale and rotation invariant texture classification. In: Springer. p 399-408.
* PHOG: Bosch A, Zisserman A, Munoz X. 2007. Representing shape with a spatial pyramid kernel. In: ACM. p 401-408.

If you use this code or some of the material in a publication, cite the relative references.
