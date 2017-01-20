//
//  ViewController.m
//  CoreDataDemo
//
//  Created by safiri on 2017/1/18.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "ViewController.h"
#import "Student+CoreDataClass.h"
#import "Student+CoreDataProperties.h"
#import "CoreDataHelper.h"
#import "Teacher+CoreDataClass.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [CoreDataHelper setMangedObjectName:@"School"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
