require 'rails_helper'
describe RechargeService  do
  let(:user) { create :user }
  describe 'recharge service' do
    context 'make recharge' do
      it 'should increase user amount and create a UserAmountTransaction' do
        origin_amount = user.amount
        service = RechargeService.new
        user_amount_transaction = service.recharge(user.id, 200)
        user.reload

        expect(user.amount - origin_amount).to eq(200)
        expect(user_amount_transaction.option).to eq("recharge")
        expect(user_amount_transaction.user_id).to eq(user.id)
        expect(user_amount_transaction.amount).to eq(200)
        expect(user_amount_transaction.to_amount - user_amount_transaction.from_amount).to eq(200)
      end
    end

  end
end
