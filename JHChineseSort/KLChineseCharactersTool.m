//
//  KLChineseCharactersTool.m
//  TemplateApp
//
//  Created by Kael on 2019/1/18.
//  Copyright © 2019 LeXue. All rights reserved.
//

#import "KLChineseCharactersTool.h"

static KLChineseCharactersTool *_ccTool = nil;

@implementation KLChineseCharactersTool

#pragma mark - **************** init
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ccTool = [[KLChineseCharactersTool alloc] init];
    });
    return _ccTool;
}

#pragma mark - **************** getter
-(NSDictionary *)chineseCharacters{
    if (!_chineseCharacters) {
        _chineseCharacters = [[NSDictionary alloc] init];
        _chineseCharacters = [self readLocalJsonFileWithName:@"Chinese" type:@"json"];
    }
    return _chineseCharacters;
}
- (NSArray *)bytesArray{
    if (!_bytesArray) {
        _bytesArray = [[NSArray alloc] init];
        _bytesArray = [self readLocalJsonFileWithName:@"byteNum" type:@"json"];
    }
    return _bytesArray;
}


#pragma mark - **************** Tool function
/** 读取本地文件 */
-(nullable id)readLocalJsonFileWithName:(NSString *)fileName type:(NSString *)type{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
+(BOOL)isAllCCString:(NSString *)tempStr{
    for (int i=0; i<tempStr.length; i++) {
        NSString *indexstr = [tempStr substringWithRange:NSMakeRange(i, 1)];
        NSInteger strlength = [KLChineseCharactersTool getCharactCountOfString:indexstr];
        if (strlength != 2) {
            return NO;
        }
        
    }
    return YES;
}
#pragma mark - **************** 总的方法
-(NSInteger)getChineseStrokeCountWith:(NSString *)chineseString ccType:(KLCCType)ccType{
    if (KLCCType_charactersDic) {
        return [self getChineseStrokeCountWith:chineseString];
    }
    if (KLCCType_GBK) {
        return [self getBytesChineseStrokeCountWith:chineseString];
    }
    return 0;
}

-(NSInteger)getSigleChineseStrokeCountWith:(NSString *)str ccType:(KLCCType)ccType{
    if (KLCCType_charactersDic) {
        return [self getSigleChineseStrokeCountWith:str];
    }
    if (KLCCType_GBK) {
        return [self getBytesSigleChineseStrokeCountWith:str];
    }
    return 0;
}

#pragma mark - **************** 汉子列表匹配法
-(BOOL)isBlankString:(NSString *)string{
    
    if (string ==nil || string ==NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]length]==0) {//特殊字符判断
        return YES;
    }
    return NO;
}

-(NSInteger)getSigleChineseStrokeCountWith:(NSString *)str{
    NSInteger count = 0;
    
    BOOL isALLCC = [[self class] isAllCCString:str];
    if (!isALLCC) {
        // 如果不是纯汉字返回笔画数为0
        return 0;
    }
    
    // 单字符判断
    if (str.length<=0) {
        NSLog(@"字符串不合法");
        return 0;
    }
    
    // 多字符 取第一个字符判断
    NSString *sigleStr = @"";
    if (str.length > 1) {
        NSLog(@"并非单个字符");
        sigleStr = [str substringWithRange:NSMakeRange(0, 1)];
    }
    
    if (str.length == 1) {
        sigleStr = str;
    }
    
    
    // 获取笔划列表
    NSDictionary *chineseDic = self.chineseCharacters;
    
    // 查询
    for (int i=0; i<25; i++) {
        // 按次序获取某个笔划数的所有汉字组成的字符
        NSString *itemString = [chineseDic objectForKey:[NSString stringWithFormat:@"%d",(i+1)]];
        //如果 传入汉字不为空 异常判断
        if (![self isBlankString:itemString] && itemString.length > 0 ) {
            // 包含这个汉字 将笔画数 i+1 返回
            if ([itemString rangeOfString:sigleStr].location != NSNotFound) {
//                NSLog(@"汉字：%@  ------ 笔画数：%d",sigleStr,i+1);
                count = count + (i+1);
                break;
            }
        }
        
    }
    
    if (count == 0) {
        NSLog(@"字库中暂时没有该汉字");
    }
    
    return count;
}

