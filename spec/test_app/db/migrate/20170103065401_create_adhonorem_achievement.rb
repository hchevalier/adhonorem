class CreateAdhonoremAchievement < ActiveRecord::Migration
  def change
    create_table :adhonorem_achievements do |t|
      t.integer :user_id
      t.integer :state, default: 0
      t.datetime :unlocked_at

      t.timestamps null: false
    end
    bind_static_record :adhonorem_achievements, :badge
  end
end
