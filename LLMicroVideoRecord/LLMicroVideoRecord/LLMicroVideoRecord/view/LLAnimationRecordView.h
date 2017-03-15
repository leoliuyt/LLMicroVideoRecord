//
//  LLAnimationRecordView.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAnimationRecordView : UIView

@property (nonatomic, copy) void(^startRecord)();
@property (nonatomic, copy) void(^completeRecord)(CFTimeInterval recordTime); //录制时长

@end
