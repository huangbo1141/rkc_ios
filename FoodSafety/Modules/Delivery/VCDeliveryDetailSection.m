//
//  VCDeliveryDetailSection.m
//  FoodSafety
//
//  Created by BoHuang on 8/26/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCDeliveryDetailSection.h"

@interface VCDeliveryDetailSection ()

@end

@implementation VCDeliveryDetailSection

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContainers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) reloadData {
    [self.infoVC reloadData];
    [self.conditionVC reloadData];
}


- (IBAction)sectionSwitcherSegmentChanged:(id)sender {
    [self setContainers];
}

//MARK: - Switch VCs

- (void) setContainers{
    int index = (int)self.segmentView.selectedSegmentIndex;
    UIStoryboard* deliverySB = [UIStoryboard storyboardWithName:@"Delivery" bundle:nil];
    
    
    if(self.infoVC == nil)
        self.infoVC = [deliverySB instantiateViewControllerWithIdentifier:@"VCDeliveryInfoDetailView"];
    
    if(self.conditionVC == nil)
        self.conditionVC = [deliverySB instantiateViewControllerWithIdentifier:@"VCDeliveryConditionDetailView"];
    
    
    if(self.infoVC == nil){
        if(index == 0){
            self.currentVC = self.infoVC;
            [self addViewController:self.infoVC];
            
        }
        if(index == 1){
            self.currentVC = self.conditionVC;
            [self addViewController:self.conditionVC];
            
        }
        
    }else{
        if(index == 0){
            [self cycleFromViewController:self.currentVC toViewController:self.infoVC ];
            self.currentVC =self.infoVC ;
            
        }
        if(index == 1){
            [self cycleFromViewController:self.currentVC toViewController:self.conditionVC];
            self.currentVC =self.conditionVC;
            
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
