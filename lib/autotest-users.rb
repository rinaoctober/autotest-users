require "autotest-users/version"

module Autotest

  class << self
    attr_accessor :email, :password

    def configure
      yield self
    end
  end

  module Users

    def create_user(name)
      require "randexp"

      @users ||= Hash.new
      @users[name] ||= Hash.new

      first_name = /[:first_name:]/.gen
      last_name = /[:last_name:]/.gen

      @users[name]['first_name'] = first_name
      @users[name]['last_name'] = last_name
      email = Autotest.email.split('@')
      @users[name]['email'] = "%s+%s%s@%s" % [email[0], first_name.downcase, last_name.downcase, email[1]]
      @users[name]['password'] = Autotest.password
    end

    def get_user(name)
      @users[name]
    end

    def set_user_data(name, type, data)
      @users[name][type] = data
    end

    def get_user_data(name, type)
      @users[name][type]
    end

    def set_current(name)
      @current ||= Hash.new
      if ((name != 'anonymous') or (name != 'anonim'))
	@current['first_name'] = @users[name]['first_name']
	@current['email'] = @users[name]['email']
	@current['password'] = @users[name]['password']
      else
	@current['first_name'] = 'anonymous'
	@current['email'] = 'anonymous'
	@current['password'] = 'anonymous'
      end
    end

    def get_current(type)
      @current[type]
    end

  end
end

Autotest.configure do |config|
  config.email = 'email@example.com'
  config.password = 'password'
end
