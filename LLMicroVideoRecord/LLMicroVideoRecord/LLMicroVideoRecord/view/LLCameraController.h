//
//  LLCameraController.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVCaptureSession;

@interface LLCameraController : NSObject


@property (nonatomic, copy) NSURL *outputURL;
@property (nonatomic, strong, readonly) AVCaptureSession *captureSession;


- (BOOL)setupSession:(NSError *__autoreleasing*)error;

- (void)startSession;
- (void)stopSession;
- (void)startRecording;
- (void)stopRecording;
- (void)stopRecordingComplete:(void(^)(NSError *error))complete;

@end
