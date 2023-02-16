# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(_user, record)
    @user = Current.profile
    @record = record
  end
end
