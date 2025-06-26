module GuestUserRestriction
  extend ActiveSupport::Concern

  included do
    before_action :reject_guest_user, only: [:edit, :update, :destroy, :new, :create]
  end

  private

  def reject_guest_user
    if current_user.guest?
      redirect_to(request.referer || root_path, alert: 'ゲストユーザーのアクセスを禁止しています')
    end
  end
end