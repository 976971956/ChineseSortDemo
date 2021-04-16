//
//  JHChineseSort.m
//  ChineseSortDemo
//
//  Created by lijinhai on 12/24/14.
//  Copyright (c) 2014 gaussli. All rights reserved.
//

#import "JHChineseSort.h"
#import "JHChineseInfo.h"
#import "KLChineseCharactersTool.h"
@implementation JHChineseSort

// 中文字符串转换成拼音
- (NSString*) chineseStringTransformPinyin: (NSString*)chineseString {
    if (chineseString == nil) {
        return nil;
    }
    // 拼音字段
    NSMutableString *tempNamePinyin = [chineseString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return tempNamePinyin.uppercaseString;
}

// 对中文字符串数组进行排序
- (NSArray*) chineseSortWithStringArray: (NSArray*)stringArray {
    if (stringArray == nil) {
        return nil;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [stringArray count] ; i++) {
        if (![[stringArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            return nil;
        }
        JHChineseInfo *model = [[JHChineseInfo alloc]init];
        model.name = [stringArray objectAtIndex:i];
        [tempArray addObject:model];
    }
    NSArray *newArray = [self chineseSortWithObjectArray:tempArray];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];

    for (JHChineseInfo *model in newArray) {
        [resultArray addObject:model.name];
    }
    return resultArray;
}

// 对包含中文字符串字段的字典数组进行排序
- (NSArray*) chineseSortWithDictionaryArray: (NSArray*)dictionaryArray andFieldKey: (NSString*)fieldKey {
    if (dictionaryArray == nil) {
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [dictionaryArray count] ; i++) {
        if (![[dictionaryArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        JHChineseInfo *model = [[JHChineseInfo alloc]init];
        model.name = [dictionaryArray objectAtIndex:i][fieldKey];
        model.num = [dictionaryArray objectAtIndex:i][@"num"];
        [tempArray addObject:model];
    }
    NSArray *newArray = [self chineseSortWithObjectArray:tempArray];

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (JHChineseInfo *model in newArray) {
        NSDictionary *dic = @{fieldKey:model.name,@"num":model.num};
        [resultArray addObject:dic];
    }
    return resultArray;
}

// 对JHChineseInfo子类对象的数组进行排序
- (NSArray*) chineseSortWithObjectArray: (NSArray*)objectArray {
    if (objectArray == nil) {
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [objectArray count] ; i++) {
        if (![[objectArray objectAtIndex:i] isKindOfClass:[JHChineseInfo class]]) {
            return nil;
        }
        JHChineseInfo *model = objectArray[i];
        NSString *firstName = [model.name substringToIndex:1];
        NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[objectArray objectAtIndex:i], @"info", [self chineseStringTransformPinyin:firstName], @"pinyin", nil];
        [tempArray addObject:tempDic];
    }

    
    

    NSMutableArray *newArray = [self paixuArr:tempArray];

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary *tempDic in newArray) {
        [resultArray addObject:[tempDic objectForKey:@"info"]];
    }
    return resultArray;
}

- (NSMutableArray *)paixuArr:(NSArray *)tempArray{
//    同音姓分组
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [tempArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *eachCitySiteArr = [NSMutableArray array];
        [tempArray enumerateObjectsUsingBlock:^(id _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if([tempArray[idx1][@"pinyin"] isEqualToString:tempArray[idx][@"pinyin"]]) {
                [eachCitySiteArr addObject:tempArray[idx1]];
            }
        }];
        [dic setObject:eachCitySiteArr forKey:tempArray[idx][@"pinyin"]];
    }];
    
//    判断同音姓中文分组
    NSMutableDictionary *dicNew = [[NSMutableDictionary alloc] init];
    for (NSString *key in dic) {
        NSArray *arr = [dic objectForKey:key];
        [dicNew setObject:[self paixuArr1:arr] forKey:key];
    }
    
//    全部输出到一个新数组
    
    
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSString *key in dicNew) {
        NSArray *arrNews = [dicNew objectForKey:key];
        
        for (NSArray *arr in arrNews) {
            
//            NSArray *arr = [dicNews objectForKey:newKey];
            for (NSDictionary *newKeys in arr) {
                [newArray addObject:newKeys];
            }
        }
    }
//    NSMutableArray *newArray = [NSMutableArray array];
//    for (NSString *key in dicNew) {
//        NSDictionary *dicNews = [dicNew objectForKey:key];
//        for (NSString *newKey in dicNews) {
//            NSArray *arr = [dicNews objectForKey:newKey];
//            for (NSDictionary *newKeys in arr) {
//                [newArray addObject:newKeys];
//            }
//        }
//    }
    // 排序
    [newArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"pinyin"] compare:[obj2 objectForKey:@"pinyin"]];
    }];
    return newArray;
}
- (NSMutableArray *)paixuArr1:(NSArray *)tempArray{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    [tempArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSMutableArray *eachCitySiteArr = [NSMutableArray array];
        JHChineseInfo *model2 =  tempArray[idx][@"info"];
        NSString *firstName2 = [model2.name substringToIndex:1];
        [tempArray enumerateObjectsUsingBlock:^(id _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            JHChineseInfo *model1 =  tempArray[idx1][@"info"];
            NSString *firstName1 = [model1.name substringToIndex:1];
            if([firstName1 isEqualToString:firstName2]) {
                [eachCitySiteArr addObject:tempArray[idx1]];
            }
        }];
        
        // 排序
        [eachCitySiteArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [[self chineseStringTransformPinyin:((JHChineseInfo *)[obj1 objectForKey:@"info"]).name] compare:[self chineseStringTransformPinyin:((JHChineseInfo *)[obj2 objectForKey:@"info"]).name]];
        }];
        [dic setObject:eachCitySiteArr forKey:firstName2];
    }];
    NSMutableArray *sameArray = [NSMutableArray array];
    for (NSString *key in dic) {
        [sameArray addObject:dic[key]];
    }
    [sameArray sortUsingComparator:^NSComparisonResult(NSArray *obj1, NSArray * obj2) {
        NSInteger model1Count = 0;
        NSInteger model2Count = 0;
        if (obj1.count > 0) {


          NSDictionary *dic1 =  obj1.firstObject;
            JHChineseInfo *model1 = dic1[@"info"];
            model1Count = [[KLChineseCharactersTool shareInstance] getSigleChineseStrokeCountWith:[model1.name substringToIndex:1]];
        }
        if (obj2.count > 0) {
            NSDictionary *dic2 =  obj2.firstObject;
            JHChineseInfo *model2 = dic2[@"info"];
            model2Count = [[KLChineseCharactersTool shareInstance] getSigleChineseStrokeCountWith:[model2.name substringToIndex:1]];

        }
        return model1Count > model2Count;
    }];
    return sameArray;
}
@end
