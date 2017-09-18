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

@property (nonatomic, copy) NSString *outputVideoPath;//视频路径 不设置将使用默认路径
@property (nonatomic, copy) NSString *outputVideoThumPath;//视频缩略图
@property (nonatomic, copy) NSString *outputImagePath;//拍照图片路径

@property (nonatomic, copy) void(^recordComplete)(NSString * aVideoUrl,NSString *aThumUrl);

@end
