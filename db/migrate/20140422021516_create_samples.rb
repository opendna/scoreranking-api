class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.integer :id
      t.string :name

      t.timestamps
    end
  end
end
