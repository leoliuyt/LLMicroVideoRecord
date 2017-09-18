//
//  LLMicroVideoConfig.m
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import "LLMicroVideoConfig.h"
#import <AVFoundation/AVFoundation.h>

@implementation LLVideoModel

@end

@implementation LLVideoUtil

+ (BOOL)existVideo {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *nameList = [fileManager subpathsAtPath:[self getVideoPath]];
    return nameList.count > 0;
}

+ (void)requestAuthorizationStatusForAudio:(void(^)(BOOL granted))completeBlock
{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (audioStatus == 	AVAuthorizationStatusRestricted || audioStatus == AVAuthorizationStatusDenied)
        {
            // 没有权限
            NSLog(@"没有麦克风权限");
            if (completeBlock) {
                completeBlock(NO);
            }
            return;
        }
        
        if (audioStatus == AVAuthorizationStatusNotDetermined)
        {
            //请求麦克风权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock) {
                        completeBlock(granted);
                    }
                });
            }];
            return;
        }
        
        if (completeBlock) {
            completeBlock(YES);
        }
    }
}

+ (void)requestAuthorizationStatusForVideo:(void(^)(BOOL granted))completeBlock
{
    if ([[AVCaptureDevice class] respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (videoStatus == 	AVAuthorizationStatusRestricted || videoStatus == AVAuthorizationStatusDenied)
        {
            // 没有权限
            NSLog(@"没有相机权限");
            if (completeBlock) {
                completeBlock(NO);
            }
            return;
        }
        
        if (videoStatus == AVAuthorizationStatusNotDetermined)
        {
            //请求相机权限
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completeBlock) {
                        completeBlock(granted);
                    }
                });
            }];
            return;
        }
        
        if (completeBlock) {
            completeBlock(YES);
        }
    }
}

+ (LLVideoModel *)createNewVideo {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateFormat = @"yyyy-MM-dd_HH:mm:ss";
    NSString *videoName = [[formate stringFromDate:currentDate] MD5String];
    NSString *videoPath = [self getVideoPath];
    
    LLVideoModel *model = [[LLVideoModel alloc] init];
    model.videoRelativePath = [NSString stringWithFormat:@"%@.mp4",videoName];
    model.thumRelativePath = [NSString stringWithFormat:@"%@.JPG",videoName];
    
    model.videoAbsolutePath = [videoPath stringByAppendingPathComponent:model.videoRelativePath];
    model.thumAbsolutePath = [videoPath stringByAppendingPathComponent:model.thumRelativePath];
    
    return model;
}

+ (NSString *)getVideoPath {
    return [self getCacheSubPath:kVideoDicName];
}

+ (NSString *)getCacheSubPath:(NSString *)dirName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:dirName];
}

+ (void)initialize {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *dirPath = [self getVideoPath];
    
    NSError *error = nil;
    [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        NSLog(@"创建文件夹失败:%@",error);
    }
}

@end

