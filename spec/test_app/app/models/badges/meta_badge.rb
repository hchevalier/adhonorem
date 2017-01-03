class MetaBadge < AdHonorem::Badge
  attribute :slug,          'meta_badge'
  attribute :name,          'Meta badge'
  attribute :description,   'This is a meta badge'
  attribute :category,      'General'
  attribute :points,        10
  attribute :icon_locked,   Rails.root.join('public', 'badges', 'locked', 'meta.png')
  attribute :icon_unlocked, Rails.root.join('public', 'badges', 'unlocked', 'meta.png')
  attribute :legacy,        true

  hook :level_up, to: :level_up

  def initialize
    super

    add_sub_badge(:sub_badge_one)
    add_sub_badge(:sub_badge_two)
  end
end
