//
//  LYFTTTravelNoteCell.m
//  TravelTogether
//
//  Created by 罗元丰 on 16/3/6.
//
//

#import "LYFTTTravelNoteCell.h"
#import "TTTravelNoteModel.h"

@interface LYFTTTravelNoteCell () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@implementation LYFTTTravelNoteCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 3, 100);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setModel:(TTTravelNoteModel *)model
{
    _model = model;
    self.titleLabel.text = model.noteTitle;
    
    CGFloat w =[UIScreen mainScreen].bounds.size.width;
    [self.mainImgView sd_setImageWithURL:[NSURL URLWithString:[model.imageUrlArray firstObject][@"photo_url"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMainImg)];
    [self.mainImgView addGestureRecognizer:tap];
    self.mainImgView.userInteractionEnabled = YES;
    self.mainImgHeight.constant = (w / model.size.width) * model.size.height;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TTItemForCollectionViewInCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"item"];
    
    [self.contentView layoutIfNeeded];
    
    NSString *noteDetail = model.noteDetail;
    // label 行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:noteDetail];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //调整行间距
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [noteDetail length])];
    
    self.descriptionLabel.attributedText = attributedString;
    [self.descriptionLabel sizeToFit];
    self.descriptionLabel.height = self.descriptionLabel.frame.size.height;
    model.heightForCell = self.descriptionLabel.frame.size.height + 170;
    
    [self.collectionView reloadData];
}

- (void)clickMainImg
{
    if(self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(mainImageClickedByImageUrlArr:andClickIndex:)])
    {
        [self.clickDelegate mainImageClickedByImageUrlArr:self.model.imageUrlArray andClickIndex:0];
    }
}

#pragma mark - <UICollectionViewDataSource, UICollectionViewFlowLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.imageUrlArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TTItemForCollectionViewInCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrlArray[indexPath.row][@"photo_url"]]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.clickDelegate && [self.clickDelegate respondsToSelector:@selector(mainImageClickedByImageUrlArr:andClickIndex:)])
    {
        [self.clickDelegate mainImageClickedByImageUrlArr:self.model.imageUrlArray andClickIndex:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
