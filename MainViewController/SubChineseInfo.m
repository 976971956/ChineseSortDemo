//
//  SubChineseInfo.m
//  ChineseSortDemo
//
//  Created by lijinhai on 12/24/14.
//  Copyright (c) 2014 gaussli. All rights reserved.
//

#import "SubChineseInfo.h"

@implementation SubChineseInfo
-(NSString *)description{
    return  [NSString stringWithFormat:@"name:%@-num:%@-title:%@",self.name,self.num,self.title];
}
@end
