# NHP-TemplateScripts     

This package performs a registration of the NIH Macaque Template brain to an individual MR scan. 
It will automatically also registers detailed cortical and subcortical atlases and optionally a 
broad range of additional information such as probablistic DTI and retinotopy (cortex and LGN).

The basic registrations requires:
- `AFNI` [https://afni.nimh.nih.gov/](https://afni.nimh.nih.gov/)    
- The template package: [NMTv2.0](https://afni.nimh.nih.gov/pub/dist/doc/htmldoc/nonhuman/macaque_tempatl/template_nmtv2.html)

After downloading the NMT we suggest saving it in the following file structure:    
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym` and `<where-you-want>/NMT_v2.0/NMT_v2.0_asym` 

Download this package of scripts and save it wherever you want. The scripts should be aware of their
relative positions and function at any location as long as the package structure is intact. 
The bulk of the work is done by the `ssreg_*.sh` scripts (see below) but the `Batch` folder also
contain scripts to configure multiple procedures for multiple individuals. These will be executed
serially so if you want to do things in parallel, you will need to run multiple instances or come
up with a script yourself. Do note that especially the non-linear registration takes quite some
resources so be careful when initiating multiple of them on a computer with limited resources.

## Step 1: Prepare the individual scan    
If you have a T1 or T2 scan of reasonable quality (the procedure is pretty forgiving). You will first 
need to make sure the orientation is (roughly) correct and the image cropped around the head with
not too much empty space. Use your favorite tools to do this, our methods tend to involve:    
- `dcm2niix` to convert dicom files to nifti. Get it at [NITRC](https://www.nitrc.org/plugins/mwiki/index.php/dcm2nii:MainPage)
- `Freesurfer`'s `mri_convert` takes a `--sphinx` flag to correct for animals in a sphinx orientation 
in a human scanner. See the [documentation](https://surfer.nmr.mgh.harvard.edu/fswiki/mri_convert)
- [Reorient](https://neuroanatomy.github.io/reorient/) is a nice web tool to quickly rotate, translate, 
and crop nifti files to approximate APCP orientation. This works best for subsequent steps.

After doing this create a `SingleSubjects` folder in the NMT folder you intend to use, e.g. 
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects`. Within this folder, make an input folder
`<where-you-want>/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files` where you copy the roughly correctly
oriented and cropped nifti file of your individual as `SubjectName.nii.gz`. The scripts will assume
that the entire filename (without the `.nii.gz` extension) is the subject name and will treat it as such.
Once this is all set up you can run the scripts. 

## Step 2: Put the individual in the same spatial location as the template     
The first processing step is `ssreg_prep.sh`. It takes one obligatory argument `subject-name`, and a number
of optional positional arguments.

`ssreg_prep.sh subject [template folder path] [NMT version] [NMT type] [NMT subtype]`

Defaults for the positional arguments can be set in the script. For us, they are:

`template folder` /NHP_MRI/Template    
`NMT version` NMT_v2.0    
`NMT type` NMT_v2.0_sym    
`NMT subtype` NMT_v2.0_sym     

This script centers the individual scan on the center of the template and saves the original file and
the applied transform. Further scripts will work with the recentered individual.    

## Step 3: Co-register the individual and template    


`ssreg_NMTv2.sh subject cost regtype [template folder path] [NMT version] [NMT type] [NMT subtype]`
SUB=${1}
COST=${2}
ALIGN=${3}

TEMPLATEFLD=${4:-'/NHP_MRI/Template'}
NMTVERSION=${5:-'NMT_v2.0'}
NMTTYPE1=${6:-'NMT_v2.0_sym'}
NMTTYPE2=${7:-'NMT_v2.0_sym'}
