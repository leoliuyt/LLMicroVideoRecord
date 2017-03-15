//
//  ViewController.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "ViewController.h"
#import "LLMicroVideoViewController.h"
#import "LLMicroVideoConfig.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *playView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)enterAction:(id)sender {
    WEAKSELF(weakSelf);
    [LLVideoUtil requestAuthorizationStatusForVideo:^(BOOL granded){
        if (granded) {
            [LLVideoUtil requestAuthorizationStatusForAudio:^(BOOL granted) {
                if (granted) {
                    LLMicroVideoViewController *vc = [[LLMicroVideoViewController alloc] init];
                    vc.recordComplete = ^(NSString * aVideoUrl,NSString *aThumUrl) {
                        [weakSelf playAVPlayer:aVideoUrl];
                    };
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                } else {
                    NSLog(@"---没有麦克风权限");
                }
            }];
        } else {
            NSLog(@"---没有相机权限");
        }
    }];
}

- (void)playAVPlayer:(NSString *)aUrl
{
    NSURL *url = [NSURL fileURLWithPath:aUrl];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithURL:url];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playItem];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
    layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.playView.frame), CGRectGetHeight(self.playView.frame));
    // 显示播放视频的视图层要添加到self.view的视图层上面
    [self.playView.layer addSublayer:layer];
    
    [player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
