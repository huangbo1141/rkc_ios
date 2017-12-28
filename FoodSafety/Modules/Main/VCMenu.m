//
//  VCMenu.m
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenu.h"
#import "CVCellMenu.h"
#import "MenuModel.h"
#import "PermissionModel.h"
#import "UserInfo.h"
#import "Language.h"
#import "Global.h"

@interface VCMenu ()

@end

@implementation VCMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [Intercom setLauncherVisible:YES];
    self.itemPerRow = 3;
    self.items = [[NSMutableArray alloc] init];
    self.sectionInsects = UIEdgeInsetsMake(0, 10.0, 0, 10.0);
   // self.menuStrings = [NSArray arrayWithObjects:@"fridge",@"freezer", @"item", @"reheating", @"cooling", @"service", @"transport", @"delivery", @"delivery_menu",@"oil", @"cleaning",@"laboratory", @"safety",@"pest", @"notification",@"signout", nil];
    self.menuStrings = [NSArray arrayWithObjects:@"fridge",@"freezer", @"item", @"reheating", @"cooling", @"service", @"transport", @"delivery", @"delivery_menu",@"oil", @"cleaning", @"notification",@"signout", nil];
    self.collectionView.dataSource =self;
    self.collectionView.delegate =self;
    
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//progma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger numberOfSections;
    if( self.items.count % self.itemPerRow == 0 ){
        numberOfSections = (int)((float)(self.items.count) / (float) (self.itemPerRow));
    }else{
        numberOfSections = (int)((float)self.items.count / (float) (self.itemPerRow +1));
    }
    return numberOfSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger numberOfSections;
    if( self.items.count % self.itemPerRow == 0 ){
        numberOfSections = (int)((float)(self.items.count) / (float) (self.itemPerRow));
    }else{
        numberOfSections = (int)((float)self.items.count / (float) (self.itemPerRow +1));
    }
    if(section < numberOfSections -1){
        return self.itemPerRow;
    }else{
        NSInteger itemCount = self.items.count - section* self.itemPerRow;
        return itemCount;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"CVCellMenu";
    
    CVCellMenu *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger index = indexPath.section * self.itemPerRow + indexPath.row  ;
    MenuModel *model = [self.items objectAtIndex:index];
    
    [cell.imgIcon setImage:[UIImage imageNamed:model.mImageRes]];
    [cell.lblTitle setText:model.mTitle];
    
    return cell;
}

//progma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat paddingSpace = self.sectionInsects.left * (self.itemPerRow + 1);
    CGFloat availableWidth = self.view.frame.size.width - paddingSpace;
    CGFloat widthPerItem = availableWidth / self.itemPerRow;
    return CGSizeMake(widthPerItem-20, widthPerItem+5);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.sectionInsects;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.sectionInsects.left;
}

//progma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"CategoryCell";
    //CategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
   
    NSInteger index = indexPath.section * self.itemPerRow + indexPath.row  ;
    MenuModel *model = [self.items objectAtIndex:index];
    [self openMenu:model.mName];
    
    
}


