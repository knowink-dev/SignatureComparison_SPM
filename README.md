# SignatureComparison

DESCRIPTION:<br />
This package is used for comparing two image signatures together and providing a confidence level from 0-100%. Currently it only supports images that have a color space of either MonoChrome or RGB. It also supports images of different aspect ratios and stroke sizes. When comparing images the SPM spins off separate operations and or threads to process each image. Each image then goes through 4 phases of parsing to measure the number vectors and angles it has. <br /><br />

Phase 1: Converts the image to black and white pixels only. Also initializes key variables for the image parser. <br />
Phase 2: Deletes all black neighboring pixels to the left in order to handle different stroke sizes.<br />
Phase 3: Each remaining black pixel goes through a series of constructing and destructing to form various lines with only one neighboring pixel.<br />
Phase 4: Processes the vertices of each line and converts them into vectors.<br /><br /><br />


HOW TO USE:<br />
import SignatureComparison<br />
Create an instance of SignatureComparator class<br />
Call function compare(_ imageOne: UIImage, to imageTwo: UIImage, completion: @escaping (Swift.Result<Double, Error>) -> ()) {}<br />
This function will return a result with either a double or an error. The double comparison percentage is still in decimal format when returned and will need to be multiplied by 100 if it is to be shown accurately on the UI. <br /><br /><br />


HOW TO DEBUG: <br /><br />
If you would like to view the actual results from both images being parsed and used for comparison then call: <br />
    public class func compareWithDebugView(
        _ currentVC: UIViewController,
        _ primarySignature: UIImage,
        _ secondarySignature: UIImage){}
<br /><br />
The function above should only be used in Debug mode, never in Release mode.
<br /><br />
The ComparisonView provides all the images for the different phases so you can see the results of the image parser.
<br /><br />
For additional testing and experimenting with the signature comparison functionality, please use the Signature Comparison Experiment project: https://github.com/knowink-dev/SignatureComparisonExperiment<br />

This project is an actual application rather than an SPM and allows you to draw and compare two signatures together. 

