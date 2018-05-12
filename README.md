# FBSegm

### N.B.: Code is not properly commented yet. I'm improiving comments/variable names and working on an essential documentation.

This code has been used in this work: https://www.biorxiv.org/content/early/2017/06/26/109496

Honestly, the code was intended to be understood just by me and by a couple of other people (i.e., myself and I) and to work on my workstation, with my path, my OS (Ubuntu 17.04) and with my MATLAB version (r2017a). However, I was asked to share it, and since it has been used to work on public data, this seemed a reasonable request. Of note, the paper underwent several round of revision and all the pipeline has changed several times, I've just uploaded the last one. Thus, I'm working a bit to let this stuff being comprehensible by other human beings (or bots, there is no captcha here, so feel free). Still, there is no guarantee that the code will work on different OS or Matlab version. For any problem, issue or bug, just write me (paolo.papale [at] imtlucca.it). 

**1. There are some preliminary steps that you should do before getting this working.** 

The most important of all: get the fMRI data. You should create an account on https://crcns.org/; then download the vim-1 dataset; unzip everything and put it in the folder with the code.

Then, you should download the computational models and place them in your path. For the Dense SIFT I've used the VLfeat implementation. You should go here (http://www.vlfeat.org/install-matlab.html) and follow the instructions. For the GIST, the code is provided here: http://people.csail.mit.edu/torralba/code/spatialenvelope/. For the PHOG, download the code here (http://www.robots.ox.ac.uk/~vgg/research/caltech/phog.html). For the LBP, get this function https://github.com/adikhosla/feature-extraction/blob/master/features/lbp/lbp.m.

Finally, be sure to add to your path the following things. I've used a couple of functions by Kendrick Kay, so, place this repository (github.com/kendrickkay/knkutils) in your path. [In progress]

**2. What to do next** 

1. Build the RDMs by running ...
2. Download the Berk_stimuli.mat from here: https://osf.io/zrctd/?view_only=d2d7edf8cfde438da8868a1a6d6c0870 and place it in the main folder with the data
3. Wait for new instructions [In progress]



**If you use any of these stuff in a publication, be aware of the following:**

If you use the code or the method, you should cite the work mentioned at the beginning.
If you use the fMRI data or the stimuli, you should cite: 
If you use the models, you should cite:

If you use the segmentations, cite both the fMRI works and the work mentioned at the beginning.