-(void) openMenu:(NSString*) menuName{
    if([menuName isEqualToString:@"fridge"]) {
        [Global switchStoryboard:self withStoryboardName:@"Fridge"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Fridge"];
    }else if([menuName isEqualToString:@"freezer"]) {
        [Global switchStoryboard:self withStoryboardName:@"Freezer"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Freezer"];
    }else if([menuName isEqualToString:@"item"]) {
        [Global switchStoryboard:self withStoryboardName:@"Item"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Item"];

    }else if([menuName isEqualToString:@"reheating"]) {
        
        [Global switchStoryboard:self withStoryboardName:@"Reheating"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Reheating"];
    }else if([menuName isEqualToString:@"cooling"]) {
        [Global switchStoryboard:self withStoryboardName:@"Cooling"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Cooling"];

    }else if([menuName isEqualToString:@"service"]) {
        [Global switchStoryboard:self withStoryboardName:@"Service"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Service"];

    }else if([menuName isEqualToString:@"transport"]) {
        [Global switchStoryboard:self withStoryboardName:@"Transport"];
        [[UserInfo shared] intercomUpdatePagePosition:@"         Transport"];

    }else if([menuName isEqualToString:@"delivery"]) {
        [Global switchStoryboard:self withStoryboardName:@"Delivery"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Delivery"];
    }else if([menuName isEqualToString:@"delivery_menu"]) {
        
        [Global switchStoryboard:self withStoryboardName:@"Menu"];
        [[UserInfo shared] intercomUpdatePagePosition:@"DeliveryMenu"];

    }else if([menuName isEqualToString:@"oil"]) {
        [Global switchStoryboard:self withStoryboardName:@"Oil"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Oil"];

    }else if([menuName isEqualToString:@"cleaning"]) {
        [Global switchStoryboard:self withStoryboardName:@"Cleaning"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Cleaning"];

    }else if([menuName isEqualToString:@"safety"]) {
        [Global switchStoryboard:self withStoryboardName:@"Safety"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Safety"];
    }else if([menuName isEqualToString:@"laboratory"]) {
        [Global switchStoryboard:self withStoryboardName:@"Print"];
       // [[UserInfo shared] intercomUpdatePagePosition:@"Laboratory"];
    }else if([menuName isEqualToString:@"pest"]) {
       // [Global switchStoryboard:self withStoryboardName:@"Pest"];
        //[[UserInfo shared] intercomUpdatePagePosition:@"Pest"];
    }else if([menuName isEqualToString:@"notification"]) {

        [Global switchStoryboard:self withStoryboardName:@"Notification"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Notification"];
    }else if([menuName isEqualToString:@"profile"]) {
        [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
        [[UserInfo shared] intercomUpdatePagePosition:@"Profile"];
    }else if([menuName isEqualToString:@"signout"]) {
        [[UserInfo shared] setLogined:false];
        [[UserInfo shared] setToken:@""];
        [UserInfo shared].mAccount.mToken = @"";
        [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCConnect"];
        
    }
}

-(BOOL) checkPermission:(NSString*) name {
    PermissionModel* permissonModel = [UserInfo shared].mAccount.mPermissionModel;
    
    if(permissonModel.mFullAccess)
        return true;
    if([name isEqualToString:@"fridge"]) {
        return [permissonModel checkPermission:@"fridge" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"freezer"]) {
        return [permissonModel checkPermission:@"freezer" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"item"]) {
        return [permissonModel checkPermission:@"item" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"reheating"]) {
        return [permissonModel checkPermission:@"reheating" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"cooling"]) {
        return [permissonModel checkPermission:@"cooling" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"service"]) {
        return [permissonModel checkPermission:@"service" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"transport"]) {
        return [permissonModel checkPermission:@"transport" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"delivery"]) {
        return [permissonModel checkPermission:@"delivery" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"delivery_menu"]) {
        return [permissonModel checkPermission:@"menu" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"oil"]) {
        return [permissonModel checkPermission:@"oil" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"cleaning"]) {
        return [permissonModel checkPermission:@"cleaning" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"safety"]) {
        return [permissonModel checkPermission:@"safety" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"laboratory"]) {
        return [permissonModel checkPermission:@"laboratory" withCategory:@"log" withFunction:@"view" ];
    }else if([name isEqualToString:@"pest"]) {
        return [permissonModel checkPermission:@"pest" withCategory:@"log" withFunction:@"view" ];
    }
    return true;
}

-(void) loadData {
    [self.items removeAllObjects];
    for(int i=0; i<self.menuStrings.count; i++){
        NSString* name =  [self.menuStrings objectAtIndex:i];
        if([self checkPermission:name]) {
            MenuModel* model = [[MenuModel alloc] init];
            model.mImageRes = [self getResName:name];
            model.mTitle = kLang(name);
            model.mName = name;
            [self.items addObject: model];
            
        }
    }
    /*for(NSString* name in  self.menuStrings) {
        if([self checkPermission:name]) {
            MenuModel* model = [[MenuModel alloc] init];
            model.mImageRes = [self getResName:name];
            model.mTitle = kLang(name);
            model.mName = name;
        
        }
    }*/
    [self.collectionView reloadData];
}

-(NSString*) getResName:(NSString*) menuName {
    if([menuName isEqualToString:@"fridge"]) {
        return @"ic_fridge_menu";
    }else if([menuName isEqualToString:@"freezer"]) {
        return @"ic_freeze_menu";
    }else if([menuName isEqualToString:@"item"]) {
        return @"ic_item_menu";
    }else if([menuName isEqualToString:@"reheating"]) {
        return @"ic_reheating_menu";
    }else if([menuName isEqualToString:@"cooling"]) {
        return @"ic_chill_menu";
    }else if([menuName isEqualToString:@"service"]) {
        return @"ic_serve_menu";
    }else if([menuName isEqualToString:@"transport"]) {
        return @"ic_transport_menu";
    }else if([menuName isEqualToString:@"delivery"]) {
        return @"ic_delivery_menu";
    }else if([menuName isEqualToString:@"delivery_menu"]) {
        return @"ic_menu_menu";
    }else if([menuName isEqualToString:@"oil"]) {
        return @"ic_oil_menu";
    }else if([menuName isEqualToString:@"cleaning"]) {
        return @"ic_cleaning_menu";
    }else if([menuName isEqualToString:@"safety"]) {
        return @"ic_safety";
    }else if([menuName isEqualToString:@"laboratory"]) {
        return @"ic_laboratory_menu";
    }else if([menuName isEqualToString:@"pest"]) {
        return @"ic_pest_menu";
    }else if([menuName isEqualToString:@"notification"]) {
        return @"ic_notification_menu";
    }else if([menuName isEqualToString:@"profile"]) {
        return @"ic_profile";
    }else if([menuName isEqualToString:@"signout"]) {
        return @"ic_logout_menu";
    }
    return @"";
}
- (IBAction)backAction:(id)sender {
    [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCAssign"];
}
- (IBAction)profileAction:(id)sender {
    UIAlertController* alert = [[UIAlertController alloc] init];
    UIAlertAction*ac1 = [UIAlertAction actionWithTitle:kLang(@"menu_profile") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Global switchScreen:self withStoryboardName:@"Main" withControllerName:@"VCProfile"];
    }];
    UIAlertAction*ac2 = [UIAlertAction actionWithTitle:kLang(@"menu_switchuser") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuSwitchUser"];
    }];
    if([Global isIPad]){
        alert.popoverPresentationController.sourceView = sender;
    }
    [alert addAction:ac1];
    [alert addAction:ac2];
    [self presentViewController:alert animated:true completion:nil];
}

@end
