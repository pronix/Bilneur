class Calculator::WeightRate < Calculator

  # FIXME require define intervals { 10 => 20, 30 => 40 }
  # 10 20 from 0 to 10 cost 20
  # 30 40 from 10 to 30 cost 40
  # FIXME add ability for to define more or less ranges
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
    weight = object.weight
    # find weight range
    hash = YAML::parse(preference['interval']).transform
    hash.each do |k,v|
      if k < weight
        cost = v
        break
      end
    end
    # if not find range - maximum cost
    cost = hash.values.max
    cost
  end
end
