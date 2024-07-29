# 2DMvDA

This file contains a MATLAB function to train a model using 2DMvDA.
This function takes as input-
 1. c        - Number of classes
 2. v        - Number of views
 3. s_r      - Number of rows of the training image
 4. s_c      - Number of columns of the training image
 5. tr_n_ij  - A (c,v) matrix of number of data samples per class per view in the training dataset
 6. AV       - A (s_r,s_c,c,v,max(max(tr_n_ij))) matrix of 2D images in the training dataset

Output arguments of this function are-
1. M_ij   - Updated M_ij
2. Sjr_2D - Updated Sjr in 2D form
3. Djr_2D - Updated Djr in 2D form
