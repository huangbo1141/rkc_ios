//
//  VCMenuSwitchUser.m
//  FoodSafety
//
//  Created by Huang Bo on 12/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuSwitchUser.h"
#import "Global.h"
#import "VCLogin.h"
#import "VCMenuAddUser.h"
#import "UserInfo.h"
#import "MenuSwitchUserCell.h"
#import "Language.h"
#import "NetworkParser.h"
@interface VCMenuSwitchUser ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSArray*data;
@end

@implementation VCMenuSwitchUser

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    UINib* nib = [UINib nibWithNibName:@"MenuSwitchUserCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
- (IBAction)actionAddUser:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCMenuAddUser"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    NSString* domain = [[UserInfo shared] getDomain];
    NSString* key_domain = [NSString stringWithFormat:@"key_%@",domain];
    
    
    
    id saved_data = [[NSUserDefaults standardUserDefaults] objectForKey:key_domain];
    if (saved_data != nil) {
        self.data = saved_data;
    }
    [self.tableView reloadData];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuSwitchUserCell* cell= [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary* data = self.data[indexPath.row];
    if([data[@"m_status"] intValue]==0){
        // username
        cell.lblUsername.text = kLang(@"username");
        cell.lblContent.text = data[@"username"];
    }else{
        // usercode
        cell.lblUsername.text = kLang(@"usercode");
        cell.lblContent.text = data[@"username"];
    }
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation"
                                                                   message:@"Are you sure switch user?"
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:kLang(@"yes")
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              [self switchUser:indexPath];
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:kLang(@"no")
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               
                                                           }]; // 3
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    
    if([Global isIPad]){
        alert.popoverPresentationController.sourceView = [tableView cellForRowAtIndexPath:indexPath];
    }
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}
-(void)switchUser:(NSIndexPath*)indexPath{
    NSMutableDictionary* data = self.data[indexPath.row];
    int m_status = [data[@"m_status"] intValue];
    NSString* username = data[@"username"];
    NSString* password = data[@"password"];
    [Global showIndicator:self];
    [[NetworkParser shared] serviceLogin:username withPassword:password withMode:m_status withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            [[UserInfo shared] setToken:[UserInfo shared].mAccount.mToken];
            [self serviceGetProfile:[UserInfo shared].mAccount.mToken];
        }else {
            if (m_status == 0) {
                [Global AlertMessage:self Message:kLang(@"invalid_account") Title:kLang(@"alert")];
            }else{
                [Global AlertMessage:self Message:kLang(@"invalid_code") Title:kLang(@"alert")];
            }
            // remove that row
            
            
        }
        [Global stopIndicator:self];
    }];
}
- (void) serviceGetProfile:(NSString*) token {
    [[NetworkParser shared] serviceGetProfile:token withCompletionBlock:^(id responseObject, NSString *error) {
        if(error == nil) {
            UserModel* model = (UserModel*) responseObject;
            [UserInfo shared].mAccount.mToken = token;
            [[UserInfo shared] intercomCreateUser];
            [[NetworkParser shared] serviceGetSettings:nil];
            if([UserInfo shared].mApnsToken != nil && ![[UserInfo shared].mApnsToken isEqualToString:@""]) {
                [[NetworkParser shared] serviceUpdateAPNSToken:[UserInfo shared].mApnsToken withCompletionBlock:nil];
            }
            [self gotoAssign];
            
        }
    }];
}

- (void) gotoAssign {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCAssign" withOptions:@{@"reset":@"1"}];
}
@end
