class Api::V1::DiagnosesController < ApplicationController # Api::V1::BaseController
  respond_to :json

  def index
    # sanitized = sanitize_sql_array(["to_tsquery('english', ?)", terms.gsub(/\s/,"+")])
    # Diagnosis.where("search_vector @@ #{sanitized}")

    if params[:search].nil?
      diagnoses = Diagnosis.where(query_params)
    else
      diagnoses = Diagnosis.search(params[:search])
    end

    @diagnoses = diagnoses.page(page_params[:page]).per(page_params[:page_size])

    respond_with @diagnoses
  end

  def show
    respond_with Diagnosis.find_by_code(params[:id])
  end

  private

    # Returns the allowed parameters for searching
    # Override this method in each API controller
    # to permit additional parameters to search on
    # @return [Hash]
    def query_params
      {}
    end

    # Returns the allowed parameters for pagination
    # @return [Hash]
    def page_params
      params.permit(:page, :page_size)
    end
end
