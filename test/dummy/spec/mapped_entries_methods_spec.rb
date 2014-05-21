describe 'User::Role' do
  context 'with mapped entries method' do
    let(:enum) { User::Role }

    before { default_user_roles }

    describe '.keys' do
      it 'returns all the keys' do
        expect(enum.keys).to eq [:admin, :editor, :author, :subscriber]
      end
    end

    describe '.values' do
      it 'returns all the values' do
        expect(enum.values).to eq [0, 1, 2, 3]
      end
    end

    describe '.labels' do
      it 'returns all the labels' do
        expect(enum.labels).to eq %w(Admin Editor Author Subscriber)
      end
    end
  end
end
