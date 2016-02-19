require "spec_helper"

describe Jpegtran::Configuration do
  let(:configuration) { described_class.new }
  subject { configuration }

  describe "#default_executable" do
    it "detects the existance of jpegtran" do
      expect(subject).to receive(:`).with("which jpegtran").and_return("/bin/jpegtran")
      subject.default_executable
    end
  end

  describe "#executable" do
    it "can be configured" do
      subject.executable = "/custom/path/jpegtran"
      expect(subject.executable).to eql "/custom/path/jpegtran"
    end

    it "uses default_executable by default" do
      expect(subject).to receive(:default_executable).and_return("/bin/jpegtran")
      expect(subject.executable).to eql "/bin/jpegtran"
    end
  end
end
