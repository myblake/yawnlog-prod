require 'test_helper'

class SleepsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sleeps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sleep" do
    assert_difference('Sleep.count') do
      post :create, :sleep => { }
    end

    assert_redirected_to sleep_path(assigns(:sleep))
  end

  test "should show sleep" do
    get :show, :id => sleeps(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sleeps(:one).id
    assert_response :success
  end

  test "should update sleep" do
    put :update, :id => sleeps(:one).id, :sleep => { }
    assert_redirected_to sleep_path(assigns(:sleep))
  end

  test "should destroy sleep" do
    assert_difference('Sleep.count', -1) do
      delete :destroy, :id => sleeps(:one).id
    end

    assert_redirected_to sleeps_path
  end
end
