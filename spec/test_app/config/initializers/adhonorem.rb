AdHonorem.configure do |config|
  config.user_class = 'User'
  config.default_points = 5
  config.locked_icon_path = Rails.root.join('public', 'badges', 'locked')
  config.unlocked_icon_path = Rails.root.join('public', 'badges', 'unlocked')
end
