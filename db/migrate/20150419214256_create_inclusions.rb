class CreateInclusions < ActiveRecord::Migration
  def change
    create_table :inclusions do |t|
      t.string :note
      t.references :diagnosis, index: true

      t.timestamps
    end
  end
end
