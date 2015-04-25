class CreateInclusions < ActiveRecord::Migration
  def change
    create_table :inclusions do |t|
      t.text :note
      t.references :diagnosis, index: true

      t.timestamps
    end
  end
end
