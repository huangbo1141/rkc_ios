//
//  VCPrint.h
//  FoodSafety
//
//  Created by BoHuang on 9/5/17.
//  Copyright © 2017 ITLove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWPrint.h"
#import "LWPrintDiscoverPrinter.h"
@interface VCPrint : UIViewController<LWPrintDelegate, LWPrintDiscoverPrinterDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *statusIndicator;
@property (nonatomic, weak) IBOutlet UIButton *printButton;

@property (strong, nonatomic) NSMutableArray* printers;
@property (strong, nonatomic) LWPrintDiscoverPrinter* discover;
@property (nonatomic) BOOL processing;

@property (strong, nonatomic) NSString* printType;
@end
