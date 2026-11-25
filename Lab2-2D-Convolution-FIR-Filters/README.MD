Lab 2: 2D Convolution & FIR Filters
Overview
This lab investigates how two-dimensional finite impulse response (FIR) filters modify images in MATLAB. The experiments use a grayscale image to study impulse responses, low-pass smoothing, unsharp masking, edge detection, convolution versus correlation, and boundary handling. The same source image is used throughout so the effects of each operation can be compared.

1. Delta Image and Impulse Response
A 101 × 101 image is initialized to zero, except for a unit impulse at its center. Convolving this impulse with a normalized 3 × 3 averaging kernel reproduces the kernel around the impulse location. All nine coefficients equal 1/9 and sum to one. This illustrates why a filter kernel is described as its two-dimensional impulse response, h[m,n]: it specifies how a point impulse spreads through the filter.

2. Low-Pass Filtering: Box and Gaussian
A 3 × 3 box filter replaces each pixel by the mean of a small neighborhood. A 7 × 7 box filter averages over a larger neighborhood and therefore smooths more aggressively, but it may erase fine textures and soften edges.

A Gaussian filter uses larger weights near the center and gradually smaller weights farther away. This generally produces smoother-looking transitions than an equally sized box filter. In this experiment a Gaussian filter with a 7 × 7 support and sigma 1.2 is compared with both box filters.

The Gaussian kernel is separable: it can be calculated as the outer product of a horizontal 1D kernel and a vertical 1D kernel. Two sequential 1D filtering passes produce the same result as a 2D Gaussian filter, apart from floating-point roundoff, when boundary handling is consistent.

3. Sharpening with Unsharp Masking
Unsharp masking first creates a Gaussian-blurred version of the image. Subtracting the blurred image from the original isolates a signed high-frequency mask containing edges and fine details. Adding that mask back to the original emphasizes transitions and makes some boundaries appear sharper.

The sharpening gain is set to 1.0, and the output is clipped to the valid intensity range [0,1]. The signed mask is displayed with neutral gray representing zero; brighter and darker regions indicate positive and negative differences. Stronger sharpening can exaggerate noise and cause bright or dark halos around edges.

4. Edge Detection: Sobel and Laplacian
Sobel filtering estimates image intensity changes in two perpendicular directions. The magnitude of the combined gradients emphasizes locations with strong transitions regardless of their orientation. The Laplacian responds to second-order spatial changes and often produces a different appearance, including positive and negative responses around edges.

For visual comparison, each response is independently normalized. Therefore, brightness levels across different edge-response panels should not be interpreted as directly comparable absolute filter magnitudes.

5. Convolution versus Correlation
Convolution reverses the kernel in both spatial directions before combining it with the image; correlation does not reverse the kernel. The normalized averaging kernel is symmetric, so its convolution and correlation effects are the same when the boundary rules match.

The script also uses an asymmetric kernel to show that convolution and correlation can give visibly different outputs. It computes the maximum absolute difference between conv2 and imfilter(...,'conv') with matching zero padding, then compares convolution and correlation using the asymmetric kernel.

6. Boundary Handling
Image filters need values beyond the image border when their kernels overlap an edge. Different boundary modes provide those values differently:

Replicate: extends the nearest border pixel outward.
Symmetric: reflects image values across the boundary.
Circular: wraps values from the opposite side of the image.
These choices mainly affect pixels close to the image boundaries. Circular padding can introduce unrealistic influence from the opposite side for images that are not naturally periodic. The script computes border-region differences between these methods to make the comparison measurable.

7. Reflection Questions
Why is Gaussian filtering often preferred over a large box low-pass filter?
Gaussian filtering assigns smoothly varying weights to neighboring pixels. A large box filter uses uniform weights with abrupt kernel boundaries, leading to a less smooth frequency response and potentially more undesirable artifacts. The Gaussian filter is often preferred when smooth blur and preservation of natural transitions are important. The best filter still depends on the intended application.

What does separability do for computational cost?
A direct 7 × 7 convolution requires roughly 49 multiply-accumulate contributions per output pixel. A separable 7 × 7 Gaussian can be implemented by a 1 × 7 pass followed by a 7 × 1 pass, using roughly 14 contributions per pixel, excluding overhead. This reduces the arithmetic work while preserving the same filter operation under consistent boundary handling.

How do boundary modes change image corners and edges?
Boundary modes alter which sample values are used when the kernel extends beyond the image. Replication repeats the nearest pixel; symmetric padding mirrors the nearby image; circular padding takes values from the opposite edge. These operations can change the filtered brightness and texture near corners and boundaries, even when the middle of the image is essentially unchanged.

8. Engineering Applications
Two-dimensional FIR filtering is used in image denoising, machine vision, feature extraction, medical imaging, quality inspection, and image enhancement. Smoothing can reduce unwanted high-frequency variation before further processing; sharpening and gradient filters can make structural boundaries easier to detect.

9. Conclusion
This lab demonstrates that the choice of kernel affects the appearance and information content of an image. Box and Gaussian filters reduce local variations, unsharp masking emphasizes high-frequency details, and Sobel and Laplacian filters reveal spatial intensity changes. Separable filters can reduce computational cost, while convolution conventions and border handling must be selected consistently for reproducible results.

The explanations describe expected behavior. Final observations and numerical differences should be verified against the figures and Command Window output after running the script in MATLAB.
