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
If your from the school of thought that thinks nibs are for amatures, 
then you can also use the action sheet in a conventional manner.

	[[[FRActionSheet alloc] initWithButtonTitles:@[@"Button title A",@"Button title B"] 
										handler:^(FRActionSheet *sheet, NSInteger idx){
											//Handle business
										}] showInView:[self view]];

Customizing the beast
---------------------
UI customization is sucky. I think the only think that sucks more than customizing UIKit, is customizing UIKit replacement components.

Using the *decorator* property you can assign a delegate object to your action sheet that will style the buttons and title views.

If you want to customize the internal layout of the buttons, and still don't want to create a nib, you can create a subclass and overload the *layoutTitleLabel:buttons:inView:* method.

This class using Auto layout internally (Because it's awesome), but can be used in views that do not support it.

Author
------
[Jonathan Dalrymple](http://twitter.com/veritech)