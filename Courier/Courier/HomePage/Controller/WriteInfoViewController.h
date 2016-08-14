//
//  WriteInfoViewController.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/20.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteInfoView_2.h"
#import "BaseModel.h"

typedef void(^RefreshBlock)(void);
typedef void(^RefreshModel)(BaseModel *);

@interface WriteInfoViewController : UIViewController

@property (nonatomic, strong) BaseModel *baseModel;

@property (nonatomic, copy) RefreshBlock refresh;
@property (nonatomic, copy) RefreshModel refreshModel;


@end
