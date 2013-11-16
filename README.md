FRActionSheet
=============

Much like Reeses cups, things are better when they are fused together.

Whether it's Peanut butter and Chocolate, Jazz and Hip Hop or ActionSheets and nibs ...

Nib based Usage
---------------
Yes action sheets and nibs, and it's as simple as:

	[[[FRActionSheet alloc] initWithNibNamed:@"My Nib" 
									handler:^(FRActionSheet *sheet, NSInteger idx){
										//Handle business
										}] showInView:[self view]];
										
That's all! The handler block will be called when any button in your nib is pressed 
and will provide the tag of that button for reference.

Conventional Usage
------------------
If your from the school of thought that thinks nibs are for noobs, 
then you can also use the action sheet in a conventional manner.