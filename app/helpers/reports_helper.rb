module ReportsHelper
  def color_status status
    type = nil

    case status
    when 'success'
      type = 'success'
    when 'failure'
      type = 'danger'
    when 'running'
      type = 'info'
    end

    "<span class=\"label label-#{type}\">#{status.capitalize}</span>".html_safe
  end

  def color_parser_status status
    return '&nbsp'.html_safe if status.blank?

    type = nil

    case status
    when 'success'
      type = 'success'
    when 'failure'
      type = 'danger'
    when 'parsing'
      type = 'info'
    end

    "<span class=\"label label-#{type}\">#{status.capitalize}</span>".html_safe
  end
end
