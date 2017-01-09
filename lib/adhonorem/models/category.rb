module AdHonorem
  # AdHonorem core class, must be inherited from
  class Category < ::StaticRecord::Base
    table       :categories
    path        Rails.root.join('app', 'models', 'categories', '**', '*.rb')
    primary_key :slug

    columns slug:             :string,
            name:             :string
  end
end
