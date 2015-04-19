class CreateDiagnoses < ActiveRecord::Migration
  def change
    create_table :diagnoses do |t|
      t.string :code
      t.text :description
      t.references :diagnosis, index: true

      t.timestamps
    end
  end
end
