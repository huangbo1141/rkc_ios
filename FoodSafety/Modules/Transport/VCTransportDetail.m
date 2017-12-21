//
//  VCTransportDetail.m
//  FoodSafety
//
//  Created by BoHuang on 8/25/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import "VCTransportDetail.h"
#import "NetworkParser.h"
#import "TransportModel.h"
#import "UserInfo.h"
#import "Global.h"

@interface VCTransportDetail ()

@end

@implementation VCTransportDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.segmentView.selectedSegmentIndex=0;
    [self setContainers];
    
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
    [self serviceTransportDelete];
}

- (void) serviceTransportDelete {
    TransportModel* logModel = (TransportModel*)[UserInfo shared].selectedObject;
    if(logModel != nil  && logModel.mKeyCode != nil) {
        [Global showIndicator:self];
        [[NetworkParser shared] serviceDeleteTransport:logModel.mKeyCode withCompletionBlock:^(id responseObject, NSString *error) {
            if(error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Global switchScreen:self withStoryboardName:@"Transport" withControllerName:@"VCTransportList"];
                    //[self.navigationController popViewControllerAnimated:YES];
                });
    
            }
            [Global stopIndicator:self];
        }];
    }
}

- (IBAction)sectionSwitcherSegmentChanged:(id)sender {
    [self setContainers];
}

//MARK: - Switch VCs

- (void) setContainers{
    int index = (int)self.segmentView.selectedSegmentIndex;
    UIStoryboard* transportSB = [UIStoryboard storyboardWithName:@"Transport" bundle:nil];
   
    
    if(self.departureVC == nil)
        self.departureVC = [transportSB instantiateViewControllerWithIdentifier:@"TransportDepartureDetailView"];
    
    if(self.arrivalVC == nil)
        self.arrivalVC = [transportSB instantiateViewControllerWithIdentifier:@"TransportArrivalDetailView"];
    
    
    if(self.currentVC == nil){
        if(index == 0){
            self.currentVC = self.departureVC;
            [self addViewController:self.departureVC];
            
        }
        if(index == 1){
            self.currentVC = self.arrivalVC;
            [self addViewController:self.arrivalVC];
            
        }
        
    }else{
        if(index == 0){
            [self cycleFromViewController:self.currentVC toViewController:self.departureVC ];
            self.currentVC =self.departureVC;
            
        }
        if(index == 1){
            [self cycleFromViewController:self.currentVC toViewController:self.arrivalVC];
            self.currentVC =self.arrivalVC;
            
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
