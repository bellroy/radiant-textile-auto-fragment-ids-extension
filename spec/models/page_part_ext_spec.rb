require File.dirname(__FILE__) + '/../spec_helper'

describe PagePart do
  before(:each) do
    @pp = PagePart.new
  end

  it "should call add_ids before save" do
    @pp.should_receive(:add_ids)

    @pp.save(false)
  end

  describe "#add_ids" do
    it "should alter the PagePart content for PageParts with the Textile filter" do
      @pp.stub!(:filter).and_return(TextileFilter)

      @pp.should_receive(:content=)

      @pp.send(:add_ids)
    end
    it "should assign process_textile result to content" do
      @pp.stub!(:filter).and_return(TextileFilter)
      @pp.stub!(:processed_textile).and_return("processed text")

      @pp.should_receive(:content=).with("processed text")

      @pp.send(:add_ids)
    end
    it "should not alter the PagePart content for PageParts without the Textile filter" do
      @pp.stub!(:filter).and_return(TextFilter)

      @pp.should_not_receive(:content=)

      @pp.send(:add_ids)
    end
  end

  describe "#processed_textile" do
    fixture = {
      "p. text"                  => "p(#RAND). text",
      "bq. text"                 => "bq(#RAND). text",
      "h1. text"                 => "h1(#RAND). text",
      "h2(a-class). text"        => "h2(a-class #RAND). text",
      "h3(#old-id). text"        => "h3(#old-id). text",
      "h4(aclass #old-id). text" => "h4(aclass #old-id). text",
      "p. multiline\ntext"       => "p(#RAND). multiline\ntext",
      "p. multiline\n\np. text"  => "p(#RAND). multiline\n\np(#RAND). text",
      "p."                       => "p.",
      "p. "                      => "p. ",
      "p.  "                     => "p.  ",
    }
    fixture.each do |input, output|
      it "should produce \"#{output}\" from \"#{input}\"" do
        @pp.stub!(:random_id).and_return("RAND")
        @pp.stub!(:content).and_return(input)
        @pp.send(:processed_textile).should == output
      end
    end
  end

  describe "#random_id" do
    it "should call random_options" do
      @pp.should_receive(:random_options).at_least(:once).and_return([])

      @pp.send(:random_id)
    end
    it "should return alphanumeric characters" do
      @pp.send(:random_options).join.should match(/^[a-z0-9]*$/)
    end
    it "should not include easy to confuse characters" do
      [ "u", "v", "l", "1" ].each do |i|
        @pp.send(:random_options).include?(i).should_not be_true
      end
    end
    it "should return 4 characters" do
      3.times do
        @pp.send(:random_id).length.should == 4
      end
    end
    it "should return random strings" do
      3.times do
        @pp.send(:random_id).should_not == @pp.send(:random_id)
      end
    end
  end
end
