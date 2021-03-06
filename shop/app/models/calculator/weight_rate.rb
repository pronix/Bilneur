class Calculator::WeightRate < Calculator
  require 'json'

  # require define intervals { 10 => 20, 30 => 40 }
  # 10 20 from 0 to 10 cost 20
  # 30 40 from 10 to 30 cost 40
  # Save as yaml
  preference :interval, :string

  def self.description
    I18n.t("weight_rate")
  end

  def self.available?(object)
    true
  end
  def self.register
    super
    ShippingMethod.register_calculator(self)
  end

  # 1. calculate full weight for order (we can't know package's weight )
  # 2. find interval
  # 3. return shipping cost
  def compute(object)
    @seller = self.calculable.seller if self.calculable && self.calculable.respond_to?(:seller)
    weight = object.weight(@seller)
    # find weight range
    arr = JSON.parse(preferred_interval)
    # sort by inerval from smalles to biggest
    arr = arr.to_enum.sort_by {|x| x['int']}
    arr.each do |h|
      if  weight.to_f < h['int'].to_f
        cost = h['cost'].to_f
        break
      end
    end
    # if not find range - maximum cost
    cost = arr.map {|x| x['cost']}.max.to_f unless cost
    cost
  end


  # Compute shipping for one variant
  #
  def compute_for_one_variant(variant)
    weight = variant.weight
    # find weight range
    arr = JSON.parse(preferred_interval)
    # sort by inerval from smalles to biggest
    arr = arr.to_enum.sort_by {|x| x['int']}
    arr.each do |h|
      if  weight.to_f < h['int'].to_f
        cost = h['cost'].to_f
        break
      end
    end
    # if not find range - maximum cost
    cost = arr.map {|x| x['cost']}.max.to_f unless cost
    cost
  end

end
