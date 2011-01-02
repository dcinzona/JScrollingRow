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

// Called before a cell is reused. If you override this, ensure you call [super prepareForReuse]
// prior to your implementation.
- (void)prepareForReuse;


@end
