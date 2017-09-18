//
//  LLMicroVideoConfig.h
//  LLMicroVideoRecord
//
//  Created by lbq on 2017/3/15.
//  Copyright © 2017年 lbq. All rights reserved.
//

#import <Foundation/Foundation.h>

// 视频保存路径
#define kVideoDicName      @"ll_micro_video"
// 视频录制 时长
#define kRecordTime        11.0

/*!
 *  视频对象 Model类
 */
@interface LLVideoModel : NSObject
/// 完整视频 本地路径
@property (nonatomic, copy) NSString *videoAbsolutePath;
/// 缩略图 路径
@property (nonatomic, copy) NSString *thumAbsolutePath;
/// 完整视频 相对路径
@property (nonatomic, copy) NSString *videoRelativePath;
/// 缩略图 相对路径
@property (nonatomic, copy) NSString *thumRelativePath;
// 录制时间
@property (nonatomic, strong) NSDate *recordTime;

@end

@interface LLVideoUtil : NSObject

/*!
 *  请求麦克风权限
 */
+ (void)requestAuthorizationStatusForAudio:(void(^)(BOOL granted))completeBlock;

/*!
 *  请求相机权限
 */
+ (void)requestAuthorizationStatusForVideo:(void(^)(BOOL granted))completeBlock;

/*!
 *  有视频的存在
 */
+ (BOOL)existVideo;

/*!
 *  产生新的对象
 */
+ (LLVideoModel *)createNewVideo;

@end
