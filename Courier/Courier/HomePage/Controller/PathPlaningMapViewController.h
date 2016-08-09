//
//  MapViewController.h
//  Courier
//
//  Created by 莫大宝 on 16/7/1.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"

@interface PathPlaningMapViewController : UIViewController

@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, assign) BOOL isDefault;

@end
