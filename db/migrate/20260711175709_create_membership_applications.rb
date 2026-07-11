class CreateMembershipApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :membership_applications, id: :uuid do |t|
      t.references :person, null: false, foreign_key: true, type: :uuid
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.text :message
      t.integer :status, null: false, default: 0
      t.datetime :reviewed_at
      t.text :reviewer_notes

      t.timestamps
    end

    add_index :membership_applications, [ :person_id, :team_id ],
      unique: true,
      where: "status = 0",
      name: "index_membership_applications_on_person_id_and_team_id_pending"
  end
end
