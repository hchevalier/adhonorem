class SubBadgeTwo < AdHonorem::Badge
  attribute :slug,          'sub_badge_two'
  attribute :name,          'Sub badge two'
  attribute :description,   'This is the second sub badge'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'sub_badge_two.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'sub_badge_two.png')
  attribute :legacy,        false

  def initialize
    super

    add_objective(:level_up, 'Ding!', 'Reach level 20')
  end

  def level_up(user, params)
    user.level >= 20
  end
end
