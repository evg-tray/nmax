RSpec.describe Nmax do
  it "has a version number" do
    expect(Nmax::VERSION).not_to be nil
  end

  context "#find_numbers" do
    let(:numbers_count) { 3 }
    let(:stream) { StringIO.new("text data") }

    subject { described_class.find_numbers(stream, numbers_count) }

    context "when valid params given" do

      context "when input has no numbers" do
        it "should return empty array" do
          expect(subject).to eq []
        end
      end

      context "when input has numbers" do
        let(:number1) { rand(1000) }
        let(:number2) { rand(1000) }
        let(:number3) { rand(1000) }
        let(:number4) { rand(1000) }
        let(:big_number) { "1#{'0'*1000}".to_i + 1 }

        let(:stream) { StringIO.new(text_data) }

        context "when input has no numbers more than 1000 digits" do
          let(:text_data) { "#{number1}text#{number2}text#{number3}text#{number4}" }

          it "should return 3 maximum numbers" do
            result = [number1, number2, number3, number4].max(3)
            expect(subject).to eq result
          end
        end

        context "when input has numbers with more than 1000 digits" do
          let(:text_data) { "#{number1}text#{number2}text#{big_number}" }

          it "should not return numbers with more than 1000 digits" do
            expect(subject).not_to include big_number
          end
        end

        context "when number between reading chunks" do
          let(:number) { "#{rand(100)}#{'1'*10}".to_i }
          let(:text_data) { "text text #{number} text text"}
          let(:stream) { StringIO.new(text_data) }

          before { stub_const("Nmax::CHUNK_SIZE", 4) }

          it "should return this number" do
            expect(subject).to eq [number]
          end
        end
      end
    end

    context "when invalid stream param given" do
      let(:stream) { StringIO.new }

      before { allow_any_instance_of(StringIO).to receive(:tty?).and_return(true) }

      it "should return nil" do
        expect(subject).to eq nil
      end
    end

    context "when invalid number_count param given" do
      let(:numbers_count) { 0 }

      it "should return nil" do
        expect(subject).to eq nil
      end
    end

    context "when invalid stream and number_count params given" do
      let(:stream) { StringIO.new }
      let(:numbers_count) { 0 }

      before { allow_any_instance_of(StringIO).to receive(:tty?).and_return(true) }

      it "should return nil" do
        expect(subject).to eq nil
      end
    end

  end

end
