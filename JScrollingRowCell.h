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

#import <UIKit/UIKit.h>


extern const NSInteger kJScrollingRowCellSeparatorViewTag;

// None - no separator will be drawn
// Plain - Single 1px line will be drawn, this is the default
typedef enum
{
	kJScrollingRowCellSeparatorStyleNone,
	kJScrollingRowCellSeparatorStylePlain
} JScrollingRowCellSeparatorStyle;


@interface JScrollingRowCell : UIView
{
	NSString* _reuseIdentifier;
	UIView* _contentView;
	NSUInteger _index;
	JScrollingRowCellSeparatorStyle _separatorStyle;
	UIColor* _separatorColor;
}


@property (nonatomic, readonly, copy) NSString* reuseIdentifier;
@property (nonatomic, readonly, retain) UIView* contentView;
@property (assign) NSUInteger index;
@property (nonatomic, assign) JScrollingRowCellSeparatorStyle separatorStyle;
@property (nonatomic, retain) UIColor* separatorColor;


- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString*)reuseIdentifier;

// Called before a rell is reused. If you override this, ensure you call [super prepareForReuse]
- (void)prepareForReuse;


@end
