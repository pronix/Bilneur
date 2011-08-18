// jQuery minMaxSlider Plugin
//
// Version 1.10
//
// Lindsay Stuart
// Flameweb Web Development (http://www.flameweb.net/)
// 7 January, 2010
//
// Visit http://www.flameweb.net/minmaxslider for more information
//
// Usage: $("div#slider").minMaxSlider(options)
//
// Options: slider  		By default the slider is attached to the calling element. With this option you can set it to something else.
//			min_input 		This is the tag that identifies the minimum input box for the slider.
//			max_output 		This is the tag that identifies the maximum input box for the slider.
//			min_size 		This sets the minimum size of the slider, default = 0.
//			max_size 		This sets the maxium size of the slider, default = 500.
//			sync_inputs 	This sets whether the input values and slider values are synchronised at all times. For instance this may be useful when you allow the max input to have a higher value then might be displayed on the slider.
//
// History:
//
// 1.00 - released (7 January, 2010)
// 1.10 - released (14 March, 2010)
//
// TERMS OF USE
// 
// This plugin is dual-licensed under the GNU General Public License and the MIT License and
// is copyright 2008 A Beautiful Site, LLC. 

(function($) {
 
	$.fn.minMaxSlider = function(settings) {
		var config = {
						'slider'		:			 $(this),           		// the tag of the selected slider
						'min_input'		:			'#min_input',				// the tag of the associated min input
						'max_input'		:			'#max_input',				// the tag of the associate max input
						'min_size'		:			0,							// the min value of the slider
						'max_size'		:			500,						// the max value of the slider
						'sync_inputs'	:			true						// sets whether input fields are identical to slider fields
		};
 
		if (settings) {
			settings = $.extend(config, settings);
		}

		this.each(function() {
			// get input values and set as slider defaults
			var min_value = $(settings.min_input).attr("value");
			var max_value = $(settings.max_input).attr("value");
			// add the slider
			$(this).slider({
				range: true,
				min: settings.min_size,
				max: settings.max_size,
				values: [min_value, max_value],
				slide: function(event, ui) {
					$(settings.min_input).val(ui.values[0]);
					$(settings.max_input).val(ui.values[1]);
				}
				
			});
			// add listener to min input
			$(settings.min_input).change(changeSlider);
			// add listener to max input
			$(settings.max_input).change(changeSlider);
			return this;
		});
		
		function changeSlider() {
			// change the slider handles based on value of inputs
            var new_value = parseInt($(this).val()); // value of input
            var index; // which handle to move
			if ($(this).attr('name') == $(settings.min_input).attr('name')) {
				// min slider
				index = 0;
                new_value = Math.min(new_value, parseInt($(settings.max_input).val()));
			}
			else {
				// max slider
				index = 1;
                new_value = Math.max(new_value, parseInt($(settings.min_input).val()));
			}
			if (new_value < settings.min_size) new_value = settings.min_size;
			else if (new_value > settings.max_size) new_value = settings.max_size;
			// sync if allowed
			if (settings.sync_inputs) $(this).val(new_value);
			// set the slider
			$(settings.slider).slider('values',index,new_value);
			return this;
		}
   };
 
})(jQuery);
