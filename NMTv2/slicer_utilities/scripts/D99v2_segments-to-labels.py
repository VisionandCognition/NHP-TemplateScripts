import slicer
import numpy as np

# Chris Klink (c.klink@nin.knaw.nl)
# use code in Slicer Python interpreter (copy/paste)

# --- USER INPUT / SETUP ---
# 1. Get references to your nodes
segmentationNode = slicer.util.getNode('D99v2') 
tableNode = slicer.util.getNode('D99v2_slicer')     
   
# 2. Define the column names in your CSV/Table
ID_COLUMN = 'ID'
NAME_COLUMN = 'LONG'

def get_column_index_by_name(table, column_name):
    """Finds the index of a column by its name in a vtkTable."""
    for i in range(table.GetNumberOfColumns()):
        if table.GetColumnName(i) == column_name:
            return i
    return -1

# --- SCRIPT LOGIC ---
if not segmentationNode or not tableNode:
    if not segmentationNode:
        print("Error: Could not find Segmentation node. Check name or load segmentation.")
    else:
        print("Error: Could not find Table node. Check name or load table.")
else:
    # Get the segmentation object
    segmentation = segmentationNode.GetSegmentation()
    
    # Get the vtkTable object
    table = tableNode.GetTable()
    
    # Map the header names to column indices using the helper function
    id_col_index = get_column_index_by_name(table, ID_COLUMN)
    name_col_index = get_column_index_by_name(table, NAME_COLUMN)
    
    if id_col_index == -1 or name_col_index == -1:
        print("Error: One or more specified columns were not found in the table.")
    else:
        num_rows = table.GetNumberOfRows()
        print(f"Processing {num_rows} rows from the table...")

        for row in range(num_rows):
            # 1. Read values from the table
            segment_id = 'Segment_' + table.GetValue(row, id_col_index).ToString()
            new_name = table.GetValue(row, name_col_index).ToString()

            # 2. Find and update the segment
            segment = segmentation.GetSegment(segment_id)
            
            if segment:
                # Update Name
                segment.SetName(new_name)
                
                print(f"Updated Segment ID '{segment_id}' to Name '{new_name}")
            else:
                print(f"Warning: Segment with ID '{segment_id}' not found. Skipping.")

print("Script finished.")