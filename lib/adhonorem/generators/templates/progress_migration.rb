# AdHonorem::Progress will save the progress of your users for every badge
class CreateAdhonoremProgress < ActiveRecord::Migration
  def change
    create_table :adhonorem_progresses do |t|
      t.integer :user_id
      t.string :objective_slug
      t.integer :numeric_progress, default: 0
    end
    bind_static_record :adhonorem_progresses, :badge
  end
end
