//
//  PROAudioViewController.m
//  Protect
//
//  Created by Kiara Robles on 12/17/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import "PROAudioViewController.h"
#import "UIColor+Extensions.h"
#import "NSFileManager+PS.h"

@interface PROAudioViewController ()

@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorButtons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundColorRightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *buttonDone;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecord;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *recordingTimer;

@end

@implementation PROAudioViewController


# pragma mark - View Life Cycle Methods

- (void)viewWillAppear:(BOOL)animated
{
    [self setButton:self.audioButton NormalTextColor:[UIColor blackProColor] DisabledTextColor:[UIColor blueProColor]];
    [self setButton:self.videoButton NormalTextColor:[UIColor blueProColor] DisabledTextColor:[UIColor blackProColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Capture";
    self.navigationItem.title = @"Audio Recording";
    self.backgroundColorButtons.layer.cornerRadius = 3.0;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Button Methods

- (void)videoButtonSet
{
    self.backgroundColorRightConstraint.constant = (self.view.frame.size.width/2);
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.audioButton.enabled = YES;
}

- (void)setButton:(UIButton *)button NormalTextColor:(UIColor *)colorNormal DisabledTextColor:(UIColor *)colorDisabled
{
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [[UIColor blueProColor] CGColor];
    button.layer.cornerRadius = 3.0;
    [button setTitleColor:colorNormal forState:UIControlStateNormal];
    [button setTitleColor:colorDisabled forState:UIControlStateDisabled];
}

# pragma mark - Actions Methods

- (IBAction)videoPress:(id)sender
{
    self.backgroundColorRightConstraint.constant = (self.view.frame.size.width/2);
    [UIView animateWithDuration:0.25 animations:^{
        self.audioButton.enabled = NO;
        [self.videoButton setTitleColor:[UIColor blackProColor] forState:UIControlStateNormal];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (IBAction)doneTap:(id)sender
{
    [NSFileManager moveAllFilesinDirectory];
}


# pragma mark - Record Fuction Methods

- (IBAction)recordTap:(UIButton *)sender
{
    if (sender.selected) {
        // stop
        
        NSArray *files = [[NSFileManager defaultManager] listFilesAtPath:NSTemporaryDirectory()];
        NSLog(@"tmp files: %@", files);
        
        [self.recorder stop];
        self.buttonDone.enabled = YES;
        [self.recordingTimer invalidate];
        self.recordingTimer = nil;
        NSLog(@"%@", self.recorder.url.absoluteString);
        
    } else {
        // start
        
        self.buttonDone.enabled = NO;
        //        NSURL *tmp = [NS]
        
        if (self.recorderSettings == nil) {
            self.recorderSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                     [NSNumber numberWithInt:44100.0],AVSampleRateKey,
                                     [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                                     [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                                     [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                                     [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                     nil];
        }
        if (self.fileExtension == nil) {
            self.fileExtension = @"caf";
        }
        
        NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString] ;
        NSString *uniqueFileName = [NSString stringWithFormat:@"%@.%@", guid, self.fileExtension];
        NSError* error = nil;
        self.recorder = [[AVAudioRecorder alloc]
                         initWithURL:[NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:uniqueFileName]]
                         settings:self.recorderSettings
                         error:&error];
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&setCategoryError]) {
            // handle error
            NSLog(@"Failed to setup audio session %@", setCategoryError.description);
            return;
        }
        
        self.recorder.delegate = self;
        [self.recorder record];
        self.recordingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordingTimerUpdate:) userInfo:nil repeats:YES];
        [self.recordingTimer fire];
    }
    sender.selected = !sender.selected;
    
}

- (void)playTap:(UIButton *)sender
{
    //    [SimpleAudioPlayer playFile:_recorder.url.description];
    NSError* error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:&error];
    self.player.volume = 1.0f;
    self.player.numberOfLoops = 0;
    self.player.delegate = self;
    [self.player play];
    NSLog(@"duration: %f", self.player.duration);
}

- (void)recordingTimerUpdate:(id)sender
{
    NSString *timeString = [self stringFromTimeInterval:self.recorder.currentTime];
    self.labelTime.text = timeString;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"did finish playing %d", flag);
}

# pragma mark - Helper Methods

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
