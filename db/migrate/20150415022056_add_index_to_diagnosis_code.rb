class AddIndexToDiagnosisCode < ActiveRecord::Migration
  def change
    add_index :diagnoses, :code, :unique => true
  end
end
