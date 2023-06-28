# requires nibabel, scikit-image, scipy, igl
import nibabel as nib
import numpy as np
import igl, sys
from skimage import measure
from scipy.ndimage import distance_transform_edt

# set paths
in_file = sys.argv[1]
out_file = sys.argv[2]

try:
	# get binary mask
	nii = nib.load(in_file)
	binary_mask = nii.get_fdata()

	# get affine translation
	dx = nii.affine[0][3]
	dy = nii.affine[1][3]
	dz = nii.affine[2][3]
	aff=np.asarray([-dx, -dy, dz])
	# print(nii.affine)

	# create mesh
	distance = distance_transform_edt(binary_mask)
	verts, faces, _, _ = measure.marching_cubes(distance, 0, 
		spacing=(abs(nii.affine[0][0]),abs(nii.affine[1][1]),abs(nii.affine[2][2])),
		gradient_direction="ascent",method='lewiner')

	# apply affine translation to vertices
	verts2 = [v+aff for v in verts]
	verts2 = np.asarray(verts2)

	# save 
	igl.write_triangle_mesh(out_file,verts2, faces)
except:
	print('ERROR: cannot create ' + sys.argv[2])
