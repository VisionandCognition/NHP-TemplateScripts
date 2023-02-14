# Registration scripts used for NHP MRI    
This collection of bash scripts does several registration steps:
- Register an individual monkey scan (or the average of several) to a T1w template and atlas    
- Create additional ROI files and surface meshes
- Register a DTI template to get tensors in the individual's antomical space    

There are also batch files that can run this on multiple individuals without user interference.   

## Register Single Subject to NMT template and CHARM/SARM atlases (and vice versa)           
There are several versions of these scripts that deal with different types of source scans or run on different systems.

`SingleSubject_reg_NMTv2_T1w.sh` registers a T1w anatomical scan to the NMTv2 template using AFNI's `@animal_warper`. 
It also gives you the CHARM (cortical) and SARM (subcortical) atlases in native space.     

`SingleSubject_reg_NMTv2_T2w.sh` registers a T2w anatomical scan to the NMTv2 template. It also gives you the CHARM (cortical) 
and SARM (subcortical) atlases in native space. It uses `@animal_warper` with a dfferent cost-function than 
`SingleSubject_reg_NMTv2_T1w.sh` to account for the difference in contrast between T2w individual and T1w template.    

`SingleSubject_reg_NMTv2_T1w_mircen.sh` and `SingleSubject_reg_NMTv2_T2w_mircen.sh` do the same as `SingleSubject_reg_NMTv2_T1w.sh` and 
`SingleSubject_reg_NMTv2_T2w.sh` but with some paths that are specific for the infrastructure at the MIRCen facility.     

## Generate separate ROIs and surfaces     
The `SingleSubject_affine_ROIs.sh` and `SingleSubject_nonlinear_ROIs.sh` scripts generate separate ROI files and surfaces. Note that
the atlases also have all ROIs but extra steps are required to visualize a selection. It's easier with separate ROIs. The affine and
nonlinear denote that the generate the ROIs based on the affine and nonlinear registration with the template respectively.

## Register DTI template to the Single Subject for tractography       
This is done with `SingleSubject_reg_affine_ONPRC18.sh` (affine) and `SingleSubject_reg_nonlinear_ONPRC18.sh` (nonlinear). The scripts
warp both the tensor volume and some derivatives, as well as anatomy and labelmaps. It uses ANTs for registration and therefore
takes a while to compute. To increase success rates the transforms are calculated for `NMT` to `NMT_in_SingleSubject` which have highest contrast.     

## Batch scripts and independent running       
The abovementioned scripts can be run independently by specifying a subject name for which a nifti should be present as:    
`/NHP_MRI/Template/NMT_v2.0/NMT_v2.0_sym/SingleSubjects/input_files/<SUBJECT.nii.gz>`     

The command to run it would then be:
`SingleSubject_reg_NMTv2_T1w.sh <SUBJECT>`    

Alternatively, you can run one or multiple individuals with one of the batch scripts (`Batch_....`) in which you can set up an array of
subject names to loop over.




