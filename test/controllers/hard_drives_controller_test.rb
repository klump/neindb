require 'test_helper'

class HardDrivesControllerTest < ActionController::TestCase
  setup do
    @hard_drife = hard_drives(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hard_drives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hard_drife" do
    assert_difference('HardDrive.count') do
      post :create, hard_drife: { capacity_bytes: @hard_drife.capacity_bytes, device_model: @hard_drife.device_model, firmware: @hard_drife.firmware, model: @hard_drife.model, rpm: @hard_drife.rpm, serial: @hard_drife.serial }
    end

    assert_redirected_to hard_drife_path(assigns(:hard_drife))
  end

  test "should show hard_drife" do
    get :show, id: @hard_drife
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hard_drife
    assert_response :success
  end

  test "should update hard_drife" do
    patch :update, id: @hard_drife, hard_drife: { capacity_bytes: @hard_drife.capacity_bytes, device_model: @hard_drife.device_model, firmware: @hard_drife.firmware, model: @hard_drife.model, rpm: @hard_drife.rpm, serial: @hard_drife.serial }
    assert_redirected_to hard_drife_path(assigns(:hard_drife))
  end

  test "should destroy hard_drife" do
    assert_difference('HardDrive.count', -1) do
      delete :destroy, id: @hard_drife
    end

    assert_redirected_to hard_drives_path
  end
end
