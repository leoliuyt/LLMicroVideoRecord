//
//  LLBottomView.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/9/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLBottomView : UIView

@property (nonatomic, copy) void(^startRecord)();
@property (nonatomic, copy) void(^stopRecord)(CFTimeInterval recordTime);
@property (nonatomic, copy) void(^sendComplete)();
@property (nonatomic, copy) void(^cancelComplete)();
@property (nonatomic, copy) void(^backComplete)();

- (void)showBtn;
@end
