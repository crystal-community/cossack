require "../spec_helper"

Spec2.describe Cossack::RequestOptions do
  let(options) { Cossack::RequestOptions.new }

  describe "#initialize" do
    it "sets default values" do
      expect(options.connect_timeout).to eq 30.0
      expect(options.read_timeout).to eq 30.0
    end
  end

  describe "#connect_timeout=" do
    it "accepts Number" do
      options.connect_timeout = 45
      expect(options.connect_timeout).to eq 45.0
    end

    it "accepts Time::Span" do
      options.connect_timeout = 2.minutes
      expect(options.connect_timeout).to eq 120.0
    end
  end

  describe "#read_timeout=" do
    it "accepts Number" do
      options.read_timeout = 45
      expect(options.read_timeout).to eq 45.0
    end

    it "accepts Time::Span" do
      options.read_timeout = 2.minutes
      expect(options.read_timeout).to eq 120.0
    end
  end
end
