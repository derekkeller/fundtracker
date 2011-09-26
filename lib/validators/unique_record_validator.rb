class UniqueRecordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless record.new_record?
    if Forecast.where(['month(period) = ? AND year(period) = ? AND company_id = ?', record.period.month, record.period.year, record.company_id]).present?
      record.errors.add(:base, "duplicate financials for this period detected")
    end
  end
end