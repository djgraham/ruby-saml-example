class SamlController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:consume]  

  def index
    settings = Account.get_saml_settings
    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def consume
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = Account.get_saml_settings

    logger.info "NAMEID: #{response.name_id}"

    if response.is_valid?
      session[:userid] = response.name_id
      redirect_to :action => :complete
    else
      redirect_to :action => :fail
    end
  end

  def metadata
    settings = Account.get_saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render :xml => meta.generate(settings)
  end
  
  def complete
  end
  
  def fail
  end

end
