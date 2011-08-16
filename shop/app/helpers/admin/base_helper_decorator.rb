Admin::BaseHelper.class_eval do
  def preference_field_for_weight(form, field, options)
    case options[:type]
    when :string
      form.text_field(field, {
          :size => 10,
          :class => 'input_string',
          :readonly => options[:readonly],
          :hidden => true,
          :disabled => options[:disabled]
        }
      )
    end
  end

  def preference_fields(object, form)
    return unless object.respond_to?(:preferences)
  if object.class.to_s == 'Calculator::WeightRate'
    # FIXME предусмотреть проверку что б каждый след интервал был больше предыдущего
    # тоже с ценой
    # валидация что б вводились только цыфры
    # script calculate all intervals to json and store as string
    jscript = <<EOF
<script src="/javascripts/jquery.json-2.2.min.js" type="text/javascript"></script>
<script>


$(document).ready(function() {
  $('#shipping_method_calculator_attributes_preferred_interval').after('<br/>From 0 to <ul id="inteval_listing"></ul><a href="" id="link_add_interval">Add interval</a>');
  var str = $('#shipping_method_calculator_attributes_preferred_interval').val();



  if (str) {
    var obj = jQuery.parseJSON(str);
    for (key in obj) {
      $('#inteval_listing').append('<p><li id="' +key+ '"><input id="interval_' + key + '" value="' +obj[key]["int"]+ '"/><input id="cost_' +key+ '" value="' +obj[key]["cost"]+'"/></li></p>');
    };
  } else {
      $('#inteval_listing').append('<p><li id="0"><input id="interval_0"/><input id="cost_0"/></li></p>');
  }


  $('#inteval_listing>li').map ( function() {
    var id = $(this).attr('id');
    $('#interval_'+id).bind('change', function() {
      setValues();
    });
    $('#cost_'+id).bind('change', function() {
      setValues();
    });
  });

  // add new fields for intervals
  $('#link_add_interval').bind('click', function() {
      var key = $('#inteval_listing>li').size();
      $('#inteval_listing').append('<p><li id="' +key+ '"><input id="interval_' + key + '" value=""/><input id="cost_' +key+ '" value=""/></li></p>');
      $('#interval_'+key).bind('change', function() {
        setValues();
      });
      $('#cost_'+key).bind('change', function() {
        setValues();
      });
  });
});

function setValues() {
    var res = $('#inteval_listing>li').map ( function() {
      // collect all data from li
      var id = $(this).attr('id');
      // interval max field
      var interval = $('#interval_' + id ).val();
      // cost
      var cost = $('#cost_' + id).val();
      if (cost && interval) {
        var resl = new Object();
        resl['int'] = interval;
        resl['cost'] = cost;
        return resl;
      }
    }).get();
    // set value to hidden test field
    $('#shipping_method_calculator_attributes_preferred_interval').val($.toJSON(res));
}


</script>
EOF
result = object.preferences.keys.map{ |key|
      next unless object.class.preference_definitions.has_key? key

      definition = object.class.preference_definitions[key]
      type = definition.instance_eval{@type}.to_sym

      form.label("preferred_#{key}", t(key)+": ") +
        preference_field_for_weight(form, "preferred_#{key}", :type => type)
    }.join("<br />")
    (result + jscript).html_safe
=begin
    {{:int => 10, :cost => 2 },{:int => 20, :cost => 4}}
    1.парсим строку {"1":{"int":10,"cost":2},"2":{"int":20,"cost":4}}
    $('#shipping_method_calculator_attributes_preferred_interval').val()
    2 если пустая - показываем одно поле для веса и после для цены
    $('#shipping_method_calculator_attributes_preferred_interval').after('<ul id="inteval_listing"><li id="1"><input id="interval_1"/><input id="cost_1"/></li></ul>')
    3 если изменяется - то формируем с разу строку
    $('#int_1').bind('change', function() {
      $('#interval_1').val()
      $('#cost_1').val()
    });
    4 если нажимается кнопка "добавить" - то добавлем поле и опять же обрабатывает каждое изменение
    $("#inteval_listing").append('<li id="2"><input id="interval_2"/><input id="cost_2"/></li>')
    5 при нажатии сохранить в строке должны быть уже все параметры подготовленны к отправке
=end
  else
    object.preferences.keys.map{ |key|
      next unless object.class.preference_definitions.has_key? key

      definition = object.class.preference_definitions[key]
      type = definition.instance_eval{@type}.to_sym

      form.label("preferred_#{key}", t(key)+": ") +
        preference_field(form, "preferred_#{key}", :type => type)
    }.join("<br />").html_safe
  end
  end
end
