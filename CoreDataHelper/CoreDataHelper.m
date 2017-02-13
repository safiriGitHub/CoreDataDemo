//
//  CoreDataHelper.m
//  coreData
//
//  Created by safiri on 15/10/13.
//  Copyright © 2015年 safiri. All rights reserved.
//

#import "CoreDataHelper.h"
//#import "NSObject+PropertyListing.h"
static CoreDataHelper *_instance;

@implementation CoreDataHelper

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}
+ (NSManagedObjectContext *) getManagedObjectContext{
    return [CoreDataHelper sharedInstance].persistentContainer.viewContext;
}
+ (NSManagedObjectModel *) getManagedObjectModel{
    NSString *modelName = [CoreDataHelper sharedInstance].objectModelName;
    if (modelName) {
        //获取模型路径
        NSURL *modeUrl = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        //根据模型文件创建模型对象
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modeUrl];
        return model;
    }else{
        // 2.从应用程序包中加载.xcdatamodeld模型文件
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        return model;
    }
}
+ (void)setMangedObjectName:(NSString *)name{
    [[CoreDataHelper sharedInstance] setObjectModelName:name];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:self.objectModelName];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}



#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


+ (void)insertCoreDataWithDictionary:(NSDictionary *)dictionary andEntityName:(NSString *)entityName{
//    NSManagedObjectContext *context = [[CoreDataHelper sharedInstance]managedObjectContext];
//    id newEntity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
//    NSArray *propertyArray = [newEntity getAllProperties];
//    NSArray *keyArray = [dictionary allKeys];
//    for (NSString *key in keyArray) {
//        //DLog(@"propertyKey  --%@",propertyKey);
//        if ([propertyArray containsObject:key]) {
//            NSString *valueString = [dictionary objectForKey:key];
//            //DLog(@"valueString  --%@",valueString);
//            [newEntity setValue:valueString forKey:key];
//        }
//    }
//    
//    NSError *error;
//    if(![context save:&error])
//    {
//        NSLog(@"不能插入：%@",[error localizedDescription]);
//    }
}

/**
 *  功能：
 */
- (void)insertCoreData:(NSMutableArray *)dataArray WithEntityName:(NSString *)entityName {
    @try {
        for (NSDictionary *dic in dataArray) {
            [[self class] insertCoreDataWithDictionary:dic andEntityName:entityName];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"异常情况：%@",[exception reason]);
    }
    @finally {
        
    }
}
//查询 查询技巧很多,具体情况需要自己重新写
+ (NSArray *)readAllObjectWithEntityName:(NSString *)entityName{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}
+ (void)deleteAllDataWithEntityName:(NSString *)entityName{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    NSEntityDescription *entity  =[NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count]) {
        for (NSManagedObject *obj in datas) {
            [context deleteObject:obj];
        }
        if (![context save:&error]) {
            NSLog(@"error:%@",[error localizedDescription]);
        }
    }
}


+ (BOOL)deleteObject:(NSManagedObject *)object{
    NSManagedObjectContext *context = [CoreDataHelper getManagedObjectContext];
    [context deleteObject:object];
    BOOL isSuccess = NO;
    if ([object isDeleted]) {
        NSError *error = nil;
        if ([context save:&error]) {
            isSuccess = YES;
        }else{
            NSLog(@"deleteError:%@",[error localizedDescription]);
        }
    }
    return isSuccess;
}
//更新数据示例
/*
 //更新
 - (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
 {
 NSManagedObjectContext *context = [self managedObjectContext];
 
 NSPredicate *predicate = [NSPredicate
 predicateWithFormat:@"newsid like[cd] %@",newsId];
 
 //首先你需要建立一个request
 NSFetchRequest * request = [[NSFetchRequest alloc] init];
 [request setEntity:[NSEntityDescription entityForName:TableName inManagedObjectContext:context]];
 [request setPredicate:predicate];//这里相当于sqlite中的查询条件，具体格式参考苹果文档
 
 //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/Articles/pCreating.html
 NSError *error = nil;
 NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
 for (News *info in result) {
 info.islook = islook;
 }
 
 //保存
 if ([context save:&error]) {
 //更新成功
 NSLog(@"更新成功");
 }
 }
 */



@end
