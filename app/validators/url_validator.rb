class UrlValidator < ActiveModel::Validator
  def validate(record)
    if !valid_url?(record.url) || record.url.blank?
      record.errors.add(:base, "not a valid url")
    end
  end

  private

  def valid_url?(value)
    begin
      uri = URI.parse(value)
      valid = uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      valid = false
    end

    valid
  end
end
