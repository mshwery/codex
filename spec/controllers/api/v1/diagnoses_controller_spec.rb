require 'spec_helper'

describe Api::V1::DiagnosesController do
  before(:each) { request.headers['Accept'] = "application/vnd.icd10.v1" }

  describe "GET #show" do
    before(:each) do
      @diagnosis = FactoryGirl.create :diagnosis
      get :show, id: @diagnosis.code, format: :json
    end

    it "returns the information about a reporter on a hash" do
      diagnosis_response = JSON.parse(response.body, symbolize_names: true)
      expect(diagnosis_response[:code]).to eql @diagnosis.code
    end

    it { should respond_with 200 }
  end
end

