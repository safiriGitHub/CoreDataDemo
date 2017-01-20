//
//  CoreDataHelper1.h
//  CoreDataDemo
//
//  Created by safiri on 2017/1/20.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper1 : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic ,copy)NSString *objectModelName;
- (void)saveContext;
+ (instancetype)sharedInstance;
+ (NSManagedObjectContext *) getManagedObjectContext;
+ (void)setMangedObjectName:(NSString *)name;

@end
