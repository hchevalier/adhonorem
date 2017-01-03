module AdHonorem
  # Represent a badge objective
  # Re-created on-the-fly at each badge instantiation
  class Objective
    attr_reader :slug, :name, :description, :amount_needed

    def initialize(slug, name, description, amount_needed = 1)
      @slug = slug
      @name = name
      @description = description
      @amount_needed = amount_needed
    end
  end
end
