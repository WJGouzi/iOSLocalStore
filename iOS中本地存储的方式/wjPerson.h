//
//  wjPerson.h
//  iOS中本地存储的方式
//
//  Created by gouzi on 2017/5/23.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@class wjDog;
@interface wjPerson : NSObject <NSCoding>

/** name*/
@property (nonatomic, copy) NSString *name;

/** age*/
@property (nonatomic, assign) NSInteger age;

/** dog*/
@property (nonatomic, strong) wjDog *dog;

@end
