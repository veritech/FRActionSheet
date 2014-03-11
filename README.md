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

Pero Espera, hay mas!
---------------------
There are also a series of subclasses for creating different types of action sheets:

**FRDateActionSheet**
An actionsheet with a *UIDatePicker*. Supports all the formats of *UIDatePicker* and a month picker.

	FRDateActionSheet *sheet;
	
	//This will display a list of *Localized* month names, (January, February or Enero, Febrero)
	sheet = [[FRDateActionSheet alloc] initWithTitle:
										 minimumDate:[NSDate distantPast]
										 maximumDate:[NSDate distantFuture]
										 datePickerMode:FRDateActionSheetMonthMode
										 handler:^(FRDateActionSheet *sheet, NSDate *date){
											 ...
										 }];
		
	[sheet showInView:aView];

**FRPickerActionSheet**
An actionsheet with a *UIPickerView*, the contents of picker can be supplied as a dictionary.

	FRPickerActionSheet *sheet;
	
	sheet = [[FRPickerActionSheet alloc] initWithTitle:@"Best cities in the world?" 
												handler:^(FRPickerActionSheet *sheet, NSUInteger idx){
													NSString *optionKey;
									
													optionKey = [[sheet sortedPickerOptionKeys] objectAtIndex:idx];
									
													//The Value assocated with the chosen key
													[[sheet pickerOptions] objectForKey:optionKey];													
												}];
	
	[sheet showInView:aView];
												
	//Your options can be loaded at anytime, before or after you present the sheet
	// The format is DISPLAY STRING -> IDENTIFIER
	[sheet setPickerOptions:@{
		@"Paris":@1,
		@"London":@2,
		@"New York":@3
		}];
	
	//You can also have you picker options sorted
	[sheet setSortDescriptors:@[
		...
	]];
	

**FRNetworkedPickerActionSheet**
Exactly the same as above, but you can supply a *NSURLRequest* (aka it will work authenticated API's!) and the keypath in your JSON that you want to extract your entries from. Que Chevere!
The request is loaded using NSURLConnection, and the parsing of the JSON is done with NSJSONSerialization and done off the main thread.

	FRNetworkedPickerActionSheet *sheet;
	
	/*
	*	Example JSON at amazingPlaces.com 
	*	{"countries":[{"id":1,"name":"Colombia"},{"id":2,"name":"Hong Kong"}, ...]}
	*/
	
	sheet = [[FRNetworkedPickerActionSheet alloc] initWithTitle:@"Whats your favorite country?"
							    request:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://amazingPlaces.com/api/countries.json"]]
							    keyPath:@"countries"
								mapping:^(id obj){
									//Note: This block is not run on the main thread
									return @{[obj valueForKeyPath:@"name"]:[obj valueForKeyPath:@"id"]}
								}
								handler:^(FRNetworkedPickerActionSheet *sheet, NSUInteger idx){
									
									NSString *optionKey;
									
									optionKey = [[sheet sortedPickerOptionKeys] objectAtIndex:idx];
									
									//The Value assocated with the chosen key
									[[sheet pickerOptions] objectForKey:optionKey];
									
									}];
									
	[sheet showInView:aView]

Change Log
-----------

* 0.0.3 (11/03/2014)
	* Can set the default/initial date of a FRDataActionSheet

* 0.0.2 (05/03/2014)
	* Added notifications for when the sheet will/did appear/disappear

* 0.0.1 (25/02/2014)
	* Initial Release
 

Author
------
[Jonathan Dalrymple](http://twitter.com/veritech)
