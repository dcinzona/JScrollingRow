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
