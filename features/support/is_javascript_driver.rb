Before('@javascript') do
  @is_javascript_driver = true
end

module KnowsIfJavaScriptDriver
  def javascript_driver?
    @is_javascript_driver
  end
end

World(KnowsIfJavaScriptDriver)
