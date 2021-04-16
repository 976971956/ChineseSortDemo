//
//  MainViewController.m
//  ChineseSortDemo
//
//  Created by lijinhai on 12/24/14.
//  Copyright (c) 2014 gaussli. All rights reserved.
//

#import "MainViewController.h"
#import "JHChineseSort.h"
#import "JHChineseInfo.h"
#import "SubChineseInfo.h"
#import "KLChineseCharactersTool.h"
#import "NSArray+Log.h"


#ifdef DEBUG

#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else

#define SLog(format, ...)

#endif

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    中文字符排序规则：
//    1.按中文名字拼音大小进行排序
//    2.姓同音字进行笔画排序
    JHChineseSort *chineseSort = [[JHChineseSort alloc] init];
    
    // 测试对中文字符串数组排序
    NSArray *a1 = @[@"张三", @"李三", @"li三", @"qeri三", @"rei三", @"lbcx三", @"kjh三", @"照三", @"于三", @"破三", @"梁三"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *a = [chineseSort chineseSortWithStringArray:a1];
        NSLog(@"排序结果1: %@", a);

    });
    
    // 测试对包含中文字符串字段的字典数组排序
    NSArray *a2 = @[
      @{@"name":@"张三", @"num":@"1"},
      @{@"name":@"李三", @"num":@"2"},
      @{@"name":@"li三", @"num":@"3"},
      @{@"name":@"qeri三", @"num":@"4"},
      @{@"name":@"rei三", @"num":@"5"},
      @{@"name":@"lbcx三", @"num":@"6"},
      @{@"name":@"kjh三", @"num":@"7"},
      @{@"name":@"照三", @"num":@"8"},
      @{@"name":@"于三", @"num":@"9"},
      @{@"name":@"破三", @"num":@"10"},
      @{@"name":@"梁三", @"num":@"11"}];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSArray *arr = [chineseSort chineseSortWithDictionaryArray:a2 andFieldKey:@"name"];
            NSLog(@"排序结果2: %@",arr);
        });
    // 测试对JHChineseInfo为元素的数组排序
    JHChineseInfo *ci1 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci2 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci3 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci4 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci5 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci6 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci7 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci8 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci9 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci10 = [[JHChineseInfo alloc] init];
    JHChineseInfo *ci11 = [[JHChineseInfo alloc] init];
    ci1.name = @"张三";
    ci2.name = @"李三";
    ci3.name = @"li三";
    ci4.name = @"qeri三";
    ci5.name = @"rei三";
    ci6.name = @"lbcx三";
    ci7.name = @"kjh三";
    ci8.name = @"照三";
    ci9.name = @"于三";
    ci10.name = @"破三";
    ci11.name = @"梁三";
    NSArray *a3 = @[ci1, ci2, ci3, ci4, ci5, ci6, ci7, ci8, ci9, ci10, ci11];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

       NSArray *a = [chineseSort chineseSortWithObjectArray:a3];
        NSLog(@"排序结果3：%@", a);

    });
    
    // 测试对JHChineseInfo的子类为元素的数组排序
    SubChineseInfo *sci1 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci2 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci3 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci4 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci5 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci6 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci7 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci8 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci9 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci10 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci11 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci12 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci13 = [[SubChineseInfo alloc] init];
    SubChineseInfo *sci14 = [[SubChineseInfo alloc] init];
    sci1.name = @"张锋";
    sci1.num = @"1";
    sci1.title = @"江湖";
    sci2.name = @"李三";
    sci2.num = @"2";
    sci3.name = @"章八九";
    sci3.num = @"3";
    sci4.name = @"张金";
    sci4.num = @"4";
    sci5.name = @"张航";
    sci5.num = @"5";
    sci6.name = @"章三";
    sci6.num = @"6";
    sci7.name = @"阿三";
    sci7.num = @"7";
    sci8.name = @"照三";
    sci8.num = @"8";
    sci9.name = @"于三";
    sci9.num = @"9";
    sci10.name = @"破三";
    sci10.num = @"10";
    sci11.name = @"梁三";
    sci11.num = @"11";
    sci12.name = @"彰三";
    sci12.num = @"12";
    sci13.name = @"瘬三";
    sci13.num = @"13";
    sci14.name = @"瘬疯";
    sci14.num = @"14";
    NSArray *a4 = @[sci1, sci2, sci3, sci4, sci5, sci6, sci7, sci8, sci9, sci10, sci11,sci12,sci13,sci14];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

       NSArray  *a = [chineseSort chineseSortWithObjectArray:a4];
        NSLog(@"排序结果4：%@",a);
    });
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
