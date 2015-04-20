class SearchController < ApplicationController

  def search
    if params[:q].nil?
      @diagnoses = []
    else
      @diagnoses = Diagnosis.search(params[:q])
    end
  end

end
