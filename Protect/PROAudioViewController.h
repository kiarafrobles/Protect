//
//  PROAudioViewController.h
//  Protect
//
//  Created by Kiara Robles on 12/17/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface PROAudioViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic) NSDictionary *recorderSettings;
@property (nonatomic) NSString *fileExtension;

@end
