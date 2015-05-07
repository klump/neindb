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
end
