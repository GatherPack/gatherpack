class AddTeamReferenceToRelationships < ActiveRecord::Migration[8.0]
  def change
    change_table :relationships do |t|
      t.references :team, null: true, type: :uuid
    end
  end
end
