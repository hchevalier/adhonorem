class SubBadgeOne < AdHonorem::Badge
  attribute :slug,          'sub_badge_one'
  attribute :name,          'Sub badge one'
  attribute :description,   'This is the first sub badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'sub_badge_one.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'sub_badge_one.png')
  attribute :legacy,        false

  def initialize
    super

    add_objective(:level_up, 'Ding', 'Reach level 10')
  end

  def level_up(user, params)
    user.level >= 10
  end
end
