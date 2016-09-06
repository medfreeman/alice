module WaitForAjax
  def wait_for_ajax
  	if javascript_driver?
	    Timeout.timeout(20) do
	      loop until finished_all_ajax_requests?
	    end
	  end
  end

  def finished_all_ajax_requests?
    requests = page.evaluate_script('jQuery.active')
    requests.zero?
  end
end
World(WaitForAjax)