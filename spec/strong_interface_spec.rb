# frozen_string_literal: true

RSpec.describe StrongInterface do
  it 'has a version number' do
    expect(StrongInterface::VERSION).not_to be nil
  end

  it 'raise error when one of a interface methods is not implemented' do
    expect {
      module IVoice
        def say(*); end
        def scream(*); end
      end

      class TestClass
        extend StrongInterface
        implements IVoice

        def say(text)
          # Say text somehow
        end
      end
    }.to raise_error(StrongInterface::MethodNotImplemented)
  end

  it 'do not raise error when everything is ok' do
    expect {
      module IVoice
        def say(*); end
        def scream(*); end
      end

      class TestClass
        extend StrongInterface
        implements IVoice

        def say(text)
          # Say the text somehow
        end

        def scream(text)
          # Scream the text somehow
        end
      end
    }.not_to raise_error
  end
end

