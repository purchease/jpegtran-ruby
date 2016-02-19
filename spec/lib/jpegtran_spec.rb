require "spec_helper"

describe Jpegtran do
  describe "#executable" do
    let(:configuration) { described_class.configuration }

    it "comes from configuration" do
      expect(configuration).to receive(:executable).and_return("/bin/jpegtran")
      expect(described_class.executable).to eql "/bin/jpegtran"
    end
  end

  describe "#configure" do
    it "configures the config" do
      subject.configure { |c| c.executable = "/custom/path/jpegtran" }
      expect(subject.executable).to eql "/custom/path/jpegtran"
    end
  end

  describe "#configured?" do
    it "returns true if executable is configured" do
      expect(subject).to receive(:executable).and_return("/bin/jpegtran")
      expect(subject.configured?).to be true
    end

    it "returns false if executable isn't configured" do
      expect(subject).to receive(:executable).and_return(nil)
      expect(subject.configured?).to be false
    end
  end

  describe "#optimize" do
    before { subject.configure { |c| c.executable = "/bin/jpegtran" }}

    described_class::BOOLEAN_ARGS.each do |option_name|
      context "with #{option_name} option" do
        it "adds #{option_name} switch to jpegtran executable" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -#{option_name} -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", option_name => true
        end

        it "doesn't add #{option_name} switch if the value is false" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", option_name => false
        end
      end
    end

    [ :rotate, :restart ].each do |option_name|
      context "with #{option_name} option" do
        it "adds #{option_name} switch to jpegtran executable" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -#{option_name} 90 -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", option_name => 90
        end

        it "raises an exception if #{option_name} value isn't a Fixnum" do
          expect { subject.optimize "image.jpg", option_name => "string" }.to \
            raise_error Jpegtran::Error
        end
      end
    end

    [ :crop, :scans ].each do |option_name|
      context "with #{option_name} option" do
        it "adds #{option_name} switch to jpegtran executable" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -#{option_name} string -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", option_name => "string"
        end

        it "raises an exception if #{option_name} value isn't a String" do
          expect { subject.optimize "image.jpg", option_name => true }.to \
            raise_error Jpegtran::Error
        end
      end
    end

    context "with copy option" do
      described_class::COPY_OPTIONS.each do |option_value|
        it "adds copy switch to jpegtran executable if the value is #{option_value}" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -copy #{option_value} -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", copy: option_value
        end
      end

      it "raises an exception if copy value is unknown" do
        expect { subject.optimize "image.jpg", copy: "unknown" }.to \
          raise_error Jpegtran::Error
      end
    end

    context "with flip option" do
      described_class::FLIP_OPTIONS.each do |option_value|
        it "adds flip switch to jpegtran executable if the value is #{option_value}" do
          expect(IO).to receive(:popen).with("/bin/jpegtran -flip #{option_value} -outfile image.jpg image.jpg")
          subject.optimize "image.jpg", flip: option_value
        end
      end

      it "raises an exception if flip value is unknown" do
        expect { subject.optimize "image.jpg", flip: "unknown" }.to \
          raise_error Jpegtran::Error
      end
    end

    context "with outfile option" do
      it "uses the value for outfile switch" do
        expect(IO).to receive(:popen).with("/bin/jpegtran -outfile optimized.jpg image.jpg")
        subject.optimize "image.jpg", outfile: "optimized.jpg"
      end

      it "raises an exception if outfile value isn't a String" do
        expect { subject.optimize "image.jpg", outfile: true }.to \
          raise_error Jpegtran::Error
      end
    end

    context "with no options" do
      it "overwrites the image by default" do
        expect(IO).to receive(:popen).with("/bin/jpegtran -outfile /path/to/image.jpg /path/to/image.jpg")
        subject.optimize "/path/to/image.jpg"
      end
    end
  end
end
