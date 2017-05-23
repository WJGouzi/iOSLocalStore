//
//  wjDog.m
//  iOS中本地存储的方式
//
//  Created by gouzi on 2017/5/23.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjDog.h"

@implementation wjDog

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
}




/**
 当要解析一个文件的时候进行调用
 相对于-awakeFromNib方法先调用---这个是从xib加载完成后进行调用。
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    // 当类只有遵守了NSCoding协议时，才会有[super initWithCoder:]方法
    // 但是NSObjec是没有遵守的，所没有[super initWithCoder:]方法
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
