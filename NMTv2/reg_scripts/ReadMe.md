# Registration scripts used for NHP MRI    
This collection of bash scripts does several registration steps:
- Register an individual monkey scan (or the average of several) to a T1w template and atlas    
- Create additional ROI files and surface meshes
- Register a DTI template to get tensors in the individual's antomical space    

There are also batch files that can run this on multiple individuals without user interference.   

## Pre-align the center of the individual scan to the template       
Use `ssreg_prep.sh` for this. Not that if you want to do both a T2w and T1w registration of the same subject you should 
probably take additional steps to make sure the two native space are aligned before you continue to template registration. The script 
takes one input `${SUBJECT` which should be the base of the individual scan's filename, e.g. `Chris` for `Chris.nii.gz`.    

## Register Single Subject to NMT template and CHARM/SARM/D99 atlases (and vice versa)           
The script `ssreg_NMTv2.sh` takes two inputs `$1=$SUBJECT` again and `$2=COSTFUNCTION`. This allows you to apply the same 
script to T1w and T2w images. Use `COST=lpa` for T1w and `COST=lpc` for T2w individual scans.     

## Generate separate ROIs and surfaces     
The `ssreg_aff_ROIs.sh` and `ssreg_nlin_ROIs.sh` scripts generate separate ROI files and surfaces. Note that
the atlases also have all ROIs but extra steps are required to visualize a selection. It's easier with separate ROIs. The affine and nonlinear denote that the generate the ROIs based on the affine and nonlinear registration with the template respectively. Again, `$1=SUBJECT`.    

## Register DTI template to the Single Subject for tractography       
This is done with `ssreg_aff_ONPRC18.sh` (affine) and `ssreg_nlin_ONPRC18.sh` (nonlinear). The scripts
warp both the tensor volume and some derivatives, as well as anatomy and labelmaps. It uses ANTs for registration and therefore
takes a while to compute. Again, `$1=SUBJECT`. To increase success rates the transforms are calculated for `NMT` to `NMT_in_SingleSubject` which have highest contrast.     

## Register Retinotopy to the Single Subject anatomy    
The scripts `ssreg_aff_Retinotopy.sh` and `ssreg_nlin_Retinotopy.sh` register the pRF-maps from previous experiments at the NIN
as well as the probablistic phase-encoded retinotopy from KUL to the individual. The scripts `ssreg_aff_Retinotopy-LGN.sh`
and `ssreg_nlin_Retinotopy-LGN.sh` register the modeled retinotopy of the LGN (Erwin et al., 1999) to the individual. `$1=SUBJECT`.     

## Generate Freesurfer compatible surfaces for the individual    
Based on the `precon_all` pipeline (https://github.com/neurabenn/precon_all), the `ssreg_precon_all.sh` script takes the 
`NMT_in_<SUBJECT>.nii.gz` and generates Freesurfer compatible surfaces that can then be used with `NHP-pyCortex` as well.
Always check if these results make sense. Automated surface generation is always tricky, especially for non-humans. `$1=SUBJECT`.        

## Batch scripts and independent running       
The abovementioned scripts can be run independently by specifying a subject name for which a nifti should be present as:    
`/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/<SUBJECT.nii.gz>`.      

The command to run it would then be:
`ssreg_NMTv2_T1w.sh <SUBJECT>`    

Alternatively, you can run one or multiple individuals with one of the batch scripts (`Batch_....`) in which you can set up an array of subject names to loop over. Examples are present for whcih you only need to change the array of names.    




