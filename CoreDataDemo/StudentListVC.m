//
//  StudentListVC.m
//  CoreDataDemo
//
//  Created by safiri on 2017/1/20.
//  Copyright © 2017年 com.egintra. All rights reserved.
//

#import "StudentListVC.h"
#import "Student+CoreDataProperties.h"
#import "CoreDataHelper.h"

@interface StudentListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic ,strong)NSMutableArray *myDataArray;
@property (nonatomic ,strong)NSManagedObjectContext *context;

@end

@implementation StudentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *const indenti = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indenti];
    }
    Student *stu = [self.myDataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"姓名：%@，编号%zd",stu.name,stu.idNum];
    cell.detailTextLabel.text = stu.timeCreate;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray *)myDataArray{
    if (!_myDataArray) {
        _myDataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _myDataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getData {
    self.context = [CoreDataHelper getManagedObjectContext];
    NSFetchRequest *request = [Student fetchRequest];
    //设置排序(按照idNum降序)
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"idNum" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sort];
    // 设置条件过滤(搜索name中包含字符串"zhang"的记录，注意：设置条件过滤时，数据库SQL语句中的%要用*来代替，所以%Itcast-1%应该写成*zhang*)
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*zhang*"];
    // request.predicate = predicate;
    
    //执行请求
    __autoreleasing NSError *error = nil;
    NSArray *objs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }else{
        [self.myDataArray removeAllObjects];
        [self.myDataArray addObjectsFromArray:objs];
        [self.table reloadData];
    }
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
