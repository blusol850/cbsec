<cfoutput>
<div>
    <div class="col-md-4">
        <div class="panel panel-primary animated fadeInDown">
            <div class="panel-heading">
                <h3 class="panel-title">
                   <i class="fa fa-key"></i> Login
                </h3>
            </div>
            <div class="panel-body">
	        	<!--- Render Messagebox. --->
				#getModel( "messagebox@cbMessagebox" ).renderit()#

                #html.startForm(
                	action		= prc.xehDoLogin,
                	ssl 		= event.isSSL(),
                	name		= "loginForm",
                	novalidate	= "novalidate",
                	class		= "form-horizontal"
                )#
					#html.hiddenField( name="_securedURL", value=rc._securedURL )#

					<!--- Sign In Text --->
					<cfif len( getModuleSettings('cbsec').signInText )>#getModuleSettings('cbsec').signInText#</cfif>


                	<!--- Event --->
					#announceInterception( "cbadmin_beforeLoginForm" )#

	                <div class="form-group">
	                    <div class="col-md-12 controls">
	                        #html.textfield(
	                        	name			= "username",
	                        	required		= "required",
	                        	class			= "form-control",
	                        	value			= prc.rememberMe,
	                        	placeholder		= $r( "common.username@security" ),
	                        	autocomplete	= "off"
	                        )#
	                        <i class="fa fa-user"></i>
	                    </div>
	                </div>
	                <div class="form-group">
	                   <div class="col-md-12 controls">
	                        #html.passwordField(
	                        	name			= "password",
	                        	required		= "required",
	                        	class			= "form-control",
	                        	placeholder		= $r( "common.password@security" ),
	                        	autocomplete	= "off"
	                        )#
	                        <i class="fa fa-lock"></i>

	                    </div>
	                    <div class="col-md-12">
							<a href="#event.buildLink( prc.xehLostPassword )#" class="help-block">#$r( "lostpassword@security" )#?</a>
						</div>
	                </div>
	                <div class="form-group">
	                	<div class="col-md-12">
							<label class="checkbox">
								#$r( "rememberme@security" )#<br>
	                            #html.select(
	                                name 	= "rememberMe",
	                                class 	= "form-control input-sm",
	                                options = html.option( value="0", content=#$r( "rememberme.session@security" )# ) &
	                                        html.option( value="1", content=#$r( "rememberme.day@security" )# ) &
	                                        html.option( value="7", content=#$r( "rememberme.week@security" )# ) &
	                                        html.option( value="30", content=#$r( "rememberme.month@security" )# ) &
	                                        html.option( value="365", content=#$r( "rememberme.year@security")# )
	                            )#
							</label>
						</div>
					</div>
	                <div class="form-group">
	                   <div class="col-md-12 text-center">
							   <button type="submit" class="btn btn-primary">
	                   			#$r( "common.login@security" )#
	                   		</button>
	                    </div>
	                </div>

	                <!--- Event --->
					#announceInterception( "cbadmin_afterLoginForm" )#

                #html.endForm()#
            </div>
        </div>
    </div>
</div>
</cfoutput>
