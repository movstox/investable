module ApplicationHelper
  def has_data(v)
    (v.kind_of?(Array) && v.any?) || (v.kind_of?(String) && v.present? && (v != 'N/A'))
  end

  def l(data, key)
    data[key][:label]
  end

  def v(data, key)
    data[key][:value]
  end
end
