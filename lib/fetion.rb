require "fetion/version"
require 'net/http'

class Fetion
  def initialize phone, password
    @http = Net::HTTP.new('f.10086.cn')
    @cookie = ""
    @uids = {}
    @phone_number, @password = phone, password
    login
  end
  
  def send phone, msg
    if phone == @phone_number
      send_to_self msg
    else
      uid = get_uid(phone)
      token = get_token uid    
      post '/im/chat/sendMsg.action', "touserid" => uid, "msg" => msg, "csrfToken" => token
    end
 end
  
  def logout
    post "/im/index/logoutsubmit.action"
  end
  
  private 
  
  def login
    res = post "/huc/user/space/login.do?m=submit&fr=space", {mobilenum: @phone_number, password: @password}
    if res.body.size == 0
      cookie =  res["Set-Cookie"].split("; ")
      cookie = cookie.map do |s| 
        if s.include?("ID")|| s.include?("cookie")
          s.split(',').select {|s| !s.include? "Path"}
        end
      end
      @cookie = cookie.compact.join ";"
      post "/im/login/cklogin.action" 
    else
      raise 'Password Not Correct'
    end
  end
  
  def send_to_self msg
    post "/im/user/sendMsgToMyselfs.action", "msg" => msg
  end
  
  def post path, params = {}
    @http.post path, URI.encode_www_form(params), {'Cookie' => @cookie, 'Content-Type' => 'application/x-www-form-urlencoded'}
  end
  
  def get_uid phone
    if @uids[phone]
      @uids[phone]
    else
      res = post '/im/index/searchOtherInfoList.action', "searchText" => phone
      p = res.body.match(/touserid=\d+/)
      if p
        id = p[0].split("=")[1]
        @uids[phone] = id
      else
        raise 'You are not friend'
      end
    end
  end
  
  def get_token uid
    response = post '/im/chat/toinputMsg.action', 'touserid' => uid
    s = response.body.match(/"csrfToken" value="(.*?)"/)[0] 
    # "csrfToken" value="1c3b0f10d95441bfbfc2d1f24d2a2ead"
    s[19..s.size-2]
  end
end
