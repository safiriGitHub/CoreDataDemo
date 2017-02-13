//
//  CoreDataHelper.h
//  coreData
//
//  Created by safiri on 15/10/13.
//  Copyright © 2015年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

/**
 CoreData文件名。
 */
@property (nonatomic ,copy)NSString *objectModelName;
+ (instancetype)sharedInstance;
+ (NSManagedObjectContext *) getManagedObjectContext;
+ (NSManagedObjectModel *) getManagedObjectModel;
+ (void)setMangedObjectName:(NSString *)name;
- (void)saveContext;

//add:

/**
 增加实体类

 @param dictionary 实体类对应对象
 @param entityName 要存的entity
 */
+ (void)insertCoreDataWithDictionary:(NSDictionary *)dictionary andEntityName:(NSString *)entityName;

/**
 获取 entityName 的对象数组
 @param entityName entityName
 @return entityName数组
 */
+ (NSArray *)readAllObjectWithEntityName:(NSString *)entityName;

/**
 删除所有的entityName存储对象
 */
+ (void)deleteAllDataWithEntityName:(NSString *)entityName;

+ (BOOL)deleteObject:(NSManagedObject *)object;//删除某个 （未验证）
@end
/* 学习链接
 http://segmentfault.com/a/1190000002923612
 */
/*
 增：新对象是由NSEntityDescription按照指定的名称并根据某个特定的实体而创建出来的。除了要指定对象所依据的实体之外，还需要提供托管对象上下文，创建好的托管对象将会放在那个上下文里面。
 
 Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
 */
/*
 删：若想删除托管对象，只需要在包含对象的上下文中调用deleteObject或者deleteObjects。然后用上下文的save方法保存更新数据库。
 [[self managedObjectContext]save:&savingError]
*/
/*
 勾选上这个选项之后就是使用的是你在定义的时候使用的原始数据类型。
 如果没有勾选的话，就会存在类型的转化，转换情况如下
 • String maps to String
 • Integer 16/32/64, Float, Double and Boolean map to NSNumber
 • Decimal maps to NSDecimalNumber
 • Date maps to NSDate
 • Binary data maps to NSData
 • Transformable maps to AnyObject
 */
