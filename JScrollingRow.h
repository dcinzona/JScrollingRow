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


@class JScrollingRow;
@class JScrollingRowCell;


@protocol JScrollingRowDataSource
// indexPath is provided as a reference to which section/row you may be in if you choose to place this in a UITableView.
// You must set the indexPath property of JScrollingRow prior to receiving this delegate in order for the appropriate
// indexPath when this delegate is fired.
- (NSUInteger)numberOfColumnsInRow:(JScrollingRow*)scrollingRowView atIndexPath:(NSIndexPath*)indexPath;
- (JScrollingRowCell*)scrollingRowView:(JScrollingRow*)scrollingRowView cellForColumnAtIndex:(NSUInteger)index;
@end


@protocol JScrollingRowDelegate
@required
// Widths of cells may be of varying sizes.
- (CGFloat)scrollingRowView:(JScrollingRow*)scrollingRowView widthForCellAtIndex:(NSUInteger)index;
@optional
- (void)scrollingRowView:(JScrollingRow*)scrollingRowView didSelectCellAtIndex:(NSUInteger)index;
@end



@interface JScrollingRow : UIScrollView
{
	NSMutableSet* recycledCells;
	NSMutableSet* visibleCells;
	NSIndexPath* _indexPath;
	id<JScrollingRowDataSource> _dataSource;
}


@property (nonatomic, retain) NSIndexPath* indexPath;
@property (nonatomic, assign) id<JScrollingRowDataSource> dataSource;
@property (nonatomic, assign) id<JScrollingRowDelegate, UIScrollViewDelegate> delegate;


- (JScrollingRowCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier;
- (void)layoutCells;


@end
