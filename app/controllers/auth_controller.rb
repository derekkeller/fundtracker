class AuthController < ApplicationController
  
  def new
    if ( cookies[:remember_me_id] and cookies[:remember_me_code] and User.find( cookies[:remember_me_id]) and Digest::SHA1.hexdigest( User.find( cookies[:remember_me_id] ).last_login.to_s ) == cookies[:remember_me_code]  )  
      @user = User.find( cookies[:remember_me_id] )  
      session['user_id'] = @user.id 
      set_period
      #todo have it redirect to the referer if there is one.
      if @user.is_admin?
        redirect_to admin_organizations_path
      else
        redirect_to root_url, :notice => "Logged in!"
      end 
    end
  end

  def create
    @user = User.authenticate(params[:email], params[:password])
   
    if @user 
      set_period
      if params[:remember_me]  
        cookies[:remember_me_id] = { :value => @user.id, :expires => 30.days.from_now } 
        userCode = Digest::SHA1.hexdigest( @user.last_login.to_s )  
        cookies[:remember_me_code] = { :value => userCode, :expires => 30.days.from_now }  
      end
      
      session[:user_id] = @user.id
      if @user.is_admin?
        redirect_to admin_organizations_path
      else
        redirect_to root_url, :notice => "Logged in!"
      end
    else
      flash.now.alert = "Invalid credentials"
      render :new
    end
  end
  
  def destroy
    if cookies[:remember_me_id] then cookies.delete :remember_me_id end
    if cookies[:remember_me_code] then cookies.delete :remember_me_code end  
    session[:user_id] = nil
    session[:period] = nil
 		redirect_to(:action => "new")
  end
  
  def forgot_password_form
    
  end
  
  def set_password_recovery_hash
    @user = User.find_by_email(params[:email])
    
    if @user
      #Set the recovery hash, mark the time, email a link to reset the password
      @user.password_recovery_hash = Digest::SHA1.hexdigest( @user.created_at.to_s + Time.now.to_s )
      @user.recovery_hash_created_at = Time.now
      @user.save
      UserMailer.password_recovery_link(@user).deliver
      flash[:notice] = "Check your email for password recovery information"
      redirect_to log_in_path
    else
      # we return them to the forgot_password_form
      flash[:alert] = "No user found for that email address"
      redirect_to forgot_password_form_path
    end
  end
  
  def reset_password_form
    # we need to find the user, make sure the hash is good and not older than half hour
    @user = User.where(:password_recovery_hash => params[:recovery_hash], :id => params[:user_id]).first
    
    if @user.recovery_hash_created_at > Time.now + 30 * 60
      @user.clear_recovery_params_recovery_params
      flash[:alert] = "Time for password reset has expired"
      raise
    else
      @user.clear_recovery_params
      session[:user_id] = @user.id
    end
  rescue
    redirect_to log_in_path
  end
  
  def reset_password
    @user = User.find(session[:user_id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Password reset successful"
      redirect_to root_url
    else
      render :reset_password_form
    end
  end
  
end
