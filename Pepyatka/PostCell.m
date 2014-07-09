#import "PostCell.h"

// Solution from  http://stackoverflow.com/questions/18746929/using-auto-layout-in-uitableview-for-dynamic-cell-layouts-variable-row-heights

#define kLabelHorizontalInsets      15.0f
#define kLabelVerticalInsets        10.0f


static NSString *CellIdentifier = @"PostCell";

@implementation PostCell

+ (NSString *)reuseID {
    return CellIdentifier;
}

- (UILabel *)titleLabel {
    UILabel *l = [UILabel newAutoLayoutView];
    [l setLineBreakMode:NSLineBreakByTruncatingTail];
    [l setNumberOfLines:1];
    [l setTextAlignment:NSTextAlignmentLeft];
    [l setTextColor:[UIColor blackColor]];
    return l;
}

- (UILabel *)bodyLabel {
    UILabel *l = [UILabel newAutoLayoutView];
    [l setLineBreakMode:NSLineBreakByTruncatingTail];
    [l setNumberOfLines:0];
    [l setTextAlignment:NSTextAlignmentLeft];
    [l setTextColor:[UIColor darkGrayColor]];
    return l;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        titleL = [self titleLabel];
        bodyL = [self bodyLabel];
        
        [self.contentView addSubview:titleL];
        [self.contentView addSubview:bodyL];
        
        [self updateFonts];
    }
    
    return self;
}





#pragma mark - Updates

- (void)setBody:(NSString *)body {
    bodyL.text = body;
}

- (NSString *)body {
    return bodyL.text;
}

- (void)setTitle:(NSString *)title {
    titleL.text = title;
}

- (NSString *)title {
    return titleL.text;
}

- (void)updateFonts {
    titleL.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    bodyL.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (didSetupConstraints) { return; }
    
    [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [titleL autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [titleL autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kLabelVerticalInsets];
    [titleL autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [titleL autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    

    [bodyL autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleL withOffset:kLabelVerticalInsets relation:NSLayoutRelationGreaterThanOrEqual];
    
    [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [bodyL autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [bodyL autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kLabelHorizontalInsets];
    [bodyL autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kLabelHorizontalInsets];
    [bodyL autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];
    
    didSetupConstraints = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    bodyL.preferredMaxLayoutWidth = CGRectGetWidth(bodyL.frame);
}



@end
