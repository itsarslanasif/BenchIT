class ActionPerformed
  def action_performed(record)
    if record.destroyed?
      'Delete'
    elsif record.created_at.eql?(record.updated_at)
      'Create'
    else
      'Update'
    end
  end
end
