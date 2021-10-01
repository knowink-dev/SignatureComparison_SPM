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


NOTES:<br />
For additional testing and experimenting with the signature comparison functionality, please use the Signature Comparison Experiment project: https://github.com/knowink-dev/SignatureComparisonExperiment<br /><br />

This project is an actual application rather than an SPM and allows you to draw and compare two signatures together. It also provides all the images for the phase so you can see the results of the image parser for each phase. Most of the code from this project was copied from that project, and it is recommended that before any new changes are added to this project that it first be tested in that one to ensure both projects stay up to date with the latest code.<br /><br />

WIP:<br />
The UI components were also included from that project into this SPM with the intent to convert the VC to a Popup View in order to allow in project debugging images if ever needed.
