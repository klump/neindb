module ReportsHelper
  def color_status status
    type = nil

    case status
    when 'pass'
      type = 'success'
    when 'fail'
      type = 'danger'
    when 'running'
      type = 'info'
    end

    "<span class=\"label label-#{type}\">#{status.capitalize}</span>".html_safe
  end
end
