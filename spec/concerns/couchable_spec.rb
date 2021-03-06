require 'spec_helper'

describe Source do

  context "CouchDB" do
    before(:each) do
      subject.put_lagotto_database
    end

    after(:each) do
      subject.delete_lagotto_database
    end

    let(:id) { "test" }
    let(:url) { "#{CONFIG[:couchdb_url]}#{id}" }
    let(:data) { { "name" => "Fred"} }
    let(:error) { {"error"=>"not_found", "reason"=>"missing"} }

    it "put filter views" do
      # data = subject.get_lagotto_data("_design/filter/_view/html_ratio")
    end

    it "get database info" do
      rev = subject.put_lagotto_data(url, data: data)

      get_info = subject.get_lagotto_database
      db_name = Addressable::URI.parse(CONFIG[:couchdb_url]).path[1..-2]
      get_info["db_name"].should eq(db_name)
      get_info["disk_size"].should be > 0
      get_info["doc_count"].should be > 1
    end

    it "put, get and delete data" do
      rev = subject.put_lagotto_data(url, data: data)
      rev.should_not be_nil

      get_response = subject.get_lagotto_data(id)
      get_response.should include("_id" => id, "_rev" => rev)

      new_rev = subject.save_lagotto_data(id, data: data)
      new_rev.should_not be_nil
      new_rev.should_not eq(rev)

      delete_rev = subject.remove_lagotto_data(id)
      delete_rev.should_not be_nil
      delete_rev.should_not eq(rev)
      delete_rev.should include("3-")
    end

    it "get correct revision" do
      rev = subject.put_lagotto_data(url, data: data)
      rev.should_not be_nil

      new_rev = subject.get_lagotto_rev(id)
      new_rev.should_not be_nil
      new_rev.should eq(rev)
    end

    it "get nil for missing id" do
      rev = subject.get_lagotto_rev("xxx")
      rev.should be_blank
    end

    it "handle revisions" do
      rev = subject.save_lagotto_data(id, data: data)
      new_rev = subject.save_lagotto_data(id, data: data)
      new_rev.should_not be_nil
      new_rev.should_not eq(rev)
      delete_rev = subject.remove_lagotto_data(id)
      delete_rev.should_not eq(new_rev)
    end

    it "revision conflict" do
      rev = subject.put_lagotto_data(url, data: data)
      new_rev = subject.put_lagotto_data(url, data: data)

      Alert.count.should == 1
      alert = Alert.first
      alert.class_name.should eq("Net::HTTPConflict")
      alert.status.should == 409
    end

    it "handle missing data" do
      get_response = subject.get_lagotto_data(id)
      get_response.should eq(error: "not_found", status: 404)
      Alert.count.should == 0
    end
  end
end
