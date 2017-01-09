module AdHonorem
  module Scopes # :nodoc:
    def by_category
      all.group_by { |record| record.category.name }
    end
  end
end
