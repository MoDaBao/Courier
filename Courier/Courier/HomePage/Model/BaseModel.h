//
//  BaseModel.h
//  peisongduan
//
//  Created by 莫大宝 on 16/6/27.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic, copy) NSString *_version_;
@property (nonatomic, copy) NSString *all_price;
@property (nonatomic, copy) NSString *bonus_id;
@property (nonatomic, copy) NSString *bonus_price;
@property (nonatomic, copy) NSString *buy_price;
@property (nonatomic, copy) NSString *cancel_price;
@property (nonatomic, copy) NSString *cancel_user;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *createuser;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *distance_price;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *end_latitude;
@property (nonatomic, copy) NSString *end_longitude;
@property (nonatomic, copy) NSString *end_phone;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *is_cancel;
@property (nonatomic, copy) NSString *is_del;
@property (nonatomic, copy) NSString *is_evaluation;
@property (nonatomic, copy) NSString *ltime;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *pay_status;
@property (nonatomic, copy) NSString *payment;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *psend_time;
@property (nonatomic, copy) NSString *puserphone;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *start_latitude;
@property (nonatomic, copy) NSString *start_longitude;
@property (nonatomic, copy) NSString *start_phone;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *userphone;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *name;


@end
