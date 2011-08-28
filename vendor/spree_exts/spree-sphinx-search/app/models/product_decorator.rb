Product.class_eval do
  class_inheritable_array :indexed_options
  self.indexed_options = []

  define_index do
    is_active_sql = "(products.deleted_at IS NULL AND products.available_on <= NOW() #{'AND (products.count_on_hand > 0)' unless Spree::Config[:allow_backorders]} )"
    option_sql = lambda do |option_name|
      sql = <<-eos
        SELECT DISTINCT p.id, ov.id
        FROM option_values AS ov
        LEFT JOIN option_types AS ot ON (ov.option_type_id = ot.id)
        LEFT JOIN option_values_variants AS ovv ON (ovv.option_value_id = ov.id)
        LEFT JOIN variants AS v ON (ovv.variant_id = v.id)
        LEFT JOIN products AS p ON (v.product_id = p.id)
        WHERE (ot.name = '#{option_name}' AND p.id>=$start AND p.id<=$end);
        #{source.to_sql_query_range}
      eos
      sql.gsub("\n", ' ').gsub('  ', '')
    end

    quoted_false = "'f'"

    variant_conub_on_hand = lambda do |v|
      sql_variant_on_hand = <<-eos
        COALESCE(
          ( SELECT max(variants.count_on_hand)
            FROM variants
            WHERE (
              variants.is_master = #{quoted_false}
              AND variants.product_id = products.id AND variants.deleted_at is null AND condition = '#{v}'
             )
            GROUP BY variants.price
            ORDER BY variants.price ASC
            LIMIT 1
         ),0)
      eos
      sql_variant_on_hand
    end


    indexes :name
    indexes :description
    indexes :meta_description
    indexes :meta_keywords
    # indexes variants(:condition), :as => :condition
    indexes taxons.name, :as => :taxon, :facet => true
    # indexes variants(:price), :as => :variant_price
    has taxons(:id), :as => :taxon_ids

    has variants(:condition_int), :as => :variants_conditions

    has "(SELECT min(variants.price) FROM variants
            WHERE (
              variants.is_master = #{quoted_false}
              AND variants.product_id = products.id
              AND variants.deleted_at IS NULL
              AND variants.count_on_hand > 0
            )
          )", :as => :variant_price, :sort => true,  :type => :float, :source => :range_query

    %w(new used another).each do |variant_condition|
      has variant_conub_on_hand.call(variant_condition), :as => :"variant_#{variant_condition}_on_hand",
                                                         :sort => true, :type => :integer, :source => :query
    end

    has "COALESCE(
          ( SELECT max(variants.count_on_hand)
            FROM variants
            WHERE (variants.is_master = #{quoted_false}
                   AND variants.product_id = products.id
                   AND variants.deleted_at is null)
            GROUP BY variants.price
            ORDER BY variants.price ASC
            LIMIT 1
           ),0)", :as => :variant_on_hand, :sort => true, :type => :integer, :source => :query

    group_by :"products.deleted_at"
    group_by :available_on
    has is_active_sql, :as => :is_active, :type => :boolean
    source.model.indexed_options.each do |opt|
      has option_sql.call(opt.to_s), :as => :"#{opt}_option", :source => :ranged_query, :type => :multi, :facet => true
    end
  end
end
