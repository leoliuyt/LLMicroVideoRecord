//
//  LLCameraController.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLCameraController.h"
#import <AVFoundation/AVFoundation.h>

@interface LLCameraController()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieOutput;

@property (nonatomic, strong) dispatch_queue_t videoQueue;

@property (nonatomic, copy) void(^didFinishComplete)(NSError *error);

@end
@implementation LLCameraController

- (BOOL)setupSession:(NSError **)error
{
    self.captureSession = [[AVCaptureSession alloc] init];
    
    if([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.captureSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    
    //input
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    
    if (!videoInput) {return NO;}
    if ([self.captureSession canAddInput:videoInput]) {
        [self.captureSession addInput:videoInput];
    }
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
    
    if (!audioDevice) {return NO;}
    if ([self.captureSession canAddInput:audioInput]) {
        [self.captureSession addInput:audioInput];
    }
    
    //output
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    self.imageOutput.outputSettings = @{
                                        AVVideoCodecKey: AVVideoCodecJPEG
                                        };
    if ([self.captureSession canAddOutput:self.imageOutput]) {
        [self.captureSession addOutput:self.imageOutput];
    }
    
    self.movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.captureSession canAddOutput:self.movieOutput]) {
        [self.captureSession addOutput:self.movieOutput];
    }

    self.videoQueue = dispatch_queue_create("com.ll.videoQueue", DISPATCH_QUEUE_SERIAL);
    return YES;
}

- (void)startSession
{
    if (![self.captureSession isRunning]) {
        //在主线程运行 否则画面延时
//        dispatch_async(self.videoQueue, ^{
            [self.captureSession startRunning];
//        });
    }
}

- (void)stopSession
{
    if ([self.captureSession isRunning]) {
        dispatch_async(self.videoQueue, ^{
            [self.captureSession stopRunning];
        });
    }
}

//MARK: Image Capture Methods
- (void)captureStillImage {
    
    AVCaptureConnection *connection =
    [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    
    id handler = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
        if (sampleBuffer != NULL) {
            
            NSData *imageData = [AVCaptureStillImageOutput
             jpegStillImageNSDataRepresentation:sampleBuffer];
            
            UIImage *image = [[UIImage alloc] initWithData:imageData];
//            [self writeImageToAssetsLibrary:image];
            
        } else {
            NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
        }
    };
    // Capture still image
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
                                                  completionHandler:handler];
}

//MARK: Video Capture Methods
- (BOOL)isRecording {                                                       
    return self.movieOutput.isRecording;
}

- (void)startRecording {
    if (![self isRecording]) {
        AVCaptureConnection *videoConnection =                              
        [self.movieOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if ([videoConnection isVideoOrientationSupported]) {                
            videoConnection.videoOrientation = self.currentVideoOrientation;
        }
        
//        //调用这个方法会引起屏幕闪变
//        if ([videoConnection isVideoStabilizationSupported]) {
//            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
//        }
        
        [self.movieOutput startRecordingToOutputFileURL:self.outputURL      
                                      recordingDelegate:self];
    }
}

- (CMTime)recordedDuration {
    return self.movieOutput.recordedDuration;
}

- (void)stopRecording
{
    [self stopRecordingComplete:nil];
}

- (void)stopRecordingComplete:(void(^)(NSError *error))complete {
    self.didFinishComplete = complete;
    if ([self isRecording]) {
        [self.movieOutput stopRecording];
    }
}

- (AVCaptureVideoOrientation)currentVideoOrientation {
    
    AVCaptureVideoOrientation orientation;
    
    switch ([UIDevice currentDevice].orientation) {                         
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
    }
    
    return orientation;
}


//MARK: AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
      fromConnections:(NSArray *)connections
                error:(NSError *)error {
    if (self.didFinishComplete) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.didFinishComplete(error);
        });
    }
}
@end
