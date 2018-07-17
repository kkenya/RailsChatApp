require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User',
                     email: 'user@example.com',
                     password: 'password',
                     password_confirmation: 'password')
  end

  test 'ユーザーが有効であること' do
    assert @user.valid?
  end

  test '名前が存在していること' do
    @user.name = ' '
    assert_not @user.valid?
  end

  test 'メールが存在してること' do
    @user.email = ' '
    assert_not @user.valid?
  end

  test '名前が長すぎないこと' do
    @user.name = 'a' * 256
    assert_not @user.valid?
  end

  test 'メールが長すぎないこと' do
    @user.email = 'a' * 256
    assert_not @user.valid?
  end

  test 'メールの形式が正しいこと' do
    valid_addresses = %w[
      user@example.com
      USER@foo.COM
      A_US-ER@foo.bar.org
      first.last@foo.jp
      alice+bob@baz.cn
    ]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'メールの形式が正しくない場合無効であること' do
    invalid_addresses = %w[
      user@example
      USER.foo.COM
      A_US-ER@foo.bar.org@first.last@foo.jp
      alice+bob@bar+baz.cn
    ]
    invalid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be invalid"
    end
  end

  test 'メールが一意であること' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert duplicate_user.invalid?
  end

  test 'メールが小文字で保存されること' do
    mixed_case_email = 'Foo@ExAmPlE.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
end
