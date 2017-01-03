class LegacyBadge < AdHonorem::Badge
  attribute :slug,          'legacy_badge'
  attribute :name,          'Legacy badge'
  attribute :description,   'This is a legacy badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'legacy.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'legacy.png')
  attribute :legacy,        true

  def initialize
    super

    add_objective(:try_me, 'Alpha tester', 'Granted to heroes who tested the alpha')
  end

  def try_me(user, params)
    true
  end
end
