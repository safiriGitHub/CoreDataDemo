//
//  TeacherVC.m
//  CoreDataDemo
//
//  Created by safiri on 2017/1/20.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "TeacherVC.h"
#import "Teacher+CoreDataProperties.h"
#import "CoreDataHelper.h"

@interface TeacherVC ()
@property (nonatomic ,strong)NSManagedObjectContext *context;
@property (nonatomic ,strong)NSArray *allTeachers;

@end

@implementation TeacherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [CoreDataHelper getManagedObjectContext];
    [self createBtn];
    [self createDeleteBtn];
}
- (void)createBtn{
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *bt = (UIButton *)view;
            if (bt.tag != 100) {
                [view removeFromSuperview];
            }
        }
    }
    NSFetchRequest *request = [Teacher fetchRequest];
    __autoreleasing NSError *error = nil;
    NSArray *teachers = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@", [error localizedDescription]];
    }else{
        if (teachers.count > 0) {
            self.allTeachers = [NSArray arrayWithArray:teachers];
            NSInteger i = 0;
            for (Teacher *tea in teachers) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setTitle:[NSString stringWithFormat:@"%@:%zd",tea.name,tea.idNum] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(i%3 * (120+10), i/3 * (20+10) + 100, 120, 20)];
                button.tag = i;
                [button addTarget:self action:@selector(changeIdNum:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                i++;
            }
        }else{
            [self addSomeTeachers];
        }
    }
}
- (void)addSomeTeachers{
    for (NSInteger i=0; i<7; i++) {
        Teacher *tea = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.context];
        tea.name = [NSString stringWithFormat:@"老师%zd",i];
        tea.idNum = arc4random_uniform(100);
        __autoreleasing NSError *error = nil;
        [self.context save:&error];
        if (error) {
            [NSException raise:@"添加Teacher失败" format:@"%@", [error localizedDescription]];
        }
    }
    [self createBtn];
}
- (void)changeIdNum:(UIButton *)btn{
    // 如果是想做更新操作：只要在更改了实体对象的属性后调用[context save:&error]，就能将更改的数据同步到数据库
    //先从数据库中取出所有的数据,然后从其中选出要修改的那个,进行修改,然后保存
    NSInteger idNum = [(Teacher *)[self.allTeachers objectAtIndex:btn.tag] idNum];
    NSFetchRequest *request = [Teacher fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNum == %@",[NSString stringWithFormat:@"%zd",idNum]];
    request.predicate = predicate;
    __autoreleasing NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@", [error localizedDescription]];
    }else{
        if (objs.count > 0) {
            for (Teacher *tea in objs) {
                //更新idNum
                tea.idNum = arc4random_uniform(100);
            }
        }
        [self.context save:&error];
        if (error) {
            [NSException raise:@"更新失败" format:@"%@", [error localizedDescription]];
        }else{
            [self createBtn];
        }
    }
   
}

#pragma mark - 删除操作
- (void)createDeleteBtn {
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [delBtn setTitle:@"随机删除一个老师" forState:UIControlStateNormal];
    delBtn.tag = 100;
    [delBtn addTarget:self action:@selector(deleteRandom) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setFrame:CGRectMake(100, 300, 160, 40)];
    [self.view addSubview:delBtn];
}
- (void) deleteRandom{
    uint32_t t = (uint32_t)self.allTeachers.count - 1;
    Teacher *tea = [self.allTeachers objectAtIndex:arc4random_uniform(t)];
    NSFetchRequest *request = [Teacher fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNum == %@",[NSString stringWithFormat:@"%zd",[tea idNum]]];
    request.predicate = predicate;
    __autoreleasing NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询失败" format:@"%@", [error localizedDescription]];
    }else{
        for (Teacher *tea in objs) {
            [self.context deleteObject:tea];
        }
        [self.context save:&error];
        if (error) {
            [NSException raise:@"删除失败" format:@"%@", [error localizedDescription]];
        }else{
            [self createBtn];
        }
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
