require 'test_helper'

class ComputersControllerTest < ActionController::TestCase
  setup do
    @computer = computers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:computers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create computer" do
    assert_difference('Computer.count') do
      post :create, computer: { bios_vendor: @computer.bios_vendor, bios_version: @computer.bios_version, dimm_slots: @computer.dimm_slots, location: @computer.location, pci_slots: @computer.pci_slots, product_name: @computer.product_name, serial: @computer.serial, vendor: @computer.vendor }
    end

    assert_redirected_to computer_path(assigns(:computer))
  end

  test "should show computer" do
    get :show, id: @computer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @computer
    assert_response :success
  end

  test "should update computer" do
    patch :update, id: @computer, computer: { bios_vendor: @computer.bios_vendor, bios_version: @computer.bios_version, dimm_slots: @computer.dimm_slots, location: @computer.location, pci_slots: @computer.pci_slots, product_name: @computer.product_name, serial: @computer.serial, vendor: @computer.vendor }
    assert_redirected_to computer_path(assigns(:computer))
  end

  test "should destroy computer" do
    assert_difference('Computer.count', -1) do
      delete :destroy, id: @computer
    end

    assert_redirected_to computers_path
  end
end
