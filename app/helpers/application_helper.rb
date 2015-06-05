module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Alice"      
    end
  end
end
