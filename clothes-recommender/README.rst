======================
Clothes Recommendation 
======================

Retail companies want to show customers products which are similar to
the ones bought in the past. This type of problems can be solved by
ranking images according to their similarity and do a content-based
recommendation.
 
The Clothes texture data sets collected from search engine are used as
example for building image recommendation models. The dataset used in
this demonstration contains clothes texture images with three labels,
dotted, leopard, and striped.  The goal is to build a recommendation
model to recommend new clothes images to users.

This pre-built model has used the Python language to build a
recommendation model to represent the knowledge discovered leveraging
CNN for image featurization and SVM for similarity ranking. The
knowledge representation is easy to understand.

The **print** will display a textual summary of the pre-trained CNN
model and its build parameters.

The **demo** applies the pre-built model to a demo data set with around
60 images and shows the top-1 recommendation results.

The **display** will visualize the image recommendation results.

Run the **score** command to provide recommendation for new clothes
texture data.

The following link provides a deep guidance on how the model is built
using Microsoft Cognitive Toolkit
(CNTK). [https://github.com/Azure/ImageSimilarityUsingCntk]
