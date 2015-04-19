class AddTsvectorToDiagnoses < ActiveRecord::Migration
  def up
    # 1. create the search vector column
    add_column :diagnoses, :search_vector, 'tsvector'

    # 2. create the gin index on the search vector
    execute <<-SQL
      CREATE INDEX diagnoses_search_idx
      ON diagnoses
      USING gin(search_vector)
    SQL

    # 4 (optional). Trigger to update the vector column when the diagnoses table is updated
    execute <<-SQL
      DROP TRIGGER IF EXISTS diagnoses_search_vector_update on diagnoses;

      CREATE TRIGGER diagnoses_search_vector_update
      BEFORE INSERT OR UPDATE
      ON diagnoses
      FOR EACH ROW EXECUTE PROCEDURE
      tsvector_update_trigger(search_vector, 'pg_catalog.english', code, description);
    SQL

    Diagnosis.find_each { |d| d.touch }
  end

  def down
    remove_column :diagnoses, :search_vector

    execute <<-SQL
      DROP TRIGGER IF EXISTS diagnoses_search_vector_update on diagnoses;
    SQL
  end
end
