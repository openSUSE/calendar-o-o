# frozen_string_literal: true

require 'test_helper'

class EventOcurrancesControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get event_ocurrances_show_url
    assert_response :success
  end

  test 'should get destroy' do
    get event_ocurrances_destroy_url
    assert_response :success
  end
end
