class SearchController < ApplicationController

  def search
    if params[:q].nil?
      @codes = []
    else
      @codes = Code.search params[:q]
    end
  end

end
