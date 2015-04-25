class Diagnosis < ActiveRecord::Base
  has_many :subdiagnoses, class_name: "Diagnosis", foreign_key: "diagnosis_id", dependent: :destroy
  belongs_to :parent, class_name: "Diagnosis", foreign_key: "diagnosis_id"

  validates :code, presence: true, uniqueness: true

  def self.search(terms = "")
    sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+") + ":*"])
    Diagnosis.where("search_vector @@ #{sanitized}")
  end

end
