//
//  ViewController.h
//  EE002
//
//  Created by vincent youmans on 10/22/16.
//  Copyright © 2016 com.techlatin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Affdex/Affdex.h>


@interface ViewController : UIViewController <AFDXDetectorDelegate>

@property (strong) AFDXDetector *detector;
@property (strong) IBOutlet UIImageView *cameraView;

//@property (strong, nonatomic) IBOutlet UILabel *lblVariance;
@property (strong, nonatomic) IBOutlet UILabel *lVariance;




@end

