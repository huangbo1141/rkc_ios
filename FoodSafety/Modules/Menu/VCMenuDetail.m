//
//  VCMenuDetail.m
//  FoodSafety
//
//  Created by BoHuang on 8/28/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCMenuDetail.h"
#import "NetworkParser.h"
#import "MenuModel.h"
#import "UserInfo.h"
#import "Global.h"

@interface VCMenuDetail ()

@end

@implementation VCMenuDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContainers];
    [self serviceMenuDetail];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteAction:(id)sender {
    [self serviceMenuDelete];
}

- (void) serviceMenuDelete {
    DeliveryMenuModel* logModel = (DeliveryMenuModel*)[UserInfo shared].selectedObject;
    if(logModel != nil  && logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteMenu:logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Global switchScreen:self withStoryboardName:@"Menu" withControllerName:@"VCMenuList"];
                    //[self.navigationController popViewControllerAnimated:YES];
                });
                
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceMenuDetail {
    DeliveryMenuModel* logModel = (DeliveryMenuModel*)[UserInfo shared].selectedObject;
    if(logModel != nil  && logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceGetMenuDetail:logModel withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
                
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) reloadData {
    [self.itemVC loadData];
    [self.detailVC loadData];
    [self.labelVC loadData];
}

- (IBAction)sectionSwitcherSegmentChanged:(id)sender {
    [self setContainers];
}

//MARK: - Switch VCs

- (void) setContainers{
    int index = (int)self.segmentView.selectedSegmentIndex;
    UIStoryboard* menuSB = [UIStoryboard storyboardWithName:@"Menu" bundle:nil];
    
    
    if(self.detailVC == nil)
        self.detailVC = [menuSB instantiateViewControllerWithIdentifier:@"VCMenuDetailView"];
    if(self.itemVC == nil)
        self.itemVC = [menuSB instantiateViewControllerWithIdentifier:@"VCMenuDetailItem"];
    if(self.labelVC == nil)
        self.labelVC = [menuSB instantiateViewControllerWithIdentifier:@"VCMenuDetailLabel"];
    
    
    if(self.currentVC == nil){
        if(index == 0){
            self.currentVC = self.detailVC;
            [self addViewController:self.detailVC];
            
        }
        if(index == 1){
            self.currentVC = self.itemVC;
            [self addViewController:self.itemVC];
            
        }
        if(index == 2 ){
            self.currentVC = self.labelVC;
            [self addViewController:self.labelVC];
            
        }
        
    }else{
        if(index == 0){
            [self cycleFromViewController:self.currentVC toViewController:self.detailVC ];
            self.currentVC =self.detailVC;
            
        }
        if(index == 1){
            [self cycleFromViewController:self.currentVC toViewController:self.itemVC];
            self.currentVC =self.itemVC;
            
        }
        
        if(index == 2){
            [self cycleFromViewController:self.currentVC toViewController:self.labelVC];
            self.currentVC =self.labelVC;
            
        }
        
    }
}


- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
    [oldViewController willMoveToParentViewController:nil];
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    
    [oldViewController.view removeFromSuperview];
    [oldViewController removeFromParentViewController];
    [newViewController didMoveToParentViewController:self];
    
    return;
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    subView.frame = parentView.bounds;
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
    
}

- (void)addViewController:(UIViewController*)newViewController {
    
    //[self addSubview:newViewController.view toView:self.containerView];
    newViewController.view.frame = self.containerView.bounds;
    [self.containerView addSubview:newViewController.view];
    [self addChildViewController:newViewController];
    [newViewController didMoveToParentViewController:self];
    
    return;
}

@end
