class CreateExclusions < ActiveRecord::Migration
  def change
    create_table :exclusions do |t|
      t.text :note
      t.references :diagnosis, index: true
      t.integer :exclusion_type

      t.timestamps
    end
  end
end
