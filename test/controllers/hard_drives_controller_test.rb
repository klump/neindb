require 'test_helper'

class HardDrivesControllerTest < ActionController::TestCase
  setup do
    @hard_drive = hard_drives(:one)
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

  test "should create hard_drive" do
    assert_difference('HardDrive.count') do
      post :create, hard_drive: { capacity_bytes: @hard_drive.capacity_bytes, device_model: @hard_drive.device_model, firmware: @hard_drive.firmware, model: @hard_drive.model, rpm: @hard_drive.rpm, serial: @hard_drive.serial }
    end

    assert_redirected_to hard_drive_path(assigns(:hard_drive))
  end

  test "should show hard_drive" do
    get :show, id: @hard_drive
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hard_drive
    assert_response :success
  end

  test "should update hard_drive" do
    patch :update, id: @hard_drive, hard_drive: { capacity_bytes: @hard_drive.capacity_bytes, device_model: @hard_drive.device_model, firmware: @hard_drive.firmware, model: @hard_drive.model, rpm: @hard_drive.rpm, serial: @hard_drive.serial }
    assert_redirected_to hard_drive_path(assigns(:hard_drive))
  end

  test "should destroy hard_drive" do
    assert_difference('HardDrive.count', -1) do
      delete :destroy, id: @hard_drive
    end

    assert_redirected_to hard_drives_path
  end
end
