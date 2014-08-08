require 'spec_helper'

describe Contextify::Permission do
  class ManageUserPolicy; end
  class DeleteTaskPolicy; end
  class TaskPolicy; end

  class Permission
    include Contextify::Permission
  end

  let(:permission) { Permission.new }

  describe 'has_action_policy?' do

    describe 'where there is only a policy for one action on the object' do
      context 'for the specific action' do
        before do
          allow(permission).to receive(:action_name).and_return('manage')
          allow(permission).to receive(:object_type).and_return('User')
        end

        specify 'that there is a policy available' do
          expect(permission).to have_action_policy
        end
      end

      context 'for any other action' do
        before do
          allow(permission).to receive(:action_name).and_return('create')
          allow(permission).to receive(:object_type).and_return('User')
        end

        specify 'that there is NO policy available' do
          expect(permission).to_not have_action_policy
        end
      end
    end
  end

  describe 'has_type_policy?' do
    describe 'when there is a fallback policy' do
      context 'for any action' do
        before do
          allow(permission).to receive(:action_name).and_return('create')
          allow(permission).to receive(:object_type).and_return('Task')
        end

        specify 'that there is a policy available' do
          expect(permission).to have_type_policy
        end
      end
    end
  end

  describe '#apply_to' do
    let(:action_class)    { double(:action_class) }
    let(:type_class)      { double(:type_class) }
    let(:action_instance) { double(:action_instance) }
    let(:type_instance)   { double(:type_instance) }
    let(:ability)         { double(:ability) }

    before do
      allow(permission).to receive(:policy_action_class).and_return(action_class)
      allow(permission).to receive(:policy_type_class).and_return(type_class)
    end

    context 'the permission has an action policy' do
      before do
        allow(permission).to receive(:has_action_policy?).and_return(true)
      end

      specify do
        expect(action_class).to receive(:new).with(ability).and_return(action_instance)
        expect(action_instance).to receive(:apply!)
        expect(type_class).to_not receive(:new)
        expect(ability).to_not receive(:can)
        permission.apply_to(ability)
      end
    end

    context 'the permission has a type policy' do
      before do
        allow(permission).to receive(:has_action_policy?).and_return(false)
        allow(permission).to receive(:has_type_policy?).and_return(true)
      end

      specify do
        expect(action_class).to_not receive(:new)
        expect(type_class).to receive(:new).with(ability).and_return(type_instance)
        expect(type_instance).to receive(:apply!)
        expect(ability).to_not receive(:can)
        permission.apply_to(ability)
      end
    end

    context 'the permission has no policies defined' do
      before do
        allow(permission).to receive(:has_action_policy?).and_return(false)
        allow(permission).to receive(:has_type_policy?).and_return(false)
        allow(permission).to receive(:action_name).and_return('action')
        allow(permission).to receive(:object_type).and_return('Object')
      end

      specify do
        expect(action_class).to_not receive(:new)
        expect(type_class).to_not receive(:new)
        expect(ability).to receive(:can).with(:action, Object)
        permission.apply_to(ability)
      end
    end
  end
end
