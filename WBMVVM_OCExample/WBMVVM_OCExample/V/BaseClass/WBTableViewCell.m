//
//  WBTableViewCell.m
//  WBMVVM_OCExample
//
//  Created by wenbo on 2020/8/28.
//  Copyright © 2020 huibo2. All rights reserved.
//

#import "WBTableViewCell.h"

@implementation WBTableViewCell

+ (NSString *)identifier {
    return [NSString stringWithCString:object_getClassName([self class]) encoding:NSUTF8StringEncoding];
}

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:self.identifier forIndexPath:indexPath];
}

+ (instancetype)dequeueReusableCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WBTableViewCell";
    WBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
        [self bindViewModel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self makeUI];
        [self bindViewModel];
    }
    return self;
}

- (void)makeUI {}
- (void)bindViewModel {}
- (void)bindViewModel:(id)viewModel {}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
