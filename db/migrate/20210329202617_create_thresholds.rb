class CreateThresholds < ActiveRecord::Migration[6.1]
  def change
    create_table :thresholds do |t|
      t.string :name
      t.integer :min
      t.integer :max

      t.timestamps
    end
  end
end
