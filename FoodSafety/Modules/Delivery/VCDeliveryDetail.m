//
//  VCDeliveryDetail.m
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryDetail.h"
#import "NetworkParser.h"
#import "DeliveryModel.h"
#import "UserInfo.h"
#import "Global.h"
@interface VCDeliveryDetail ()

@end

@implementation VCDeliveryDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContainers];

    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self serviceDeliveryDetail];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: - IBActions

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteAction:(id)sender {
    [self serviceDeliveryDelete];
}

- (void) serviceDeliveryDelete {
    DeliveryModel* logModel = (DeliveryModel*)[UserInfo shared].selectedObject;
    if(logModel != nil  && logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteDelivery:logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Global switchScreen:self withStoryboardName:@"Delivery" withControllerName:@"VCDeliveryList"];
                    //[self.navigationController popViewControllerAnimated:YES];
                });
                
            }
            [Global stopIndicator:self];
        }];
    }
}

- (void) serviceDeliveryDetail {
    DeliveryModel* logModel = (DeliveryModel*)[UserInfo shared].selectedObject;
    if(logModel != nil  && logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceGetDeliveryDetail:logModel withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                NSMutableArray* labels = (NSMutableArray*)responseObject;
                logModel.mLabels = labels;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData];
                });
         
            }
            [Global stopIndicator:self];
        }];
    }
}
- (void) reloadData {
    [self.detailVC reloadData];
    [self.labelVC reloadData];
}

- (IBAction)sectionSwitcherSegmentChanged:(id)sender {
    [self setContainers];
}

//MARK: - Switch VCs

- (void) setContainers{
    int index = (int)self.segmentView.selectedSegmentIndex;
    UIStoryboard* deliverySB = [UIStoryboard storyboardWithName:@"Delivery" bundle:nil];
    
    
    if(self.detailVC == nil)
        self.detailVC = [deliverySB instantiateViewControllerWithIdentifier:@"VCDeliveryDetailSection"];
    
    if(self.labelVC == nil)
        self.labelVC = [deliverySB instantiateViewControllerWithIdentifier:@"VCDeliveryLabelDetailView"];
    
    
    if(self.currentVC == nil){
        if(index == 0){
            self.currentVC = self.detailVC;
            [self addViewController:self.detailVC];
            
        }
        if(index == 1){
            self.currentVC = self.labelVC;
            [self addViewController:self.labelVC];
            
        }
        
    }else{
        if(index == 0){
            [self cycleFromViewController:self.currentVC toViewController:self.detailVC ];
            self.currentVC =self.detailVC;
            
        }
        if(index == 1){
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
