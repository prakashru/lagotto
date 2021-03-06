require 'spec_helper'

describe Copernicus do
  subject { FactoryGirl.create(:copernicus) }

  let(:article) { FactoryGirl.build(:article, :doi => "10.5194/ms-2-175-2011") }

  context "get_data" do
    let(:auth) { ActionController::HttpAuthentication::Basic.encode_credentials(subject.username, subject.password) }

    it "should report that there are no events if the doi is missing" do
      article = FactoryGirl.build(:article, :doi => nil)
      subject.get_data(article).should eq({})
    end

    it "should report that there are no events if the doi has the wrong prefix" do
      article = FactoryGirl.build(:article, :doi => "10.1371/journal.pmed.0020124")
      subject.get_data(article).should eq({})
    end

    it "should report if there are no events and event_count returned by the Copernicus API" do
      article = FactoryGirl.build(:article, :doi => "10.5194/acp-12-12021-2012")
      body = File.read(fixture_path + 'copernicus_nil.json')
      stub = stub_request(:get, "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}").with(:headers => { :authorization => auth }).to_return(:body => body)
      response = subject.get_data(article)
      response.should eq('data' => JSON.parse(body))
      stub.should have_been_requested
    end

    it "should report if there are events and event_count returned by the Copernicus API" do
      body = File.read(fixture_path + 'copernicus.json')
      stub = stub_request(:get, "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}").with(:headers => { :authorization => auth }).to_return(:body => body)
      response = subject.get_data(article)
      response.should eq(JSON.parse(body))
      stub.should have_been_requested
    end

    it "should catch authentication errors with the Copernicus API" do
      stub = stub_request(:get, "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}").with(:headers => { :authorization => auth }).to_return(:headers => { "Content-Type" => "application/json" }, :body => File.read(fixture_path + 'copernicus_unauthorized.json'), :status => [401, "Unauthorized: You are not authorized to access this resource."])
      response = subject.get_data(article, options = { :source_id => subject.id })
      response.should eq(error: "the server responded with status 401 for http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}", status: 401)
      stub.should have_been_requested
      Alert.count.should == 1
      alert = Alert.first
      alert.class_name.should eq("Net::HTTPUnauthorized")
      alert.status.should == 401
      alert.source_id.should == subject.id
    end

    it "should catch timeout errors with the Copernicus API" do
      stub = stub_request(:get, "http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}").with(:headers => { :authorization => auth }).to_return(:status => [408])
      response = subject.get_data(article, options = { :source_id => subject.id })
      response.should eq(error: "the server responded with status 408 for http://harvester.copernicus.org/api/v1/articleStatisticsDoi/doi:#{article.doi}", :status=>408)
      stub.should have_been_requested
      Alert.count.should == 1
      alert = Alert.first
      alert.class_name.should eq("Net::HTTPRequestTimeOut")
      alert.status.should == 408
      alert.source_id.should == subject.id
    end
  end

  context "parse_data" do
    let(:null_response) { { :events=>{}, :events_by_day=>[], :events_by_month=>[], :events_url=>nil, :event_count=>0, :event_metrics=>{:pdf=>0, :html=>0, :shares=>nil, :groups=>nil, :comments=>nil, :likes=>nil, :citations=>nil, :total=>0 } } }

    it "should report if the doi is missing" do
      article = FactoryGirl.build(:article, :doi => nil)
      result = {}
      subject.parse_data(result, article).should eq(null_response)
    end

    it "should report if there are no events and event_count returned by the Copernicus API" do
      body = File.read(fixture_path + 'copernicus_nil.json')
      result = { 'data' => JSON.parse(body) }
      subject.parse_data(result, article).should eq(null_response)
    end

    it "should report if there are events and event_count returned by the Copernicus API" do
      body = File.read(fixture_path + 'copernicus.json')
      result = JSON.parse(body)
      response = subject.parse_data(result, article)
      response[:event_count].should == 83
      events = response[:events]
      events["counter"].should_not be_nil
      events["counter"]["AbstractViews"].to_i.should == 72
    end

    it "should catch timeout errors with the Copernicus API" do
      result = { error: "the server responded with status 408 for http://www.citeulike.org/api/posts/for/doi/#{article.doi}", status: 408 }
      response = subject.parse_data(result, article)
      response.should eq(result)
    end
  end
end
