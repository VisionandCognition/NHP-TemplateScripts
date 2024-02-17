#!/bin/bash
CREATEMESH=1
required_modules=("nibabel" "numpy" "igl" "skimage" "scipy")
for module in "${required_modules[@]}"; do
    if python -c "import $module" &> /dev/null; then
        echo "Module $module is available."
    else
        echo "Module $module is not available. Not creating meshes."
    fi
done
