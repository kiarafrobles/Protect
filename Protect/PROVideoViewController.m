//
//  PROVideoViewController.m
//  Protect
//
//  Created by Kiara Robles on 12/23/16.
//  Copyright © 2016 Kiara Robles. All rights reserved.
//

#import "PROVideoViewController.h"
#import "UIColor+Extensions.h"

@interface PROVideoViewController ()

@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundColorButtons;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundColorRightConstraint;

@end

@implementation PROVideoViewController

# pragma mark - View Life Cycle Methods

- (void)viewWillAppear:(BOOL)animated
{
    [self setButton:self.videoButton NormalTextColor:[UIColor blackProColor] DisabledTextColor:[UIColor blueProColor]];
    [self setButton:self.audioButton NormalTextColor:[UIColor blueProColor] DisabledTextColor:[UIColor blackProColor]];
    
    [self videoButtonSet];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Capture";
    self.navigationItem.title = @"Video Recording";
    self.backgroundColorButtons.layer.cornerRadius = 3.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

# pragma mark - Button Methods

- (void)videoButtonSet
{
    self.backgroundColorRightConstraint.constant = 16;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    self.videoButton.enabled = YES;
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

- (IBAction)audioPress:(id)sender
{
    self.backgroundColorRightConstraint.constant = (self.view.frame.size.width/2);
    [UIView animateWithDuration:0.25 animations:^{
        self.videoButton.enabled = NO;
        [self.audioButton setTitleColor:[UIColor blackProColor] forState:UIControlStateNormal];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"Audio" sender:self];
    }];
}


@end
