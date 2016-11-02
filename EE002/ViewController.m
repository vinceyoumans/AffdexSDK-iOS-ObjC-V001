//
//  ViewController.m
//  EE002
//
//  Created by vincent youmans on 10/22/16.
//  Copyright © 2016 com.techlatin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -
#pragma mark Convenience Methods
// This is a convenience method that is called by the
// detector:hasResults:forImage:atTime: delegate method below.
// You will want to do something with the face (or faces) found.
- (void)processedImageReady:(AFDXDetector *)detector image:(UIImage *)image faces:(NSDictionary *)faces atTime:(NSTimeInterval)time;
{
    //  a new strange issue.  I have updated my xCODE:Version 8.1 (8B62)   iOS on iPHONE 6s: 10.1.1
    // there is a new behavior that I do not like.  Before upgrade, if face was out of frame, the
    // Variance would goto 0 or NA.  Now, the Variance just does not update, and remains what it  was before.
    // Need to find a method that fires when face is out of frame so the values can be updated to 0
    // or face return that face is not available.
    // I will work on this next week, but perhaps I can get a comment on this?
    
    // iterate on the values of the faces dictionary
    for (AFDXFace *face in [faces allValues])
    {
        // Here's where you actually "do stuff" with the face object (e.g. examine the emotions, expressions,
        // emojis, and other metrics).
        // ****  Log the FIREBASE STUFF HERE
        //self.lVariance.text = [NSString stringWithFormat: @""];
        
        
        NSLog(@"======================================================");
        NSLog(@"%@", face);
        NSLog(@"------------------------------------------------------");
        NSLog(@"faceId = %lu", (unsigned long)face.faceId);
        NSLog(@"orientation.yawl = %f", face.orientation.yaw);
        NSLog(@"orientation.pitch = %f", face.orientation.pitch);
        NSLog(@"orientation.roll = %f", face.orientation.roll);
        NSLog(@"orientation.interocularDistance = %f", face.orientation.interocularDistance);
        
        NSLog(@"appearance.age = %u", face.appearance.age);
        NSLog(@"appearance.ethnicity = %u", face.appearance.ethnicity);
        NSLog(@"appearance.glasses = %u", face.appearance.glasses);
        NSLog(@"appearance.gender = %u", face.appearance.gender);
        
        NSLog(@"emotions.anger = %f", face.emotions.anger);
        NSLog(@"emotions.contempt = %f", face.emotions.contempt);
        NSLog(@"emotions.disgust = %f", face.emotions.disgust);
        NSLog(@"emotions.engagement = %f", face.emotions.engagement);
        NSLog(@"emotions.joy = %f", face.emotions.joy);
        NSLog(@"emotions.sadness = %f", face.emotions.sadness);
        NSLog(@"emotions.surprise = %f", face.emotions.surprise);
        NSLog(@"emotions.valence = %f", face.emotions.valence);
      
        
        NSLog(@"expressions.attention = %f", face.expressions.attention);
        NSLog(@"expressions.browFurrow = %f", face.expressions.browFurrow);
        NSLog(@"expressions.browRaise = %f", face.expressions.browRaise);
        NSLog(@"expressions.innerBrowRaise = %f", face.expressions.innerBrowRaise);
        NSLog(@"expressions.cheekRaise = %f", face.expressions.cheekRaise);
        NSLog(@"expressions.chinRaise = %f", face.expressions.chinRaise);
        NSLog(@"expressions.dimpler = %f", face.expressions.dimpler);
        NSLog(@"expressions.eyeClosure = %f", face.expressions.eyeClosure);
        NSLog(@"expressions.eyeWiden = %f", face.expressions.eyeWiden);
        NSLog(@"expressions.jawDrop = %f", face.expressions.jawDrop);
        NSLog(@"expressions.lidTighten = %f", face.expressions.lidTighten);
        NSLog(@"expressions.lipCornerDepressor = %f", face.expressions.lipCornerDepressor);
        NSLog(@"expressions.lipPress = %f", face.expressions.lipPress);
        NSLog(@"expressions.lipPucker = %f", face.expressions.lipPucker);
        NSLog(@"expressions.lipStretch = %f", face.expressions.lipStretch);
        NSLog(@"expressions.lipSuck = %f", face.expressions.lipSuck);
        NSLog(@"expressions.mouthOpen = %f", face.expressions.mouthOpen);
        NSLog(@"expressions.noseWrinkle = %f", face.expressions.noseWrinkle);
        NSLog(@"expressions.smile = %f", face.expressions.smile);
        NSLog(@"expressions.upperLipRaise = %f", face.expressions.upperLipRaise);
        

        NSLog(@"facePoints = %@", face.facePoints);
        NSLog(@"userInfo = %lu", (unsigned long)face.userInfo);
        NSLog(@"xmlDescription = %@", face.xmlDescription);
        NSLog(@"jsonDescription = %@", face.jsonDescription);
        NSLog(@"userInfo = %@", face.userInfo);
        NSLog(@"------------------------------------------------------");
        
        //lV.text = face.emotions.valence;
        
        self.lVariance.text = [NSString stringWithFormat: @"%f", face.emotions.valence];
        
        
    }
}
//=================================================================================
// This is a convenience method that is called by the
// detector:hasResults:forImage:atTime: delegate method below.
// It handles all UNPROCESSED images from the detector.
// Here I am displaying those images on the camera view.
- (void)unprocessedImageReady:(AFDXDetector *)detector image:(UIImage *)image atTime:(NSTimeInterval)time;
{
    ViewController * __weak weakSelf = self;
    
    // UI work must be done on the main thread, so dispatch it there.
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.cameraView setImage:image];
    });
}
//=================================================================================
- (void)destroyDetector;
{
    [self.detector stop];
}

