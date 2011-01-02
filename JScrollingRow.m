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

#import "JScrollingRow.h"
#import "JScrollingRowCell.h"


@interface JScrollingRow (Private)
- (BOOL)isDisplayingCellForIndex:(NSUInteger)index;
- (void)layoutCells;
@end


@implementation JScrollingRow


@synthesize indexPath = _indexPath;
@synthesize dataSource = _dataSource;
@dynamic delegate;


#pragma mark -
#pragma mark Memory management


- (id)initWithFrame:(CGRect)frame
{
	if((self = [super initWithFrame:frame]))
	{
	[self setShowsVerticalScrollIndicator:NO];
		recycledCells = [[NSMutableSet alloc] init];
		visibleCells = [[NSMutableSet alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(emptyRecycledCells)
													 name:UIApplicationDidReceiveMemoryWarningNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[recycledCells release];
	[visibleCells release];
	[_indexPath release];
	[super dealloc];
}


#pragma mark -
#pragma mark Dealing with reusable cells


- (BOOL)isDisplayingCellForIndex:(NSUInteger)index
{
	BOOL foundCell = NO;
	
	for(JScrollingRowCell* cell in visibleCells)
	{
		if(cell.index == index)
		{
			foundCell = YES;
			break;
		}
	}
	
	return foundCell;
}


- (CGRect)frameForCellAtIndex:(NSUInteger)index
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the cell placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = self.bounds;
    CGRect cellFrame = bounds;
    cellFrame.size.width = [self.delegate scrollingRowView:self widthForCellAtIndex:index];
    cellFrame.origin.x = cellFrame.size.width * index;
    return cellFrame;
}


- (void)layoutCells
{
	// Calculate which pages should be visible
	CGRect visibleBounds = self.bounds;
	NSUInteger numCells = [self.dataSource numberOfColumnsInRow:self atIndexPath:self.indexPath];
	CGFloat cellWidths[numCells];
	CGFloat temp = 0.0f;
	NSInteger firstNeededCellIndex = 0;
	NSInteger lastNeededCellIndex = 0;
	NSUInteger numVisibleCellIndices = 0;
	CGPoint contentOffset = self.contentOffset;
	CGFloat visibleMaxX = CGRectGetMaxX(visibleBounds);
	
	for(NSUInteger i = 0; i < numCells; i++)
	{
		cellWidths[i] = [self.delegate scrollingRowView:self widthForCellAtIndex:i];
		temp += cellWidths[i];
		if(temp < contentOffset.x)
			firstNeededCellIndex = i;
		else if(temp >= contentOffset.x + visibleMaxX && temp - cellWidths[i] < contentOffset.x + visibleMaxX)
			lastNeededCellIndex = firstNeededCellIndex + 1 + numVisibleCellIndices + 1;
	}
	
	// Sanity checking
	if(lastNeededCellIndex >= numCells)
		lastNeededCellIndex = numCells - 1;
	if(lastNeededCellIndex < 0)
		lastNeededCellIndex = firstNeededCellIndex = 0;
	
	// Recycle no longer needed cells
	for(JScrollingRowCell* cell in visibleCells)
	{
		if(cell.index < firstNeededCellIndex || cell.index > lastNeededCellIndex)
		{
			[recycledCells addObject:cell];
			[cell removeFromSuperview];
		}
	}
	
	// Remove recycled items from the visible set
	[visibleCells minusSet:recycledCells];
	
	// Add any missing cells
	for(NSUInteger index = firstNeededCellIndex; index <= lastNeededCellIndex; index++)
	{
		if(![self isDisplayingCellForIndex:index])
		{
			JScrollingRowCell* cell = [self.dataSource scrollingRowView:self cellForColumnAtIndex:index];
			cell.frame = [self frameForCellAtIndex:index];
			
			if(![cell viewWithTag:kJScrollingRowCellSeparatorViewTag])
			{
				switch(cell.separatorStyle)
				{
					case kJScrollingRowCellSeparatorStyleNone:
						break;
					case kJScrollingRowCellSeparatorStylePlain:
					{
						UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(cell.contentView.frame) - 1,
																						 0, 1, self.contentSize.height)];
						separatorView.tag = kJScrollingRowCellSeparatorViewTag;
						separatorView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
						separatorView.backgroundColor = cell.separatorColor;
						[cell.contentView addSubview:separatorView];
						[separatorView release];
						break;
					}
				}
			}
			
			[visibleCells addObject:cell];
			[self addSubview:cell];
		}
	}
}


- (JScrollingRowCell*)dequeueReusableCellWithIdentifier:(NSString*)identifier
{
	NSSet* filteredSet = [recycledCells filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"reuseIdentifier == %@", identifier]];
	JScrollingRowCell* cell = [filteredSet anyObject];
	if(cell)
	{
		// So our cell doesn't disappear when we return
		[[cell retain] autorelease];
		[recycledCells removeObject:cell];
	}
	
	return cell;
}


- (void)emptyRecycledCells
{
	[recycledCells removeAllObjects];
}


- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if(!self.dragging)
	{
		UITouch* touch = [touches anyObject];
		CGPoint location = [touch locationInView:self];
		
		NSUInteger numCells = [self.dataSource numberOfColumnsInRow:self atIndexPath:self.indexPath];
		CGFloat cellWidths[numCells];
		CGFloat temp = 0.0f;
		CGFloat temp2 = 0.0f;
		
		for(NSUInteger i = 0; i < numCells; i++)
		{
			cellWidths[i] = [self.delegate scrollingRowView:self widthForCellAtIndex:i];
			temp += cellWidths[i];
			
			if(location.x < temp && location.x >= temp2)
			{
				if([self.delegate respondsToSelector:@selector(scrollingRowView:didSelectCellAtIndex:)])
					[self.delegate scrollingRowView:self didSelectCellAtIndex:i];
			}
			
			temp2 += cellWidths[i];
		}		
	}
	else
		[super touchesEnded:touches withEvent:event];
}


@end
