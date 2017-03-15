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

// 视频的长宽按比例
//#define kVideo_w_h (4.0/2.)
#define kVideo_w_h ([UIScreen mainScreen].bounds.size.width/[UIScreen mainScreen].bounds.size.height)

// 视频默认 宽的分辨率  高 = kVideoWidthPX / kVideo_w_h
//#define kVideoWidthPX  200.0
#define kVideoWidthPX  [UIScreen mainScreen].bounds.size.width

@interface LLMicroVideoConfig : NSObject

+ (CGSize)defualtVideoSize;


@end


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
 *  保存缩略图
 *
 *  @param videoUrl 视频路径
 *  @param second   第几秒的缩略图
 *  @param errorBlock 发生错误时的的回调
 */
+ (void)saveThumImageWithVideoURL:(NSURL *)videoUrl second:(int64_t)second errorBlock:(void(^)(NSError *error))errorBlock;

/*!
 *  产生新的对象
 */
+ (LLVideoModel *)createNewVideo;

/*!
 *  删除视频
 */
+ (void)deleteVideo:(NSString *)videoPath;

/*
 * 视频路径 /cache/artstudio_im_video
 */
+ (NSString *)getVideoPath;

+ (NSString *)getRelativePath:(NSString *)absolutePath;

//重拼绝得路径
+ (NSString *)getAbsolutePath:(NSString *)absolutedPath;

//用视频ID 创建视频绝对路径
+ (NSString *)createAbsolutVideoPath:(NSString *)videoId;

//用图片ID 创建图片绝对路径
+ (NSString *)createAbsolutThumPath:(NSString *)snapshotId;

@end
