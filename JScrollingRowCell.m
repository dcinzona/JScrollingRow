/*
 * JScrollingRow
 * Copyright © 2010, Jeremy Tregunna, All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

#import "JScrollingRowCell.h"


const NSInteger kJScrollingRowCellSeparatorViewTag = 999;


@interface JScrollingRowCell ()
@property (nonatomic, retain) UIView* contentView;
@end


@implementation JScrollingRowCell


@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize contentView = _contentView;
@synthesize index = _index;
@synthesize separatorStyle = _separatorStyle;
@synthesize separatorColor = _separatorColor;


#pragma mark -
#pragma mark Creation, instantiation, deletion


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)identifier
{
	if((self = [super initWithFrame:frame]))
	{
		_reuseIdentifier = [identifier copy];
		_separatorStyle = kJScrollingRowCellSeparatorStylePlain;
		_separatorColor = [UIColor blackColor];
	}
	return self;
}


- (void)dealloc
{
	[_contentView release];
	[super dealloc];
}


#pragma mark -
#pragma mark View


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.contentView.frame = self.bounds;
}


#pragma mark -
#pragma mark Cell reuse


- (void)prepareForReuse
{
}


#pragma mark -
#pragma mark Accessors


- (UIView*)contentView
{
	if(_contentView == nil)
	{
		_contentView = [[UIView alloc] initWithFrame:self.bounds];
		_contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_contentView.autoresizesSubviews = YES;
		_contentView.backgroundColor = [UIColor whiteColor];
		[self addSubview:_contentView];
		self.autoresizesSubviews = YES;
	}
	
	return _contentView;
}


@end
