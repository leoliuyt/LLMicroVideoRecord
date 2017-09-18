//
//  LLMicroVideoViewController.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLMicroVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "LLMicroVideoConfig.h"
#import "LLPlayerView.h"
#import "LLPreview.h"
#import "LLCameraController.h"
#import "LLBottomView.h"

@interface LLMicroVideoViewController ()

@property (nonatomic, strong) LLPreview *preview;
@property (nonatomic, strong) LLBottomView *bottomView;
@property (nonatomic, strong) LLPlayerView *playerView;

@property (nonatomic, strong) LLVideoModel *currentRecord;
@property (nonatomic, strong) LLCameraController *cameraController;

@end

@implementation LLMicroVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self setupVideo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.bottomView showBtn];
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)makeUI
{
    [self.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(230);
    }];
    
    WEAKSELF(weakSelf);
    self.bottomView.startRecord = ^(){
        [weakSelf startRecord];
    };
    
    self.bottomView.stopRecord = ^(CFTimeInterval recordTime){
        if (recordTime < 1.) {
            NSLog(@"录制时间太短");
            [weakSelf cleanPath];
            return ;
        }
        [weakSelf.cameraController stopRecordingComplete:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error.localizedDescription);
                return ;
            }
            [weakSelf addPlayerView];
        }];
    };
    
    self.bottomView.sendComplete = ^{
        if (weakSelf.recordComplete) {
            weakSelf.recordComplete(weakSelf.currentRecord.videoAbsolutePath,weakSelf.currentRecord.thumAbsolutePath);
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    self.bottomView.cancelComplete = ^{
        [weakSelf.playerView stop];
        [weakSelf.playerView removeFromSuperview];
        weakSelf.playerView = nil;
        [weakSelf startSession];
        [weakSelf cleanPath];
    };
    self.bottomView.backComplete = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
}

- (void)addPlayerView {
    NSURL *videoURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
    self.playerView = [[LLPlayerView alloc] initWithFrame:[UIScreen mainScreen].bounds videoUrl:videoURL];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.playerView play];
    [self stopSession];
    
    [self.view insertSubview:self.playerView aboveSubview:self.preview];
}

- (void)setupVideo {
    NSString *unUseInfo = nil;
    if (TARGET_IPHONE_SIMULATOR) {
        unUseInfo = @"模拟器不可以的..";
    }
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(videoAuthStatus == AVAuthorizationStatusRestricted || videoAuthStatus == AVAuthorizationStatusDenied){
        unUseInfo = @"相机访问受限...";
    }
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied){
        unUseInfo = @"录音访问受限...";
    }
    
    [self configureSession];
}

- (void)configureSession
{
    NSError *error;
    if ([self.cameraController setupSession:&error]) {
        [self.preview setSession:self.cameraController.captureSession];
        [self startSession];
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}


- (void)cleanPath
{
    if(self.currentRecord.videoAbsolutePath.length > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentRecord.videoAbsolutePath error:nil];
    }
    
    if (self.currentRecord.thumAbsolutePath.length > 0) {
        [[NSFileManager defaultManager] removeItemAtPath:self.currentRecord.thumAbsolutePath error:nil];
    }
}

//开始录制
- (void)startRecord
{
    NSLog(@"视频开始录制");
    self.currentRecord = [LLVideoUtil createNewVideo];
    NSURL *outURL = [NSURL fileURLWithPath:self.currentRecord.videoAbsolutePath];
    self.cameraController.outputURL = outURL;
    [self.cameraController startRecording];
}

// 停止录制
- (void)stopRecord
{
    [self.cameraController stopRecording];
}

- (void)startSession
{
    [self.cameraController startSession];
}

- (void)stopSession
{
    [self.cameraController stopSession];
}

//MARK: getter
- (NSString *)outputVideoPath
{
    if (_outputVideoPath.length > 0) {
        return _outputVideoPath;
    }
    
    //从默认配置中取
    return nil;
}

- (NSString *)outputVideoThumPath
{
    if (_outputVideoThumPath.length > 0) {
        return _outputVideoThumPath;
    }
    
    //从默认配置中取
    return nil;
}

- (NSString *)outputImagePath
{
    if (_outputImagePath.length > 0) {
        return _outputImagePath;
    }
    
    //从默认配置中取
    return nil;
}

//MARK: lazy
- (LLBottomView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[LLBottomView alloc] init];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (LLCameraController *)cameraController
{
    if(!_cameraController){
        _cameraController = [[LLCameraController alloc] init];
    }
    return _cameraController;
}

- (LLPreview *)preview
{
    if(!_preview){
        _preview = [[LLPreview alloc] init];
        [self.view addSubview:_preview];
    }
    return _preview;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end

