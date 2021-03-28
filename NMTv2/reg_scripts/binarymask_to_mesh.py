# requires nibabel, scikit-image, scipy, igl
import nibabel as nib
import igl, sys
from skimage import measure
from scipy.ndimage.morphology import distance_transform_edt

# set paths
in_file=sys.argv[1]
out_file=sys.argv[2]

try:
	# get binary mask
	nii=nib.load(in_file)
	binary_mask = nii.get_fdata()

	# create mesh
	distance = distance_transform_edt(binary_mask)
	verts, faces, _, _ = measure.marching_cubes(distance, 0, gradient_direction="ascent")

	# save 
	igl.write_triangle_mesh(out_file,verts, faces)
except:
	print('ERROR: cannot create ' + sys.argv[2])