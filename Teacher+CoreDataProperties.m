//
//  Teacher+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by safiri on 2017/1/18.
//  Copyright © 2017年 com.egintra. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic name;
@dynamic idNum;
@end