-(NSInteger)getChineseStrokeCountWith:(NSString *)chineseString{
    NSInteger count = 0;
    
    // 单个汉字？
    if (chineseString.length == 1 ) {
        return [self getSigleChineseStrokeCountWith:chineseString];
    }
    
    // 多汉字
    // 获取笔划列表
    
    for (int i=0; i<chineseString.length; i++) {
        // 将传入字符分割成单个字
        NSString *indexStr = [chineseString substringWithRange:NSMakeRange(i, 1)];
        NSInteger sigleCount = [self getSigleChineseStrokeCountWith:indexStr];
        count = count + sigleCount;
    }
    
    NSLog(@"%@  --- 共计：%ld划",chineseString ,(long)count);
    
    return count;
}


#pragma mark - **************** BGBK汉字编码 匹配
+(int)getCharactCountOfString:(NSString *)strtemp{
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}



-(NSInteger)getStrokeCountWithHighByte:(int)highByte lowByte:(int)lowByte{
    NSInteger strokeCount = 0;
    //high: 176 - 247       low: 161 - 154  该范围才是汉子区域
    if (highByte < 0xB0 || highByte > 0xF7 || lowByte < 0xA1 || lowByte > 0xFE) {
        // 非GB2312合法字符
        return 0;
    }else{
        int offset = (highByte - 0xB0) * (0xFE - 0xA0) + (lowByte - 0xA1);
        NSArray *byteArr = self.bytesArray;
        strokeCount = ((NSNumber *)[byteArr objectAtIndex:offset]).intValue;
        return strokeCount;
    }
    return strokeCount;
}


-(NSInteger)getBytesChineseStrokeCountWith:(NSString *)ccString{
    NSInteger count = 0;
    
    // 单个汉字？
    if (ccString.length == 1 ) {
        return [self getBytesSigleChineseStrokeCountWith:ccString];
    }
    
    for (int i=0; i<ccString.length; i++) {
        
        NSString *indexstr = [ccString substringWithRange:NSMakeRange(i, 1)];
        
        NSInteger strlength = [KLChineseCharactersTool getCharactCountOfString:indexstr];
        
        if (strlength!=2) {
            NSLog(@"kael --  字符 不合法 %@",indexstr);
            break;
        }
        
        if (strlength == 2) {
            count = count + [self getBytesSigleChineseStrokeCountWith:indexstr];
        }
        
        
    }
    
    return count;
}

-(NSInteger)getBytesSigleChineseStrokeCountWith:(NSString *)ccString{
    NSInteger count = 0;
    // 1、先判断是否是汉字
    BOOL isALLCC = [[self class] isAllCCString:ccString];
    if (!isALLCC) {
        // 如果不是纯汉字返回笔画数为0
        return 0;
    }
    
    // 2、判断字符个数
    // 不合法
    if (ccString.length<=0) {
        NSLog(@"字符串不合法");
        return 0;
    }
    
    // 多字符 取第一个字符判断
    NSString *sigleStr = @"";
    if (ccString.length > 1) {
        NSLog(@"并非单个字符");
        sigleStr = [ccString substringWithRange:NSMakeRange(0, 1)];
    }
    
    // 单字符判断
    if (ccString.length == 1) {
        sigleStr = ccString;
    }
    
    
    NSInteger strlength = [KLChineseCharactersTool getCharactCountOfString:sigleStr];
    
    if (strlength!=2) {
        NSLog(@"kael --  字符 不合法 %@",ccString);
        return 0;
    }else{
        // BGK 编码 --> 转为 NSData
        NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *indexData = [ccString dataUsingEncoding:enc];
        // NSData --> Bytes
        Byte *indexByte = (Byte *)[indexData bytes];
        // 取高8位 低8位
        int highByte = indexByte[0];
        int lowByte = indexByte[1];
        
        count = [self getStrokeCountWithHighByte:highByte lowByte:lowByte];
//        NSLog(@"汉字：%@ ------ 笔画数：%ld",sigleStr,count);
        
    }
    
    return count;
}


@end
