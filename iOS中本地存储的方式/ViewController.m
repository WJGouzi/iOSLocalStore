//
//  ViewController.m
//  iOS中本地存储的方式
//
//  Created by gouzi on 2017/5/23.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ViewController.h"
#import "wjPerson.h"
#import "wjDog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - plist 方式进行存储读取
- (IBAction)plistSave:(UIButton *)sender {
    NSArray *dataArray = @[@"wj", @10]; // 不仅是数组，字典一样的可以写入到plist文件中去
    // 设置plist文件保存的路径
    /*
     *参数1:搜索的目录-->现在这个路径是在沙盒中的Document文件夹,存在沙盒的其他目录中也是可以的。
     *参数2:搜索范围
     *参数3:是否展开路径 iOS不识别这个 `~`,所以路径必须获取全路径，设置值要为YES
     */
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSLog(@"plist save path is : %@", path);
    // 创建plist文件，并且拼接处全路径。
    NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
    // 写入到文件中
    [dataArray writeToFile:filePath atomically:YES];
}

- (IBAction)plistRead:(UIButton *)sender {
    // 要读取plist文件,需要知晓plist文件的路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"data.plist"];
    // plist文件中是数组 所以用数组接收
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"read plist file is %@", dataArray);
}



#pragma mark - user defaults 存储读取
- (IBAction)userDefaultsSave:(UIButton *)sender {
    // user defaults中存储的类型也是plist文件
    // 相当于是单例，在全局中，这个方法就能拿到唯一的一个NSUserDefaults ->因此许多的工程中对于偏好设置都采用的是NSUserDefaults方式进行存储。
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"wj" forKey:@"name"]; // 字符串类型
    [defaults setInteger:10 forKey:@"size"];   // integer类型
    [defaults setBool:YES forKey:@"male"];     // bool类型
    // 立即同步，如果不执行这一步，其实也是可以的，只不过系统会在一个不确定的时间点把这些数据存入到本地中。
    // 所以为了数据安全，需要马上同步保存一下
    [defaults synchronize];
    // 自动保存到 ~library/Preferences/xxx.plist -> 而且文件的命名的规则是以工程名为名字的plist文件。
    NSLog(@"userDefaults save path is : %@", NSHomeDirectory());
    
}


- (IBAction)userDefaultsRead:(UIButton *)sender {
    // 取出 userDefaults 对象 -> 这一步可以在任何地方都能取得到
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 我们存的是什么类型的数据，就用什么类型的数据进行接收
    // 如果我们取出的时候类型不匹配，系统会提示错误
    NSString *name = [defaults objectForKey:@"name"];
    NSInteger size = [defaults integerForKey:@"size"];
    BOOL isMale = [defaults boolForKey:@"male"];
    NSLog(@"name is %@--size is %ld--is male %d", name, size, isMale);
}

#pragma mark - notice
/*
 *  对于plist文件存储和userdefaults存储方式，其基本的存储的格式都是plist文件。
 *  而在plist文件中存储的数据也基本是OC的基本数据类型。
 *  plist文件中可以存储的是数字，字典等类型。
 *  但是plist文件中就不能对对象进行存储。所以当我们想存储对象的时候，就不能使用plist存储和userdefaults方式了。
 *
 *  iOS中又提供了归档的方式进行存储，他可以把想要归档的对象放到沙盒中，并且在任何位置都可以取到。
 *
 */


#pragma mark - 归档方式进行存储读取
- (IBAction)archiverSave:(UIButton *)sender {
    // 创建归档对象 -> 对象的属性中暂时不包含其他的对象
    wjPerson *person = [[wjPerson alloc] init];
    // 要归档的属性可以包含一部分，也可以全部包含
    person.name = @"wj";
    person.age = 26;
    // 所归档的对象中包含着另一个对象
    wjDog *dog = [[wjDog alloc] init];
    dog.name = @"dahuang";
    person.dog = dog;
    
    // 归档文件也是存在沙盒中的
    // 我们这里可以存在temp目录中
    NSString *path = NSTemporaryDirectory();
    NSLog(@"archiver path is %@", path);
    // 这个文件的后缀名是.data -> 这样做可以有效的保护数据，防止别人暴力破解。
    // 后缀名的命名是随意的。
    NSString *filePath = [path stringByAppendingPathComponent:@"person.data"];
    // 归档
    // archiveRootObject会调用encodeWithCoder 方法
    // -> 如果不在person中重写encodeWithCoder这个方法，会报没有没有调用这个方法的错误
    [NSKeyedArchiver archiveRootObject:person toFile:filePath];
    
}

- (IBAction)unArchiverRead:(UIButton *)sender {
    // 获取沙盒目录
    NSString *path = NSTemporaryDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:@"person.data"];
    // unarchiveObjectWithFile会调用 initWithCoder方法
    // 同样在解析的时候也是需要去重写initWithCoder方法的，不然会报没有调用initWithCoder方法的错误
    wjPerson *person = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    // 在读取的时候会在wjPerson中去解析沙盒中的文件。然后再返回值回来
    NSLog(@"%@---%ld--%@", person.name, person.age, person.dog.name);
    
}



@end
