require 'test_helper'

class DiscountCodesControllerTest < ActionController::TestCase
  setup do
    @discount_code = discount_codes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:discount_codes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discount_code" do
    assert_difference('DiscountCode.count') do
      post :create, discount_code: { code: @discount_code.code, status: @discount_code.status, value: @discount_code.value }
    end

    assert_redirected_to discount_code_path(assigns(:discount_code))
  end

  test "should show discount_code" do
    get :show, id: @discount_code
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @discount_code
    assert_response :success
  end

  test "should update discount_code" do
    patch :update, id: @discount_code, discount_code: { code: @discount_code.code, status: @discount_code.status, value: @discount_code.value }
    assert_redirected_to discount_code_path(assigns(:discount_code))
  end

  test "should destroy discount_code" do
    assert_difference('DiscountCode.count', -1) do
      delete :destroy, id: @discount_code
    end

    assert_redirected_to discount_codes_path
  end
end
