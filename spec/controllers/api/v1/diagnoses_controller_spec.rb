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

  describe "GET #index" do
    before(:each) do
      @diagnosis = FactoryGirl.create :diagnosis
      get :index#, search: 'cholera'
    end

    it "returns stuff" do
      diagnoses_response = json_response[:diagnoses]

      expect(diagnoses_response.empty?).not_to eql true 

      codes = diagnoses_response.collect { |d| d[:code] }
      assert_includes codes, @diagnosis.code
    end

    it { should respond_with 200 }
  end
end
