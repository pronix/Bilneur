Image.class_eval do
  has_attached_file :attachment,
                    :styles => {
                        :t122    => ['122x100>', :png],
                        :mini    => ['48x48>',   :png],
                        :small   => ['100x100>', :png],
                        :product => ['240x240>', :png],
                        :large   => ['600x600>', :png] },
                    :default_style => :product,
                    :url => "/assets/products/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension",
                    :convert_options => {
                      :t122 => '-background none -layers merge +repage -gravity center -extent 122x100 ' }

end
