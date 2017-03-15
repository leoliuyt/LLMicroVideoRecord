//
//  LLMicroVideoViewController.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLMicroVideoViewController : UIViewController

@property (nonatomic, assign) BOOL savePhotoAlbum;

@property (nonatomic, copy) void(^recordComplete)(NSString * aVideoUrl,NSString *aThumUrl);

@end
