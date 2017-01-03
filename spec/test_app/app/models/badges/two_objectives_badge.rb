class TwoObjectivesBadge < AdHonorem::Badge
  attribute :slug,          'two_objectives_badge'
  attribute :name,          'Two Objectives badge'
  attribute :description,   'This is a two-objectives badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'two_objectives.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'two_objectives.png')
  attribute :legacy,        false

  def initialize
    super

    add_objective(:use_longbow, 'Longbow', 'Use your longbow for the first time')
    add_objective(:use_sword, 'Sword', 'Use your sword 5 times', 5)
  end

  def use_longbow(user, params)
    true
  end

  def use_sword(user, params)
    true
  end
end
