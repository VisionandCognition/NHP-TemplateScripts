# Registration scripts used for NHP MRI    
This collection of bash scripts does several registration steps:
- Register an individual monkey scan (or the average of several) to a T1w template and atlas    
- Create additional ROI files and surface meshes
- Register a DTI template to get tensors in the individual's antomical space    

There are also batch files that can run this on multiple individuals without user interference.   

## Pre-align the center of the individual scan to the template       
Use `SingleSubject_reg_prep.sh` for this. Not that if you want to do both a T2w and T1w registration of the same subject you should 
probably take additional steps to make sure the two native space are aligned before you continue to template registration. The script 
takes one input `${SUBJECT` which should be the base of the individual scan's filename, e.g. `Chris` for `Chris.nii.gz`.    

## Register Single Subject to NMT template and CHARM/SARM atlases (and vice versa)           
The script `SingleSubject_reg_NMTv2.sh` takes two inputs `$1=$SUBJECT` again and `$2=COSTFUNCTION`. This allows you to apply the same 
script to T1w and T2w images. Use `COST=lpa` for T1w and `COST=lpc` for T2w individual scans.     

## Generate separate ROIs and surfaces     
The `SingleSubject_affine_ROIs.sh` and `SingleSubject_nonlinear_ROIs.sh` scripts generate separate ROI files and surfaces. Note that
the atlases also have all ROIs but extra steps are required to visualize a selection. It's easier with separate ROIs. The affine and
nonlinear denote that the generate the ROIs based on the affine and nonlinear registration with the template respectively. Again, `$1=SUBJECT`.    

## Register DTI template to the Single Subject for tractography       
This is done with `SingleSubject_reg_affine_ONPRC18.sh` (affine) and `SingleSubject_reg_nonlinear_ONPRC18.sh` (nonlinear). The scripts
warp both the tensor volume and some derivatives, as well as anatomy and labelmaps. It uses ANTs for registration and therefore
takes a while to compute. Again, `$1=SUBJECT`. To increase success rates the transforms are calculated for `NMT` to `NMT_in_SingleSubject` 
which have highest contrast.     

## Batch scripts and independent running       
The abovementioned scripts can be run independently by specifying a subject name for which a nifti should be present as:    
`/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/<SUBJECT.nii.gz>`     

The command to run it would then be:
`SingleSubject_reg_NMTv2_T1w.sh <SUBJECT>`    

Alternatively, you can run one or multiple individuals with one of the batch scripts (`Batch_....`) in which you can set up an array of
subject names to loop over. Examples are present for whcih you only need to change the array of names.    




