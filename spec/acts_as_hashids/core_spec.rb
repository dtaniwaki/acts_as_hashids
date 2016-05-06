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
    acts_as_hashids
  end

  class CoreFoo < Base
    has_many :core_bars
  end

  class CoreBar < Base
    belongs_to :core_foo
  end

  describe '.find' do
    subject { CoreFoo }
    let!(:foo1) { CoreFoo.create }
    let!(:foo2) { CoreFoo.create }
    context 'for single argument' do
      it 'decodes hash id and returns the record' do
        expect(subject.find(foo1.to_param)).to eq foo1
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { subject.find('GXbMabNA') }.to raise_error(
            ActiveRecord::RecordNotFound, "Couldn't find CoreFoo with 'id'=\"GXbMabNA\""
          )
        end
      end
    end
    context 'for multiple arguments' do
      it 'decodes hash id and returns the record' do
        expect(subject.find([foo1.to_param, foo2.to_param])).to eq [foo1, foo2]
      end
      context 'with unexisting hash id' do
        it 'raises an exception' do
          expect { subject.find(%w(GXbMabNA ePQgabdg)) }.to raise_error(
            ActiveRecord::RecordNotFound,
            "Couldn't find all CoreFoos with 'id': (\"GXbMabNA\", \"ePQgabdg\") (found 1 results, but was looking for 2)"
          )
        end
      end
    end
    context 'as ActiveRecord_Relation' do
      it 'decodes hash id and returns the record' do
        expect(subject.where(nil).find(foo1.to_param)).to eq foo1
      end
    end
    context 'as ActiveRecord_Associations_CollectionProxy' do
      let!(:bar3) { CoreBar.create core_foo: foo1 }
      let!(:bar4) { CoreBar.create core_foo: foo1 }
      it 'decodes hash id and returns the record' do
        expect(foo1.core_bars.find(bar3.to_param)).to eq bar3
      end
      context 'without arguments' do
        it 'delegates to detect method' do
          expect(foo1.core_bars).to receive(:detect).once.and_call_original
          expect(foo1.core_bars.find { |bar| bar == bar3 }).to eq bar3
        end
      end
    end
    context 'reloaded' do
      subject { CoreFoo.create }
      it 'decodes hash id and returns the record' do
        expect do
          subject.reload
        end.not_to raise_error
      end
    end
  end
  describe '.with_hashids' do
    subject { CoreFoo }
    let!(:foo1) { CoreFoo.create }
    let!(:foo2) { CoreFoo.create }
    it 'decodes hash id and returns the record' do
      expect(subject.with_hashids([foo1.to_param, foo2.to_param]).all).to eq [foo1, foo2]
    end
    context 'with invalid hash id' do
      it 'raises an exception' do
        expect { subject.with_hashids('@').all }.to raise_error(ActsAsHashids::Exception, 'Decode error: ["@"]')
      end
    end
  end
  describe '#to_param' do
    subject { CoreFoo.create }
    it 'returns hash id' do
      allow(subject).to receive(:id).and_return 5
      expect(subject.to_param).to eq 'GXbMabNA'
    end
  end
end
