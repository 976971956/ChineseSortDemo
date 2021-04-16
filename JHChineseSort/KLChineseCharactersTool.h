//
//  KLChineseCharactersTool.h
//  TemplateApp
//
//  Created by Kael on 2019/1/18.
//  Copyright © 2019 LeXue. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, KLCCType) {
    /** 汉字字典匹配 */
    KLCCType_charactersDic = 0,
    /** 汉字GBK编码匹配 */
    KLCCType_GBK = 1,
};

NS_ASSUME_NONNULL_BEGIN


@interface KLChineseCharactersTool : NSObject

+(instancetype)shareInstance;

/** 匹配类型 */
@property (nonatomic, assign) KLCCType ccType;

/** 汉字字符笔画数字典 */
@property (nonatomic, strong) NSDictionary *chineseCharacters;

/** 本地比特数 对应 笔画数组  */
@property (nonatomic, strong) NSArray *bytesArray;

#pragma mark - **************** 工具方法
/**
 是否是纯汉字字符
 
 @param tempStr 字符串
 @return 布尔值结果
 */
+(BOOL)isAllCCString:(NSString *)tempStr;

/**
 获取字符字节数

 @param strtemp 字符串
 @return 字节数
 */
+(int)getCharactCountOfString:(NSString *)strtemp;

#pragma mark - **************** 综合 API
/**
 通过不同方式 获取汉字字符串笔画数

 @param chineseString 汉子字符串
 @param ccType 笔画数 匹配方式
 @return 总笔画数
 */
-(NSInteger)getChineseStrokeCountWith:(NSString *)chineseString ccType:(KLCCType)ccType;

/**
 获取单个汉字笔画数

 @param str 单个汉字 【如果是多个 只取第一个字符】
 @param ccType 笔画数匹配方式
 @return 汉字笔画数
 */
-(NSInteger)getSigleChineseStrokeCountWith:(NSString *)str ccType:(KLCCType)ccType;

#pragma mark - **************** 汉字字典 匹配模式

/**
 汉字字符串笔画总数
 
 @param chineseString 汉字字符串
 @return 笔画总数
 */
-(NSInteger)getChineseStrokeCountWith:(NSString *)chineseString;

/**
 得到单个汉字的笔画数
 
 @param str 汉字字符
 @return 单个汉字笔画数
 */
-(NSInteger)getSigleChineseStrokeCountWith:(NSString *)str;

#pragma mark - **************** 汉字GBK编码 匹配模式

/**
  汉字字符串笔画总数

 @param ccString 汉字字符串
 @return 笔画总数
 */
-(NSInteger)getBytesChineseStrokeCountWith:(NSString *)ccString;

/**
 得到单个汉字的笔画数

 @param ccString 汉字字符
 @return 单个汉字笔画数
 */
-(NSInteger)getBytesSigleChineseStrokeCountWith:(NSString *)ccString;



@end

NS_ASSUME_NONNULL_END
