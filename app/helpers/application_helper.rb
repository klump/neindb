module ApplicationHelper
  def visualize_status state
    return unless state

    color = ''
    case state
    when 'ok'
      color = 'success'
    when 'warning'
      color = 'warning'
    when 'critical'
      color = 'danger'
    else
      color = ''
    end

    "<span class=\"label label-#{color}\">#{state.capitalize}</span>".html_safe
  end

  def fill_if_empty string
    unless string.present?
      '&nbsp;'.html_safe
    else
      string
    end
  end

  def number_to_human_freq number
    number_to_human(number, units: { unit: "MHz", thousand: "GHz"})
  end
end
