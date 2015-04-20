class DiagnosesController < BaseApiController

  def search
    if params[:q].nil?
      @diagnoses = []
    else
      @diagnoses = Diagnosis.search(params[:q])
    end  
  end

  def index
    # sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    # Diagnosis.where("search_vector @@ #{sanitized}")

    
    # todo: paginate these results
    @diagnoses = Diagnosis.all
  end

  def show
    @diagnosis = Diagnosis.find(params[:code])
  end

end
