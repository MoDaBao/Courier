//
//  SearchView.m
//  Courier
//
//  Created by 莫大宝 on 16/7/14.
//  Copyright © 2016年 dabao. All rights reserved.
//

#import "SearchView.h"

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    self.layer.cornerRadius = 4;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:0.75 green:0.12 blue:0.16 alpha:1.00].CGColor;
    
    self.confirmBtn.layer.cornerRadius = 4;
    
    self.mainAddress.delegate = self;
}

- (IBAction)confirm:(id)sender {
    
//    self.confirm();
    if ([self.delegate respondsToSelector:@selector(confirm)]) {
        [self.delegate confirm];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
     NSString *str = [NSString stringWithFormat:@"%@%@",textField.text, string];
//    self.search(str);
    if ([self.delegate respondsToSelector:@selector(searchWithStr:)]) {
        [self.delegate searchWithStr:str];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    self.edit();
    if ([self.delegate respondsToSelector:@selector(edit)]) {
        [self.delegate edit];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    self.end();
    if ([self.delegate respondsToSelector:@selector(end)]) {
        [self.delegate end];
    }
}

@end
