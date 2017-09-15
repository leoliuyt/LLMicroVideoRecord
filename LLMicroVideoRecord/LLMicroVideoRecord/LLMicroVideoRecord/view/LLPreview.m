//
//  LLPreview.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLPreview.h"
#import <AVFoundation/AVFoundation.h>

@interface LLPreview()

@end

@implementation LLPreview

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (void)setSession:(AVCaptureSession *)session
{
    [(AVCaptureVideoPreviewLayer*)self.layer setSession:session];
}

- (AVCaptureSession *)session
{
    return [(AVCaptureVideoPreviewLayer *)self.layer session];
}

@end
