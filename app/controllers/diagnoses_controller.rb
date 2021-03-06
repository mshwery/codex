class DiagnosesController < ApplicationController

  def search
    if params[:q].nil?
      @diagnoses = []
    else
      @diagnoses = Diagnosis.search(params[:q])
    end  
  end

  def index
    # todo: paginate these results
    @diagnoses = Diagnosis.all
  end

  def show
    @diagnosis = Diagnosis.find(params[:code])
  end

end
