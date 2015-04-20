class AddSectionIdToDiagnoses < ActiveRecord::Migration
  def change
    add_reference :diagnoses, :section, index: true
  end
end
