class RechargeService
  def recharge(user_id, amount)
    raise BooksException, 'amount must be integer' unless amount.class.to_s == 'Integer'
    raise BooksException, 'amount must must be greater than or equal to' if amount < 0

    user_amount_transaction = nil
    User.transaction do
      UserAmountTransaction.transaction do
        user = User.lock(true).find(user_id)
        # create UserAmountTransaction
        user_amount_transaction = UserAmountTransaction.create!(
          user: user,
          option: :recharge,
          amount: amount,
          from_amount: user.amount,
          to_amount: user.amount + amount
        )
        user.amount += amount
        user.save!
      end
    end
    user_amount_transaction
  end
end
