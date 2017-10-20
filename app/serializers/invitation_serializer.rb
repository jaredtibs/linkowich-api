class InvitationSerializer < ActiveModel::Serializer

  attributes(
    :id,
    :created_at,
    :viewed,
    :accepted,
    :sender
  )

  def invitation
    @invitation ||= object
  end

  def type
    invitation.class.name
  end

  def sender
    invitation.serialized_sender
  end

end
