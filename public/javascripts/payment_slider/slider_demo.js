var $jq = jQuery.noConflict();

$jq(function() {
	$jq("#slider").minMaxSlider({
		'min_input'	: '#min_price',
		'max_input' : '#max_price',
		'min_size'  : 0,
		'max_size'  : 5000
	});
});

var $jq = jQuery.noConflict();

$jq(function() {
	$jq("#slider2").minMaxSlider({
		'min_input'	: '#min_price2',
		'max_input' : '#max_price2',
		'min_size'  : 0,
		'max_size'  : 5000
	});
});
