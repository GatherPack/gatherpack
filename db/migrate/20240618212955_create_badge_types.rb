class CreateBadgeTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :badge_types, id: :uuid do |t|
      t.string :name

      t.timestamps
    end
  end
end
