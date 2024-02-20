# frozen_string_literal: true

# people helper
module PeopleHelper
  def filter_non_empty_attributes(attribute, value)
    return if attribute.to_s == 'id'

    attr_label = attribute.to_s.titlecase
    if attribute.present?
      "
        <tr class='py-2'>
          <td><strong>#{attr_label}</strong></td>
          <td class='text-body-secondary'>#{value}</td>
        </tr>
      ".html_safe
    end
  end
end
