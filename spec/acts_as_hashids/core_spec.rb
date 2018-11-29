require 'spec_helper'

RSpec.describe ActsAsHashids::Core do
  around :context do |block|
    m = ActiveRecord::Migration.new
    m.verbose = false
    m.create_table :core_foos, force: true do |t|
    end
    m.create_table :core_bars, force: true do |t|
      t.integer :core_foo_id, index: true
    end
    begin
      block.call
    ensure
      m.drop_table :core_foos
      m.drop_table :core_bars
    end
  end

  class Base < ActiveRecord::Base
    self.abstract_class = true
    acts_as_hashids length: 4
  end

  class CoreFoo < Base
    has_many :core_bars
  end

  class CoreBar < Base
    belongs_to :core_foo
  end

  describe '.find' do
    subject(:model) { CoreFoo }

    let!(:foo1) { CoreFoo.create }
    let!(:foo2) { CoreFoo.create }

    context 'for single argument' do
      it 'decodes hash id and returns the record' do
        expect(model.find(foo1.to_param)).to eq foo1
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { model.find('bMab') }.to raise_error(
            ActiveRecord::RecordNotFound, "Couldn't find CoreFoo with 'id'=\"bMab\""
          )
        end
      end
      context 'with hash id which looks like a logarithm' do
        let!(:foo1) { CoreFoo.create(id: CoreFoo.hashids.decode('4E93')[0]) }
        let!(:foo2) { CoreFoo.create(id: '4') }

        it 'decodes hash id which looks like a logarithm and returns the record' do
          expect(model.find('4E93')).to eq foo1
          expect(model.find('4')).not_to eq foo1
        end
        it 'decodes hash id and returns the record' do
          expect(model.find('4E93')).not_to eq foo2
          expect(model.find('4')).to eq foo2
        end
      end
      it 'returns the record when finding by string id' do
        expect(model.find(foo1.id.to_s)).to eq foo1
      end
    end
    context 'for multiple arguments' do
      it 'decodes hash id and returns the record' do
        expect(model.find([foo1.to_param, foo2.to_param])).to eq [foo1, foo2]
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { model.find(%w[bMab Qgab]) }.to raise_error(
            ActiveRecord::RecordNotFound,
            "Couldn't find all CoreFoos with 'id': (\"bMab\", \"Qgab\") (found 1 results, but was looking for 2)"
          )
        end
      end
    end
    context 'as ActiveRecord_Relation' do
      it 'decodes hash id and returns the record' do
        expect(model.where(nil).find(foo1.to_param)).to eq foo1
      end
    end
    context 'as ActiveRecord_Associations_CollectionProxy' do
      let(:bar3) { CoreBar.create core_foo: foo1 }
      let(:bar4) { CoreBar.create core_foo: foo1 }

      before do
        bar3
        bar4
      end

      it 'decodes hash id and returns the record' do
        expect(foo1.core_bars.find(bar3.to_param)).to eq bar3
      end
      context 'without arguments' do
        it 'delegates to detect method' do
          allow(foo1.core_bars).to receive(:detect).once.and_call_original
          expect(foo1.core_bars.find { |bar| bar == bar3 }).to eq bar3
          expect(foo1.core_bars).to have_received(:detect).once
        end
      end
    end
    context 'when reloaded' do
      subject(:model) { CoreFoo.create }

      it 'decodes hash id and returns the record' do
        expect do
          model.reload
        end.not_to raise_error
      end
    end
  end
  describe '.with_hashids' do
    subject(:model) { CoreFoo }

    let!(:foo1) { CoreFoo.create }
    let!(:foo2) { CoreFoo.create }

    it 'decodes hash id and returns the record' do
      expect(model.with_hashids([foo1.to_param, foo2.to_param]).all).to eq [foo1, foo2]
    end
    context 'with invalid hash id' do
      it 'raises an exception' do
        expect { model.with_hashids('@').all }.to raise_error(ActsAsHashids::Exception, 'Decode error: ["@"]')
      end
    end
  end
  describe '#to_param' do
    subject(:model) { CoreFoo.create id: 5 }

    it 'returns hash id' do
      expect(model.to_param).to eq 'bMab'
    end
  end
end
