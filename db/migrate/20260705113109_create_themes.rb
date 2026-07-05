class CreateThemes < ActiveRecord::Migration[8.1]
  def change
    create_table :themes, id: :uuid do |t|
      t.text :css_variables
      t.text :custom_css
      t.string :pwa_theme_color, default: "#ffffff"
      t.string :pwa_background_color, default: "#ffffff"

      t.timestamps
    end
  end
end
