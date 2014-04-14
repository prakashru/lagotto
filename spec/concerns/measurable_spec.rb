require 'spec_helper'

describe Source do

  describe "event_metrics" do
    describe "citations" do
      let(:citations) { 12 }
      let(:total) { citations }
      let(:output) do
        { :pdf => nil,
          :html => nil,
          :shares => nil,
          :groups => nil,
          :comments => nil,
          :likes => nil,
          :citations => citations,
          :total => total }
      end

      it 'should return citations' do
        result = subject.event_metrics(citations: citations)
        result.should eq(output)
      end

      it 'should handle strings' do
        result = subject.event_metrics(citations: "#{citations}")
        result.should eq(output)
      end

      it 'should report a separate total value' do
        result = subject.event_metrics(citations: citations, total: 14)
        result[:citations].should == citations
        result[:total].should == 14
      end
    end
  end

end
