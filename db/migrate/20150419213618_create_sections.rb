class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.string :code_range
      t.string :first_code
      t.string :last_code

      t.timestamps
    end
  end
end
