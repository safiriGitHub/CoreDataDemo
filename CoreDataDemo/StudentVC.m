//
//  StudentVC.m
//  CoreDataDemo
//
//  Created by safiri on 2017/1/18.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "StudentVC.h"
#import "CoreDataHelper.h"
#import "Student+CoreDataClass.h"
#import "Student+CoreDataProperties.h"
#import "Book+CoreDataClass.h"
#import "Classee+CoreDataProperties.h"
@interface StudentVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (nonatomic ,strong)NSManagedObjectContext *context;

@end

@implementation StudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [CoreDataHelper setMangedObjectName:@"School"];
    self.context = [CoreDataHelper getManagedObjectContext];
}
- (IBAction)addStudent:(id)sender {
    if (self.nameText.text.length > 0) {
        //http://blog.csdn.net/wanglj7525/article/details/43450425
        Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
        student.name = self.nameText.text;
        student.timeCreate = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];
        student.idNum = arc4random_uniform(1000)+1;
        Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.context];
        book.name = @"三体";
        student.book = book;
        
        
        NSError *error = nil;
        BOOL success = [self.context save:&error];
        if (success) {
            NSLog(@"添加成功");
            [self readData];
        }else{
            [NSException raise:@"访问数据库错误" format:@"%@",[error localizedDescription]];
        }
    }
    
    Classee *class = [NSEntityDescription insertNewObjectForEntityForName:@"Classee" inManagedObjectContext:self.context];
    class.name = @"efe";
    __autoreleasing NSError *error = nil;
    [self.context save:&error];
    if (error) {
        [NSException raise:@"" format:@"%@", [error localizedDescription]];
    }
    
   

}
- (void)readData{
    // 初始化一个查询请求
    //  NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 设置要查询的实体
    // request.entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedContext];
    
    //以上代码简写成下边
    //NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    //也可以简写为
    NSFetchRequest *request = [Student fetchRequest];
    //执行请求
    NSError *error = nil;
    NSArray *students = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }else{
        Student *stu = [students lastObject];
        self.hintLabel.text = [NSString stringWithFormat:@"添加了一个学生，名字是%@,id是%zd",stu.name,stu.idNum];
    }
    
}
- (IBAction)searchStudent:(id)sender {
    
    if (self.nameText.text.length > 0) {
        NSFetchRequest *request = [Student fetchRequest];
        // 设置条件过滤(搜索name中包含字符串"zhang"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*zhang*)
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", [NSString stringWithFormat:@"*%@*",self.nameText.text]];
        
        request.predicate = predicate;
        //执行请求
        __autoreleasing NSError *error = nil;
        NSArray *objs = [self.context executeFetchRequest:request error:&error];
        if (error) {
            [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
        }else{
            self.hintLabel.text = [NSString stringWithFormat:@"查询结果：有%zd个。",objs.count];
            if (objs.count > 0) {
                NSString *str = @"";
                for (Student *stu in objs) {
                    str = [str stringByAppendingFormat:@"姓名：%@|",stu.name];
                }
                self.hintLabel.text = [self.hintLabel.text stringByAppendingFormat:@"分别是：\n %@",str];
            }
            
        }
    }
}
- (void)searchStudentFromFetchRequestTemplate{
    NSManagedObjectModel *mom = [CoreDataHelper getManagedObjectModel];
    NSFetchRequest *req1 = [mom fetchRequestTemplateForName:@"Name"];
    NSError *error = nil;
    NSArray *students = [self.context executeFetchRequest:req1 error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }else{
        Student *stu = [students lastObject];
        self.hintLabel.text = [NSString stringWithFormat:@"找到了最后一个学生，名字是%@,id是%zd",stu.name,stu.idNum];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
