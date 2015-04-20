require 'spec_helper'

describe Api::V1::DiagnosesController do
  describe "GET #show" do
    before(:each) do
      @diagnosis = FactoryGirl.create :diagnosis
      get :show, id: @diagnosis.code
    end

    it "returns the information about a reporter on a hash" do
      diagnosis_response = json_response
      expect(diagnosis_response[:code]).to eql @diagnosis.code
    end

    it { should respond_with 200 }
  end
end
