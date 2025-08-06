# NHP-TemplateScripts
This package performs a registration of the NIH Macaque Template (NMT) brain to the structural MRI scan of an individual monkey (and the other way around). It will also automatically co-register detailed cortical and subcortical atlases (i.e. CHARM and SARM) and a broad range of additional information (optional), containing probablistic DTI and retinotopic information (visual cortex and LGN).

<br>

Basic registrations require:
- `AFNI` [https://afni.nimh.nih.gov/](https://afni.nimh.nih.gov/)    
- The template package: [NMTv2.0](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html)

After downloading the NMT we suggest saving it in the following file structure on your local PC or network:    
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym` and `<where-you-want>/NMT_v2.0/NMT_v2.0_asym` 

<br>

Download this package of scripts and save it wherever you want. The scripts should be aware of their relative positions and function at any location as long as the package structure is intact. The bulk of the work is done by the `ssreg_*.sh` scripts (see below) but the `Batch` folder also contain scripts to configure multiple procedures for multiple individuals. 


### Parallel Processing    
The default is to run these scripts serially (i.e. one by one). If you want to do things in parallel, you have several options. First, you can simply run multiple instances at the same time without waiting for them to finish. 
Second, you can explicitly run things in parallel from the batch script. There are example batch scripts that have such parallel processing implemented (they have *parallel* in the file name). Do note that non-linear registration in particular can take quite some computational resources, and the `3dQwarp` used by `@animal_warper` already implements parallel processing so be careful when initiating several instances of this at once, as this may actually slow things down. One instance of `@animal_warper` can take 12-16 cores, if you have more available, you can run several parallel instances, but we suggest not going higher then ncores/12.

<br>

## Step 1: Prepare the individual scan    
If you have a T1 or T2 scan of reasonable quality (the procedure is pretty forgiving). You will first need to make sure the orientation is (roughly) correct and the image cropped around the head with not too much empty space. Use your favorite tools to do this, our methods tend to involve:    

<br>

- `dcm2niix` to convert DICOM files to nifti. Get it at [NITRC](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage)
- `Freesurfer`'s `mri_convert` takes a `--sphinx` flag to correct for animals in a sphinx orientation 
in a human scanner. See the [documentation](https://surfer.nmr.mgh.harvard.edu/fswiki/mri_convert)

<br>


- [Reorient](https://neuroanatomy.github.io/reorient/) is a nice web tool to quickly rotate, translate, 
and crop nifti files to approximate APCP orientation. This works best for subsequent steps. (see screenshot below)

![Reorient](images/reorient.png)

<br>

- You can also open and check nifti files in your favourite viewer (Such as [FSLeyes](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/FSLeyes) or [Freeview](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall))

<br>

<details>
<summary>Example code averaging over multiple volumes (T1s or T2s)</summary>
<pre>$ When acquiring several volumes in the same space (i.e. several T1s during an anaesthetized session), you can take the mean of these volumes.
$ Here is some example code using FSL functions (subject = 'Aapie', and we have three T1 scans in the same space): <br>
fslmaths Aapie_T1_run1.nii.gz -add Aapie_T1_run2.nii.gz Aapie_temp.nii.gz
fslmaths Aapie_temp.nii.gz -add Aapie_T1_run3.nii.gz Aapie_temp2.nii.gz
fslmaths Aapie_temp2.nii.gz -div 3 Aapie.nii.gz
rm Aapie_temp*.nii.gz  
</pre>
</details>

<details>
<summary>Example code using mri_convert to reorient a volume</summary>
<pre>$ Reorientation of a scan acquired in the sphynx position that the monkey is in
$ RAS refers to the coordinate system (dimension 1: right,dimension 2: anterior,dimension 3: superior)
mri_convert -i Aapie.nii.gz -o Aapie_RAS.nii.gz --sphinx
</pre>
</details>

<br>
[20250101] Currently, I tend to put the single-subject data in ACPC orientation using Slicer before continuing with this pipeline. It puts the native space in somewhat of a standard orientation which increases compatibility with other software packages. Instructions on how to do this still need to be written.    

After doing this create a `SingleSubjects` folder in the NMT folder you intend to use, e.g. `<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects`. Within this folder, make an input folder 
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files` where you copy the roughly correctly oriented and cropped nifti file of your individual as `SubjectName.nii.gz`. The scripts will assume that the entire filename (without the `.nii.gz` extension) is the subject name and will treat it as such. Once this is all set up, you're all set to run the scripts below! 

<br>

## Step 2: Put the individual in the same spatial location as the template     
The first processing step is `ssreg_prep.sh`. It takes one obligatory argument `subject`, and a number of optional positional arguments.

`ssreg_prep.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`

Defaults for the positional arguments can be set in the script. For us, they are:

`template folder` /NHP_MRI/Template    
`NMT version` NMT_v2.0    
`NMT type` NMT_v2.0_sym    
`NMT subtype` NMT_v2.0_sym 

<details>
<summary>Example code with our default positional arguments</summary>
<pre>$ Positional arguments at the Netherlands Institute for Neuroscience (path is obviously different at other institutes); example subject = 'Aapie'
bash ssreg_prep.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym <br>
$ Make sure you run this bash script from the reg_scripts folder or add the path when running it from someplace else 
</pre>
</details>

This script centers the individual scan on the center of the template and saves the original file and the applied transform. Further scripts will work with the recentered individual. 

<br>

## Step 3: Co-register the individual and template    
`ssreg_NMTv2.sh` is the main script registering the individual to the template and following segmentations and atlases. It uses `AFNI`'s `@animal_warper` function and it applies both affine and nonlinear registrations. It works with both T1w and T2w scans, but there are differences! While the whole thing pretty much works out of the box for T1w the nonlinear registration results vary a  bit for T2w (the default is T1w). Often, it just works to change the cost function (`lpc` instead of `lpa`). <br>

Sometimes you need a workaround however for T1w or T2w scans; for example when they suffer from high-drop out (e.g. because of an implant). If this isn't the case for your scans, you can ignore the following procedue (that seems to work well though). After affine registration, T2w images get altered so that their contrast is T1w-like. These images are then nonlinearly registered to the template and the resulting warp can be applied to unaltered images as well. <br> <br> There are three obligatory arguments for the following function to work:

- `subject` is again the subject name    
- `cost` defines the cost function used for registration. For T1w images use `lpa`, for T2w images use `lpc`. See `AFNI` documentation for more info.   
- `regtype` defines whether we will only do rigid (`rigid`) or affine registration (`affine`), or affine and nonlinear (`all`). We typically use `all` but when there are large dropouts in the individual scan it is pointless to try nonlinear options and you save a lot of time by just doing `affine`.

  <br>

To run this script, use the following positional arguments:
`ssreg_NMTv2.sh subject cost regtype [template folder path] [NMT version] [NMT type] [NMT subtype]`

<details>
<summary>Example code for a T1w scan with our default positional arguments</summary>
<pre>$ Example of running the ssreg_NMTv2.sh script for a T1w scan on the command line
$ subject = 'Aapie', cost function = 'lpa', registration type = 'all'
bash ssreg_NMTv2.sh Aapie lpa all /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym <br>
</pre>
</details>

<details>
<summary>Example code for a T2w scan with our default positional arguments</summary>
<pre>$ Example of running the ssreg_NMTv2.sh script for a T1w scan on the command line
$ When using the T2 as the default (for example when there is no T1 or it has better quality), treat the scan like a different 'subject'
$ subject = 'Aapie_T2' cost function = 'lpc', registration type = 'all'
bash ssreg_NMTv2.sh Aapie_T2 lpc all /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym <br>
</pre>
</details>

<br>

The workaround registration of T2w images with the fix is slightly more complex. 
- First do an affine registration with `ssreg_NMTv2`      
- Then run the `ss_T2w_imitates_T1w.sh` script to mimic the T1w contrast   
- Finally, run `ssreg_NMTv2` with the `all` flag for alignment. It will pick up the previous affine registration and add a nonlinear one.

<details>
<summary>Example code for a T2w scan with our default positional arguments</summary>
<pre>$ Example of running the ssreg_NMTv2.sh script for a T2w scan on the command line
<br>

$ subject = 'Aapie', cost function = 'lpc', registration type = 'affine'
bash ssreg_NMTv2.sh Aapie lpc affine /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
<br>

$ run the replacement script: treating T1 as T2
bash ss_T2w_imitates_T1w.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym
<br>

$ subject = 'Aapie', cost function = 'lpa', registration type = 'all'
bash ssreg_NMTv2.sh Aapie lpa all /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
</pre>
</details>

<br>

The pipeline generates surfaces as gifti files. We have added an extra step to also convert these to ply mesh files so they can be easily loaded in many software packages. It uses `aw_gii2ply.sh `. 

<br>

![nmt_aligned](images/nmt.png)

<br>

You can find the newly generated files and folders here: `<where you want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/aligned_<subject>/`

<br>

<details>
<summary>Visualizing the newly generated maps</summary>
<pre>$ Move to the newly generated aligned_subject folder and have a look at the individual anatomy warped to the template space
$ Replace the subject 'Aapie' with that of your own subject in the code below
<br>
$ To visualize the subject warped to template space with the CHARM (cortical) atlas projected on top:
fsleyes Aapie_warp2std_nsu.nii.gz NMT_v2.0_sym.nii.gz CHARM_in_NMT_v2.0_sym.nii.gz
<br>
$ To visualize the template onto the individual subject space with SARM (sub-cortical) atlas projected in subject space:
fsleyes Aapie.nii.gz NMT2_in_Aapie.nii.gz SARM_in_NMT_v2.0_sym_in_Aapie.nii.gz
</pre>
</details>

<details>
<summary>Short descriptions of the newly generated maps</summary>
<pre>NB: Animal warper also documents input and output files in the 'animal_outs.txt' file generated! Which is quite informative
<br>  
But we'll provide an additional overview of the files in the folder below:
> the template file itself
  - NMT_v2.0_sym.nii.gz <br>
> template files into subject space (i.e. NMT or another template into subject space)
  - NMT_*_in_[subj].nii.gz <br>
> atlas files (i.e. SARM/CHARM/D99 into subject space)
  - D99_atlas_*_in_[subj].nii.gz <br>
> original subject space files
  - [subj].nii.gz
  - [subj]_mask.nii.gz (mask used for brain extraction)
  - [subj]_ns.nii.gz (ns: no skull, brain exctracted)
  - [subj]_nsu.nii.gz (nsu: no skull & uniformization applied) <br>
> subject warped into standard space (i.e. into NMT space for example)
  - [subj]_warp2std.nii.gz
  - [subj]_warp2std_ns.nii.gz (ns: no skull, brain exctracted)
  - [subj]_warp2std_nsu.nii.gz (nsu: no skull & uniformization applied) <br>
> transformations (concatonated warps, linear and/or non-linear)
  - [subj]_*.1D (linear warp)
  - [subj]_*_inv.1D (inverted linear warp: from template space to subject space)
  - [subj]_shft_WARP.nii.gz (non-linear warp)
  - [subj]_shft_WARPINV.nii.gz (inverted non-linear warp)
</pre>
</details>

<br>

The script performs the registration of the template and individual, then treats atlas files as 'follower-volumes'. The NMTv2 comes with the CHARM, SARM, and D99 atlases when downloaded from the AFNI website. We have added an updated version of D99, called D99v2 ([see this paper](https://www.sciencedirect.com/science/article/pii/S1053811921010314?via%3Dihub)) that includes many subcortical areas that are not included in the original D99. We registered the D99v2 atlas to NMTv2 using the precalculated D99-to-NMTv2 transforms from [RheMAP](https://gin.g-node.org/ChrisKlink/RheMAP). You can set which atlases to include in `ssreg_NMTv2.sh`.

## Step 4: Generate additional ROI files and surfaces   
The [CHARM](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/atlas_charm.html) and [SARM](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/atlas_sarm.html) atlases of cortical and subcortical parcellations respectively are hierarchically organized, meaning they provide parcellations at different spatial resolutions. Here, for each level, we split the parcellations in individual volumetric ROI files and generate surface mesh files of each ROI as well. There are versions for both the affine and nonlinearly registered atlases.

In an update we have added the ROI extraction for the D99v2 atlas as well. Users can toggle which atlases to extract ROIs from by setting `doCHARM=1`, `doSARM=1`, and `doD99=1` at the top of the `ssreg_aff_ROIs.sh` and `ssreg_nlin_ROIs.sh` scripts to include atlases. Set them to `0` to exclude.

The generation of mesh files requires Python and the modules `nibabel`, `numpy`, `igl`, `skimage`, & `scipy`. 
The script will check whether these are present and quit without making meshes when this is not the case.

`ssreg_aff_ROIs.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`       
`ssreg_nlin_ROIs.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

<details>
<summary>Example code running both scripts sequentially with our default positional arguments</summary>
<pre>$ Example of running the scripts for the T1w scan used earlier on the command line
$ subject = 'Aapie'
bash ssreg_aff_ROIs.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
bash ssreg_nlin_ROIs.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
</pre>
</details>

![ROIsurfaces](images/roisurfaces.png)
Images of the 3D meshes generated in [3D Slicer](https://download.slicer.org/) visualization software

<br>
Additional note: it's possible that generation of some *.ply files at higher processing levels will generate an ERROR (mostly hippocampal ROIs), this warning can be ignored.

<br> <br>

## Step 5: Warp previously recorded retinotopic maps
For visual neuroscience, it is often useful to know what regions of space a voxel is likely to respond to. To that end we can warp previously recorded retinotopic maps to each individual. There are two sources of retinotopic information. A phase-encoded map, courtesy of KU Leuven, and population receptive field maps from recordings in our own lab [(Klink et al. 2021)](https://doi.org/10.7554/eLife.67304). These files are not included in this repository, but you can download them [here for NMTv2_sym](https://www.dropbox.com/scl/fo/mrqj7j7xt26e3b78dt3yv/AH0Y1wdWjxI-2Pqp_V4R0v8?rlkey=zty45rm5coa70ld7qb2ucdwsd&dl=0) or [here for NMTv2_asym](https://www.dropbox.com/scl/fo/alj3hjetzcedl8gkiwa3d/AMkK8g3bOIC-XPCULRpHi9I?rlkey=l5764g8fh5i6wfs8vyu8g7d0s&dl=0). Place the folder `supplemental_RETINOTOPY` in the root folder of your NMT version where you also see the other `supplemental_XXXX` folders. Again both an affine and a nonlinear version exist.

`ssreg_aff_Retinotopy.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`     
`ssreg_nlin_Retinotopy.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

<details>
<summary>Example code running both scripts sequentially with our default positional arguments</summary>
<pre>$ Example of running the scripts for the T1w scan used earlier on the command line
$ subject = 'Aapie'
bash ssreg_aff_Retinotopy.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
bash ssreg_nlin_Retinotopy.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
</pre>
</details>

<br>

![retinotopy](images/retinotopy.png)
Visualization of the eccentricity map in visual cortex in FSLeyes

<br>

## Step 6: Warp an LGN retinotopic model
We have warped a detailed mathematical retinotopic map of the LGN [(Erwin et al. 1999)](http://malpeli.psychology.illinois.edu/atlas/) to the NMT space so that we can now also easily warp it to the individual through the SARM delineation of the LGN. These files are included in the download references in Step 5. There are three sources of the NMT-based LGN-maps, 1) a rigid placement in NMT space (don't use this), 2) an affine registration to NMT, 3) a nonlinear registration to NMT. Because the atlas is only defined in the LGN, the registration can only use the shape of LGN for this original step. Again, there is an affine and affine+nonlinear version of this.

`ssreg_aff_Retinotopy-LGN.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`      
`ssreg_nlin_Retinotopy-LGN.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

<details>
<summary>Example code running both scripts sequentially with our default positional arguments</summary>
<pre>$ Example of running the scripts for the T1w scan used earlier on the command line
$ subject = 'Aapie'
bash ssreg_aff_Retinotopy-LGN.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
bash ssreg_nlin_Retinotopy-LGN.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
</pre>
</details>

<br>

![retinotopy-lgn](images/retinotopylgn.png)
Visualization of the eccentricity map in the LGN in FSLeyes

<br>

## Step 7: Warp the ONPRC18 DTI template
The [ONPRC18 template](https://www.nitrc.org/projects/onprc18_atlas) includes DTI information that
can be warped to an individual. This is a little more involved than anatomical warps as tensor information is directional and needs to be corrected for spatial warps. For this to work, you will need the ONPRC18 files in NMTv2 space. They are not included in this repository, but you can download them [here for NMTv2_sym](https://www.dropbox.com/scl/fo/mrqj7j7xt26e3b78dt3yv/AH0Y1wdWjxI-2Pqp_V4R0v8?rlkey=zty45rm5coa70ld7qb2ucdwsd&dl=0) or [here for NMTv2_asym](https://www.dropbox.com/scl/fo/alj3hjetzcedl8gkiwa3d/AMkK8g3bOIC-XPCULRpHi9I?rlkey=l5764g8fh5i6wfs8vyu8g7d0s&dl=0). Place the folder `supplemental_ONPRC18` in the root folder of your NMT version (in this case the NMT_v2.0_sym) where you also see the other `supplemental_XXXX` folders.

<b>Please note</b>: these scripts require installation of [ANTs](https://andysbrainbook.readthedocs.io/en/latest/ANTs/ANTs_Overview.html) (Advanced Normalization Tools)
<br> <br>

The scripts then work as follows (again using either the affine or affine+nlin):

`ssreg_aff_ONPRC18.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`        
`ssreg_nlin_ONPRC18.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

<details>
<summary>Example code running both scripts sequentially with our default positional arguments</summary>
<pre>$ Example of running the scripts for the T1w scan used earlier on the command line
$ subject = 'Aapie'
bash ssreg_aff_ONPRC18.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
bash ssreg_nlin_ONPRC18.sh Aapie /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym NMT_v2.0_sym
</pre>
</details>

<br>

![onprc18](images/onprc18.png)

<br>

## Step 8: Create Freesurfer compatible surfaces
For later processing and/or visualisation, for instance with packages like [NHP-Pycortex](https://github.com/VisionandCognition/NHP-pycortex) it can be useful to generate [Freesurfer](https://surfer.nmr.mgh.harvard.edu/) compatible surfaces and segmentations. This is not trivial for non-human brains. With a package like [NHP-Freesurfer](https://github.com/VisionandCognition/NHP-Freesurfer) you can do this but it requires a fair bit of manual editing. A fast alternative we have implemented here is to use the [precon_all](https://github.com/neurabenn/precon_all) package. It is fully automated and Freesurfer compatible, but results may vary. We created two pipelines one that does everything automatically `ssreg_precon_all.sh` and one that requires a couple more intermediate manual steps and running through both `ssreg_precon2.sh` and `ssreg_precon3.sh`.

To use it the more **automatic** pipeline:

`ssreg_precon_all.sh subject regtype [template folder path] [NMT version] [NMT type]`

Here`regtype` defines whether we will only do affine registration (`affine`), affine+nonlinear (`nlin`), or both (`both`).

<details>
<summary>Example code running the precon_all script with our default positional arguments</summary>
<pre>$ You will find the outputs in ../seg and ../surf subfolders, a data-structure that freesurfer uses  
$ subject = 'Aapie'
bash ssreg_precon_all.sh Aapie both /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym
</pre>
</details>

<br>

To use the more **manual** pipeline:
<br>
(1) First check the quality of your mask
<details>
<summary>FSLeyes to check the mask</summary>
<pre>$ You will find your mask in the main aligned_Aapie folder
$ subject = 'Aapie'
fsleyes NMT2_in_Aapie.nii.gz Aapie.nii.gz Aapie_mask.nii.gz
</pre>
</details>

(2) Edit your mask if necessary: we recommend doing so in FSLeyes, in particular around the occipital and temporal lobe (drop-out) and by cutting the eyes
or dura/bone tissue if it's included in the mask

![FSLeyes_temporallobe](images/FSLeyes_temporallobe.png)
**FSLeyes with a mask on top NMT2_in_Aapie.** Change the opacity of the mask and use Tools > Edit Mode to make modifications.
Once you're happy with this mask, save it as Aapie_mask_edit.nii.gz.

<br>

(3) Run the first part of the precon scripts (precon 2), which performs denoising and segmentation
<details>
<summary>Example code running the precon_2 script with our default positional arguments</summary>
<pre>$ You will find the outputs in the ../seg and ../mri subfolders, a data-structure that freesurfer uses  
$ subject = 'Aapie', indicate 'Yes' to use the previously defined mask (no if you would like precon_all to do brain extraction)
bash ssreg_precon2.sh Aapie both /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym Yes
</pre>
</details>

<br>

(4) The script generated segmentations in different folders in the aligned_Aapie/freesurfer directory.
Each of these folders contains a ../seg, ../mri and ../surf subdirectory.
It is wise to check the white matter segmentation, which you can manually alter if you see large deviations
<details>
<summary>FSLeyes to check the segmentation</summary>
<pre>$ You will find the outputs in the ../mri subfolder
fsleyes wm_orig.nii.gz T1.nii.gz
</pre>
</details>

<br>

![FSLeyes_segmentation](images/Segmentation_Check_FSLeyes.png)
**FSLeyes with a mask of the segmentation (wm_orig.nii.gz) on top of the T1 image.** Change the opacity of the mask and use Tools > Edit Mode to make modifications.
Once you're happy with this mask, save it as wm_hand_edit.nii.gz. In this example the segmentation erroneously included an artery as white matter.
Other things to check are patchy parts of white matter in the occipital cortex.

<br>

(5) Alter your segmentation if you think you can improve your image and save it in the same folder as wm_hand_edit.nii.gz.
The precon scripts will pick up this manual mask and use it instead for the remainder of the workflow

<br>

(6) Rerun the precon2 step, with the segmentation from your manual mask(s)
<details>
<summary>Example code running the precon_2 script</summary>
<pre>$ You will find the outputs in the ../seg and ../mri subfolders, a data-structure that freesurfer uses  
$ subject = 'Aapie'
bash ssreg_precon2.sh Aapie both /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym Yes
</pre>
</details>

<br>

(7) Run the precon3 step which applies tesselation and inflates the brain
<details>
<summary>Example code running the precon_3 script</summary>
<pre>$ You will find the outputs in the ../seg and ../mri subfolders, a data-structure that freesurfer uses  
$ subject = 'Aapie'
bash ssreg_precon3.sh Aapie both /NHP_MRI/Template NMT_v2.0 NMT_v2.0_sym
</pre>
</details>

<br>

(8) Visualize the inflated surfaces to check your outputs (this can be done after the automatic and manual pipelines)
<details>
<summary>Example code to visualize segmentations and surfaces in freeview </summary>

<pre>$ Move to the freesurfer folder of your subject and use the following commands:
<br>
$ To visualize the segmentations (white matter and pial):
freeview -v ./mri/brain.mgz -f ./surf/rh.white ./surf/rh.pial ./surf/lh.white ./surf/lh.pial

$ To visualize the inflated right hemisphere:
freeview -f ./surf/rh.inflated:curvature_method=binary

$ To visualize the left hemisphere as a sphere:
freeview -f ./surf/lh.sphere:curvature_method=binary
</pre>
</details>

<br>

![precon_all](images/precon_all.png)
Visualizations of the surfaces and segmentations generated in [Freeview](https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall)

<br>

## Step 9: Generate Flatmaps through Freesurfer tools
After generating the freesurfer compatible surfaces in step 8, it's possible to generate flatmaps based on these surfaces. We found that it requires a fair bit of polishing and
that there's no one-size-fits-all approach. Here is an outline of our workflow:

(1) First visualize the inflated surface that you would like to use for flatmap generation in freeview
<details>
<summary>Example code to visualize segmentations and surfaces in freeview </summary>
<pre>
$ To visualize the inflated right hemisphere:
  
freeview -f ./surf/rh.inflated:curvature_method=binary
</pre>
</details>

<br>

![Flatmap_Gen1](images/Flatmap_Gen1.png)
The inflated flatmap with the cutting/editing tools in the left ribbon

(2) Make five 'relax cuts' and a single 'closed cut', this can be done by using cutting options in Freeview
You can click on the surface and generate a line of points that can subsequently be cut

<br>

![Flatmap_Gen2](images/Flatmap_Gen2.png)
The inflated flatmap with the five relax cuts and a single closed cut

(3) After applying the cuts, move the cursor to the patch that you would like to keep (the lateral brain, rather than the medial patch).
You can now apply the 'fill uncut area' option to get rid of the smaller patches

<br>

![Flatmap_Gen3](images/Flatmap_Gen3.png)
Visualization of the inflated flatmap with the medial patch removed

(4) Save the patch in the ../surf folder as a *.3d file

<br>

![Flatmap_Gen4](images/Flatmap_Gen4.png)
Saving the obtained patch as a *.3d file that will be used in the flattening step.

<br>

(5) Flatten the obtained patch by using the `mris_flatten` algorithm from freesurfer
It will take a while to generate the full flatmap (30 minutes). We've noticed that misfolding can happen if the distance parameters are not 
specified correctly. It's better to use relatively high values for the distances (20 20 for example). Misfolding can also happen because of holes
or spikes in the segmentation surface, in which case it's better to return to Step 8 (Create Freesurfer compatible surfaces)

<details>
<summary>Example code to flatten the inflated hemispheres </summary>
<pre>
$ Apply flattening to the left hemisphere
mris_flatten -w 0 -distances 20 20 lh.full.patch.3d lh.full.patch.flat
<br>
$ Apply flattening to the right hemisphere
mris_flatten -w 0 -distances 20 20 rh.full.patch.3d rh.full.patch.flat
</pre>
</details>








