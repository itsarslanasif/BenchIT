class AutomationRuleListener < BaseListener
  def conversation_updated(event_obj)
    return if performed_by_automation?(event_obj)

    conversation = event_obj.data[:conversation]
    account = conversation.account
    changed_attributes = event_obj.data[:changed_attributes]

    return unless rule_present?('conversation_updated', account)

    @rules.each do |rule|
      conditions_match = ::AutomationRules::ConditionsFilterService.new(rule, conversation, { changed_attributes: changed_attributes }).perform
      AutomationRules::ActionService.new(rule, account, conversation).perform if conditions_match.present?
    end
  end

  def conversation_created(event_obj)
    return if performed_by_automation?(event_obj)

    conversation = event_obj.data[:conversation]
    account = conversation.account
    changed_attributes = event_obj.data[:changed_attributes]

    return unless rule_present?('conversation_created', account)

    @rules.each do |rule|
      conditions_match = ::AutomationRules::ConditionsFilterService.new(rule, conversation, { changed_attributes: changed_attributes }).perform
      ::AutomationRules::ActionService.new(rule, account, conversation).perform if conditions_match.present?
    end
  end

  def message_created(event_obj)
    return if performed_by_automation?(event_obj)

    message = event_obj.data[:message]
    account = message.try(:account)
    changed_attributes = event_obj.data[:changed_attributes]

    return unless rule_present?('message_created', account)

    @rules.each do |rule|
      conditions_match = ::AutomationRules::ConditionsFilterService.new(rule, message.conversation,
                                                                        { message: message, changed_attributes: changed_attributes }).perform
      ::AutomationRules::ActionService.new(rule, account, message.conversation).perform if conditions_match.present?
    end
  end

  def rule_present?(event_name, account)
    return if account.blank?

    @rules = AutomationRule.where(
      event_name: event_name,
      account_id: account.id,
      active: true
    )
    @rules.any?
  end

  def performed_by_automation?(event_obj)
    event_obj.data[:performed_by].present? && event_obj.data[:performed_by].instance_of?(AutomationRule)
  end
end
