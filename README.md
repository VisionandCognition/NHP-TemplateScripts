# NHP-TemplateScripts
This package performs a registration of the NIH Macaque Template brain to an individual MR scan. It will automatically also registers detailed cortical and subcortical atlases and optionally a broad range of additional information such as probablistic DTI and retinotopy (cortex and LGN).

The basic registrations requires:
- `AFNI` [https://afni.nimh.nih.gov/](https://afni.nimh.nih.gov/)    
- The template package: [NMTv2.0](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html)

After downloading the NMT we suggest saving it in the following file structure:    
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym` and `<where-you-want>/NMT_v2.0/NMT_v2.0_asym` 

Download this package of scripts and save it wherever you want. The scripts should be aware of their relative positions and function at any location as long as the package structure is intact. The bulk of the work is done by the `ssreg_*.sh` scripts (see below) but the `Batch` folder also contain scripts to configure multiple procedures for multiple individuals. These will be executed serially so if you want to do things in parallel, you will need to run multiple instances or come up with a script yourself. Do note that especially the non-linear registration takes quite some resources so be careful when initiating multiple of them on a computer with limited resources.

## Step 1: Prepare the individual scan    
If you have a T1 or T2 scan of reasonable quality (the procedure is pretty forgiving). You will first need to make sure the orientation is (roughly) correct and the image cropped around the head with not too much empty space. Use your favorite tools to do this, our methods tend to involve:    
- `dcm2niix` to convert dicom files to nifti. Get it at [NITRC](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage)
- `Freesurfer`'s `mri_convert` takes a `--sphinx` flag to correct for animals in a sphinx orientation 
in a human scanner. See the [documentation](https://surfer.nmr.mgh.harvard.edu/fswiki/mri_convert)
- [Reorient](https://neuroanatomy.github.io/reorient/) is a nice web tool to quickly rotate, translate, 
and crop nifti files to approximate APCP orientation. This works best for subsequent steps.

![Reorient](images/reorient.png)

After doing this create a `SingleSubjects` folder in the NMT folder you intend to use, e.g. `<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects`. Within this folder, make an input folder 
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files` where you copy the roughly correctly oriented and cropped nifti file of your individual as `SubjectName.nii.gz`. The scripts will assume that the entire filename (without the `.nii.gz` extension) is the subject name and will treat it as such. Once this is all set up you can run the scripts. 

## Step 2: Put the individual in the same spatial location as the template     
The first processing step is `ssreg_prep.sh`. It takes one obligatory argument `subject`, and a number of optional positional arguments.

`ssreg_prep.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`

Defaults for the positional arguments can be set in the script. For us, they are:

`template folder` /NHP_MRI/Template    
`NMT version` NMT_v2.0    
`NMT type` NMT_v2.0_sym    
`NMT subtype` NMT_v2.0_sym     

This script centers the individual scan on the center of the template and saves the original file and the applied transform. Further scripts will work with the recentered individual.    

## Step 3: Co-register the individual and template    
`ssreg_NMTv2` is the main registration to the template and following segmentations and atlases. It uses `AFNI`'s `@animal_warper` function and it does both an affine and a nonlinear registration. It works with both T1w and T2w scans, but there are differences. While the whole thing pretty much works out of the box for T1w the nonlinear registration results vary a  bit for for T2w (the template is T1w). Often, it just works with the correct cost function (`lpc`) but sometimes you need a workaround and this seems to work well: After affine registration, T2w images get altered so that there contrast is T1w-like. These images are then nonlinearly registered to the template and the resulting warp can be applied to unaltered images as well. To make this work there are three obligatory arguments:

- `subject` is again the subject name    
- `cost` defines the cost function used fro the registration. For T1w images use `lpa`, for T2w images use `lpc`. See `AFNI` documentation for more info.   
- `regtype` defines whether we will only do rigid (`rigid`) or affine registration (`affine`), or affine and nonlinear (`all`). We typically use `all` but when there are large dropouts in the individual scan it is pointless to try nonlinear and you save a lot of time by just doing `affine`.

The call to this script thus becomes (postional arguments as in Step 2):    
`ssreg_NMTv2.sh subject cost regtype [template folder path] [NMT version] [NMT type] [NMT subtype]`

The workaround registration of T2w images with the fix is slightly more complex. 
- First do an affine registration with `ssreg_NMTv2`      
- Then run the `ss_T2w_imitates_T1w.sh` script to mimic the T1w contrast   
- Finally, run `ssreg_NMTv2` with the `all` flag for alignment. It will pick up the previous affine registration and add a nonlinear one.

The pipeline generates surfaces as gifti files. We have added an extra step to also convert these to ply mesh files so they can be easily loaded in many software packages. It uses `aw_gii2ply.sh `. 

![nmt_aligned](images/nmt_aligned.png)

## Step 4: Generate additional ROI files and surfaces   
The [CHARM](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/atlas_charm.html) and [SARM](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/atlas_sarm.html) atlases of cortical and subcortical parcellations respectively are hierarchically organized, meaning they provide parcellations at different spatial resolutions. Here, for each level, we split the parcellations in individual volumetric ROI files and generate surface mesh files of each ROI as well. There are versions for the both the affine and nonlinearly registered atlases.

`ssreg_aff_ROIs.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    
and    
`ssreg_nlin_ROIs.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

![Atlases](images/atlases.png)

## Step 5: Warp previously recorded retinotopic maps
For visual neuroscience, it is often useful to know what regions of space a voxel is likely to respond to. To that end we can warp previously recorded retinotopic maps to each individual. There are two sources of retinotopic information. A phase-encoded map, courtesy of KU Leuven, and population receptive field maps from recordings in our own lab [(Klink et al. 2021)](https://doi.org/10.7554/eLife.67304). Again both an affine and a nonlinear version exist.

`ssreg_aff_Retinotopy.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`     
or    
`ssreg_nlin_Retinotopy.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

![retinotopy](images/retinotopy.png)

## Step 6: Warp an LGN retinotopic model
We have warped a detailed mathematical retinotopic map of the LGN [(Erwin et al. 1999)](http://malpeli.psychology.illinois.edu/atlas/) to the NMT space so that we can now also easily warp it to the individual through the SARM delineation of the LGN. There are three sources of the NMT-based LGN-maps, 1) a rigid placement in NMT space (don't use this), 2) an affine registration to NMT, 3) a nonlinear registration to NMT. Because the atlas is only defined in LGN, the registration can only use the shape of LGN for this original step. Again, there is an affine and affine+nonlinear version of this.

`ssreg_aff_Retinotopy-LGN.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`     
or    
`ssreg_nlin_Retinotopy-LGN.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

![retinotopy-lgn](images/retinotopy_lgn.png)

## Step 7: Warp the ONPRC18 DTI template
The [ONPRC18 template](https://www.nitrc.org/projects/onprc18_atlas) includes DTI information that
can be warped to an individual. This is a little more involved than anatomical warps as tensor information is directional and needs to be corrected for spatial warps. This is done with the scripts (again using either the affine or affine+nlin):

`ssreg_aff_ONPRC18.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`     
or    
`ssreg_nlin_ONPRC18.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`    

![onprc18](images/onprc18.png)

## Step 8: Create Freesurfer compatible surfaces
For later processing and/or visualisation, for instance with packages like [NHP-Pycortex](https://github.com/VisionandCognition/NHP-pycortex) it can be useful to generate [Freesurfer](https://surfer.nmr.mgh.harvard.edu/) compatible surfaces and segmentations. This is not trivial for non-human brains. With a package like [NHP-Freesurfer](https://github.com/VisionandCognition/NHP-Freesurfer) you can do this but it requires a fair bit of manual editing. A fast alternative we have implemented here is to use the [precon_all](https://github.com/neurabenn/precon_all) package. It is fully automated and Freesurfer compatible, but results may vary. To use it:

`ssreg_preconall.sh subject regtype [template folder path] [NMT version] [NMT type]`

Here`regtype` defines whether we will only do affine registration (`affine`), affine+nonlinear (`nlin`), or both (`both`).

![precon_all](images/precon_all.png)
