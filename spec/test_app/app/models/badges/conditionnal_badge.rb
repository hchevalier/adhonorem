class ConditionnalBadge < AdHonorem::Badge
  attribute :slug,          'conditionnal_badge'
  attribute :name,          'Conditionnal badge'
  attribute :description,   'This is a conditionnal badge'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'conditionnal.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'conditionnal.png')
  attribute :legacy,        false

  reference :category,      AdHonorem::Category.find('other')

  def initialize
    super

    add_objective(:whoami, 'I am your father', 'You must be called Darth Vader to finish me')
  end

  def whoami(user, params)
    user.name == 'Darth Vader'
  end
end
