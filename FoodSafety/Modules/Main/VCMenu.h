//
//  VCMenu.h
//  FoodSafety
//
//  Created by BoHuang on 8/16/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCMenu : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger itemPerRow;
@property (strong, nonatomic) NSMutableArray* items;
@property (assign, nonatomic) UIEdgeInsets  sectionInsects;
@property (assign, nonatomic) NSArray*  menuStrings;


@end