- (void)createDetector;
{
    // ensure the detector has stopped
    [self destroyDetector];
    
    // iterate through the capture devices to find the front position camera
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == AVCaptureDevicePositionFront)
        {
            self.detector = [[AFDXDetector alloc] initWithDelegate:self
                                                usingCaptureDevice:device
                                                      maximumFaces:1];
            self.detector.maxProcessRate = 5;
            
            // turn on all classifiers (emotions, expressions, and emojis)
            [self.detector setDetectAllEmotions:YES];
            [self.detector setDetectAllExpressions:YES];
            [self.detector setDetectEmojis:YES];
            
            // turn on gender and glasses
            self.detector.gender = TRUE;
            self.detector.glasses = TRUE;
            
            // start the detector and check for failure
            NSError *error = [self.detector start];
            
            if (nil != error)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Detector Error"
                                                                               message:[error localizedDescription]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                [self presentViewController:alert animated:YES completion:
                 ^{}
                 ];
                
                return;
            }
            
            break;
        }
    }
}
//=================================================================================
#pragma mark -
#pragma mark AFDXDetectorDelegate Methods

- (void)detector:(AFDXDetector *)detector didStartDetectingFace:(AFDXFace *)face;
{
    
}

- (void)detector:(AFDXDetector *)detector didStopDetectingFace:(AFDXFace *)face;
{
    
}
//=================================================================================
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//=================================================================================

// This is the delegate method of the AFDXDetectorDelegate protocol. This method gets called for:
// - Every frame coming in from the camera. In this case, faces is nil
// - Every PROCESSED frame that the detector
- (void)detector:(AFDXDetector *)detector hasResults:(NSMutableDictionary *)faces forImage:(UIImage *)image atTime:(NSTimeInterval)time;
{
    if (nil == faces)
    {
        [self unprocessedImageReady:detector image:image atTime:time];
    }
    else
    {
        [self processedImageReady:detector image:image faces:faces atTime:time];
    }
}

//=================================================================================
#pragma mark -
#pragma mark View Methods

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    [self createDetector]; // create the dector just before the view appears
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    [self destroyDetector]; // destroy the detector before the view disappears
}

//=================================================================================

@end
