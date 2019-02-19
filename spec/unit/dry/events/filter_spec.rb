RSpec.describe Dry::Events::Filter do
  subject(:filter) { described_class.new(query) }

  context 'nested hash' do
    let(:query) do
      { logger: { level: :info } }
    end

    specify do
      expect(filter.()).to be false
      expect(filter.(logger: { level: :info, output: :stdin })).to be true
      expect(filter.(logger: { level: :debug })).to be false
      expect(filter.(logger: :debug)).to be false
    end
  end

  context 'multi-value check' do
    let(:query) do
      { logger: { level: :info, output: :stdin } }
    end

    specify do
      expect(filter.()).to be false
      expect(filter.(logger: { level: :info, output: :stdin })).to be true
      expect(filter.(logger: { level: :info })).to be false
    end
  end

  context 'top-level array' do
    let(:query) { %i(error fatal) }

    specify do
      expect(filter.()).to be false
      expect(filter.(random: :hash)).to be false
      expect(filter.(:error)).to be true
    end
  end

  context 'nested array' do
    let(:query) do
      { logger: { level: %i(info warn error fatal) } }
    end

    specify do
      expect(filter.()).to be false
      expect(filter.(logger: { level: :info, output: :stdin })).to be true
      expect(filter.(logger: { level: :fatal })).to be true
      expect(filter.(logger: { level: :debug })).to be false
      expect(filter.(level: :debug)).to be false
    end
  end

  context 'nested proc' do
    let(:query) do
      { logger: { level: -> level { %i(error fatal).include?(level) } } }
    end

    specify do
      expect(filter.()).to be false
      expect(filter.(logger: { level: :error, output: :stdin })).to be true
    end
  end

  context 'top-level proc' do
    let(:query) do
      -> level: :debug, ** { %i(error fatal).include?(level) }
    end

    specify do
      expect(filter.()).to be false
      expect(filter.(level: :error, output: :stdin)).to be true
    end
  end
end
