/*
 * JScrollingRow
 * Written by: Jeremy Tregunna, 2010.
 *
 * This is free and unencumbered software released into the public domain.
 * 
 * Anyone is free to copy, modify, publish, use, compile, sell, or
 * distribute this software, either in source code form or as a compiled
 * binary, for any purpose, commercial or non-commercial, and by any
 * means.
 * 
 * In jurisdictions that recognize copyright laws, the author or authors
 * of this software dedicate any and all copyright interest in the
 * software to the public domain. We make this dedication for the benefit
 * of the public at large and to the detriment of our heirs and
 * successors. We intend this dedication to be an overt act of
 * relinquishment in perpetuity of all present and future rights to this
 * software under copyright law.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
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
	// Currently doesn't do anything, but in the future, when cell selection highlights are introduced,
	// this is where we'll clear those, just in case. Be sure if you override this method, to call super
	// before you implement your custom behaviour.
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
