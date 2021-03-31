class CreateAlerts < ActiveRecord::Migration[6.1]
  def change
    create_table :alerts do |t|
      t.string :status
      t.integer :threshold_id
      t.jsonb :metric, default: {}, null: false
      t.timestamps
    end
    add_index :alerts, :threshold_id
  end
end
