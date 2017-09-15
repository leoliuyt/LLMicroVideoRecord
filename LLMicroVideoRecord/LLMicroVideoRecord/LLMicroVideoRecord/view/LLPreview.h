//
//  LLPreview.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVCaptureSession;

@interface LLPreview : UIView

@property (nonatomic, strong) AVCaptureSession *session;

@end
