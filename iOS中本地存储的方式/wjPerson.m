//
//  wjPerson.m
//  iOS中本地存储的方式
//
//  Created by gouzi on 2017/5/23.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjPerson.h"

@implementation wjPerson


// 归档
/**
 * 在保存对象之前就要告诉保存当前对象的那些属性
 
 */
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    // 这里存储的时候也要告知dog中有哪些属性是需要去存储的，所以也要去重写encodeWithCoder方法
    [aCoder encodeObject:self.dog forKey:@"dog"];
}


// 解归档

/**
 当要解析一个文件的时候进行调用
 告诉当前要解析文件中的那些属性
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntForKey:@"age"];
        // 这里解析dog的时候也是需要去重写dog的initWithCoder方法
        self.dog = [aDecoder decodeObjectForKey:@"dog"];
    }
    return self;
}


@end
