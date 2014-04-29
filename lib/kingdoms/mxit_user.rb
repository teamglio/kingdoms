require 'cgi'

class MxitUser
  MOCK_MXIT_HEADERS = {
      'HTTP_X_MXIT_USERID_R' => 'web_user', #m41162520002
      'HTTP_X_MXIT_NICK' => 'Web User'
  }

  def initialize(request_env)
    @env =  MOCK_MXIT_HEADERS.merge(request_env)
    #@env = request_env
  end


  def user_id
    @env['HTTP_X_MXIT_USERID_R']
  end

  def nickname
    CGI.unescape @env['HTTP_X_MXIT_NICK']
  end
end
