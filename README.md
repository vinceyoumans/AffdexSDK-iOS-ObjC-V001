# AffdexSDK-iOS-ObjC-V001
Affdex SDK for iOS, ObjC 

This is example code for the Afectiva SDK
http://developer.affectiva.com/v3_1_1/ios/

Tested on :11/02/2016
xCode : Version 8.1 (8B62)
iPHONE 6s
iOS: iOS on iPHONE 6s: 10.1.1
AffdexSDK-iOS (3.1.1)

This app will observe facial expressions and report metrix to NSLog.  look at VIewController.m processedImageReady method. 
Variance, ( the smile/frown metric ), is displayed on screen.

There is a change in behavior.  Before I upgraded my iOS, the variance would display 0 ( or something like that ) if the face
was out of view.  Now only the last Variance is displayed if face goes out of view. Need to find a method to fire if face out of view.

I will also work on a SWIFT version of this app.
