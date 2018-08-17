﻿/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox security handler
*/
component extends="baseHandler"{

	// DI
	property name="antiSamy"			inject="antisamy@cbantisamy";
	property name="markdown"			inject="Processor@cbmarkdown";

	// Method Security
	this.allowedMethods = {
		doLogin 		= "POST",
		doLostPassword 	= "POST"
	};

	/**
	* Change language
	*/
	function changeLang( event, rc, prc ){
		event.paramValue( "lang", "en_US" );
		setFWLocale( rc.lang );
		relocate( "#event.getModuleEntryPoint('cbsec')#/security" );
	}

	/**
	* Login screen
	*/
	function login( event, rc, prc ){
		// exit handlers
		prc.xehDoLogin 			= "#event.getModuleEntryPoint('cbsec')#.security.doLogin";
		prc.xehLostPassword 	= "#event.getModuleEntryPoint('cbsec')#.security.lostPassword";
		// remember me
		prc.rememberMe = antiSamy.htmlSanitizer( securityService.getRememberMe() );
		// secured URL from security interceptor
		arguments.event.paramValue( "_securedURL", "" );
		rc._securedURL = antiSamy.htmlSanitizer( rc._securedURL );
		// Markdown Processing of sign in text
		prc.signInText = 'Sign In Text';
		// view
		event.setView( view="security/login" );
	}

	/**
	* Do a login
	*/
	function doLogin( event, rc, prc ){
		// params
		event.paramValue( "rememberMe", 0 )
			.paramValue( "_securedURL", "" );

		// Sanitize
		rc.username 	= antiSamy.htmlSanitizer( rc.username );
		rc.password 	= antiSamy.htmlSanitizer( rc.password );
		rc.rememberMe 	= antiSamy.htmlSanitizer( rc.rememberMe );
		rc._securedURL 	= antiSamy.htmlSanitizer( rc._securedURL );

		// announce event
		announceInterception( "cbadmin_preLogin" );

		// Authenticate credentials
		var results = securityService.authenticate( rc.username, rc.password );
		if( results.isAuthenticated ){
			writeDump(results.author.getIs2FactorAuth())
			writeDump(twoFactorService.isForceTwoFactorAuth())
			// Verify if user needs to reset their password?
			if( results.author.getIsPasswordReset() ){
				// var token = securityService.generateResetToken( results.author );
				// messagebox.info( $r( "messages.password_reset_detected@security" ) );
				// relocate(
				// 	event 		= "#event.getModuleEntryPoint('cbsec')#.security.verifyReset",
				// 	queryString = "token=#token#"
				// ); TODO:
			}

			// If Global MFA is turned on and the user is not enrolled to a provider, then force it to enroll
            if( twoFactorService.isForceTwoFactorAuth() AND !results.author.getIs2FactorAuth() ){
				// return runEvent(
				// 	event 			= "cbsec:twoFactorEnrollment.forceEnrollment",
				// 	eventArguments 	= {
				// 		authorID      = results.author.getAuthorID(),
				// 		relocationURL = _securedURL,
				// 		rememberMe 	  = rc.rememberMe
				// 	} );
            }

			// Verify if we have to challenge via two factor auth
			// if( twoFactorService.canChallenge( results.author ) ){
			// 	// Flash data needed for authorizations
			// 	flash.put( "authorData", {
			// 		authorID     = results.author.getAuthorID(),
			// 		rememberMe   = rc.rememberMe,
			// 		securedURL   = rc._securedURL,
			// 		isEnrollment = false
			// 	} );
			// 	// Send challenge
			// 	var twoFactorResults = twoFactorService.sendChallenge( results.author );
			// 	// Verify error, if so, log it and setup a messagebox
			// 	if( twoFactorResults.error ){
			// 		log.error( twoFactorResults.messages );
			// 		// messagebox.error( $r( "twofactor.error@security" ) );
			// 	}
			// 	// Relocate to two factor auth presenter
			// 	relocate( event	= "#event.getModuleEntryPoint('cbsec')#.security.twofactor" );
			// }

			// Set keep me log in remember cookie, if set.
			securityService.setRememberMe( rc.username, val( rc.rememberMe ) );
			// Set in session, validations are now complete
			// securityService.setAuthorSession( results.author ); TODO:

			// announce event
			announceInterception( "cbadmin_onLogin", { author = results.author, securedURL = rc._securedURL } );

			// check if securedURL came in?
			if( len( rc._securedURL ) ){
				relocate( uri=rc._securedURL );
			} else {
				relocate( getModuleSettings('cbsec').successfulLoginRedirect );
			}
		}
		// INVALID LOGINS
		else {
			// announce event
			announceInterception( "cbadmin_onBadLogin" );
			// message and redirect
			messagebox.warn( $r( "messages.invalid_credentials@security" ));
			// Relocate
			relocate( "#event.getModuleEntryPoint('cbsec')#.security.login" );
		}
	}

	/**
	* Logout a user
	*/
	function doLogout( event, rc, prc ){
		// logout
		securityService.logout();
		// announce event
		announceInterception( "cbadmin_onLogout" );
		// message redirect
		messagebox.info( $r( "messages.seeyou@security" ) );
		// relocate
		var relocateTo = prc.cbSettings.cb_security_login_signout_url;
		if( !len( relocateTo ) ){
			relocateTo = "#event.getModuleEntryPoint('cbsec')#.security.login";
		}
		relocate( relocateTo );
	}

	/**
	* Present lost password screen
	*/
	function lostPassword( event, rc, prc ){
		prc.xehLogin 			= "#event.getModuleEntryPoint('cbsec')#.security.login";
		prc.xehDoLostPassword 	= "#event.getModuleEntryPoint('cbsec')#.security.doLostPassword";

		event.setView( view="security/lostPassword" );
	}

	/**
	* Do lost password reset
	*/
	function doLostPassword( event, rc, prc ){
		var errors 	= [];
		var oAuthor = "";

		// Param email
		event.paramValue( "email", "" );

		rc.email = antiSamy.htmlSanitizer( rc.email );

		// Validate email
		if( NOT trim( rc.email ).length() ){
			arrayAppend( errors, "#$r( 'validation.need_email@security' )#<br />" );
		} else {
			// Try To get the Author
			oAuthor = authorService.findWhere( { email = rc.email, isActive = 1 } );
			if( isNull( oAuthor ) OR NOT oAuthor.isLoaded() ){
				// Don't give away that the email did not exist.
				messagebox.info( $r( resource='messages.lostpassword_check@security', values="5" ) );
				relocate( "#event.getModuleEntryPoint('cbsec')#.security.lostPassword" );
			}
		}

		// Check if Errors
		if( NOT arrayLen( errors ) ){
			// Send Reminder
			securityService.sendPasswordReminder( oAuthor );
			// announce event
			announceInterception( "cbadmin_onPasswordReminder", { author = oAuthor } );
			// messagebox
			messagebox.info( $r( resource='messages.reminder_sent@security', values="30" ) );
		} else {
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReminder", { errors = errors, email = rc.email } );
			// messagebox
			messagebox.error( messageArray=errors );
		}
		// Re Route
		relocate( "#event.getModuleEntryPoint('cbsec')#.security.lostPassword" );
	}

	/**
	* Verify the reset
	*/
	function verifyReset( event, rc, prc ){
		event.paramValue( "token", "" );

		// Sanitize
		rc.token = antiSamy.htmlSanitizer( rc.token );

		// Validate Token
		var results = securityService.validateResetToken( trim( rc.token ) );
		if( results.error ){
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// Exception
			messagebox.error( $r( "messages.invalid_token@security" ) );
			relocate( "#event.getModuleEntryPoint('cbsec')#.security.lostPassword" );
			return;
		}

		// Present rest password page.
		prc.xehPasswordChange = "#event.getModuleEntryPoint('cbsec')#.security.doPasswordChange";
		event.setView( view="security/verifyReset" );
	}

	/**
	* Reset a user password. Must have a valid user token setup already
	*/
	function doPasswordChange( event, rc, prc ){
		event.paramValue( "token", "" )
			.paramValue( "password", "" )
			.paramValue( "password_confirmation", "" );

		// Sanitize
		rc.token                 = antiSamy.htmlSanitizer( rc.token );
		rc.password              = antiSamy.htmlSanitizer( rc.password );
		rc.password_confirmation = antiSamy.htmlSanitizer( rc.password_confirmation );

		// Validate passwords
		if( !len( rc.password ) || !len( rc.password_confirmation ) ){
			// Exception
			messagebox.error( $r( "messages.invalid_password@security" ) );
			relocate( event="#event.getModuleEntryPoint('cbsec')#.security.verifyReset", queryString="token=#rc.token#" );
			return;
		}

		// Validate confirmed password
		if( compare( rc.password, rc.password_confirmation ) neq 0 ){
			messagebox.error( $r( "messages.password_mismatch@security" ) );
			relocate( event="#event.getModuleEntryPoint('cbsec')#.security.verifyReset", queryString="token=#rc.token#" );
			return;
		}

		// Validate Token
		var results = securityService.validateResetToken( trim( rc.token ) );
		if( results.error ){
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// Exception
			messagebox.error( $r( "messages.invalid_token@security" ) );
			relocate( "#event.getModuleEntryPoint('cbsec')#.security.lostPassword" );
			return;
		}

		// Validate you are not using the same password if persisted already
		if( authorService.isSameHash( rc.password, results.author.getPassword() ) ){
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			// Exception
			messagebox.error( $r( "messages.password_used@security" ) );
			relocate( event="#event.getModuleEntryPoint('cbsec')#.security.verifyReset", queryString="token=#rc.token#" );
			return;
		}

		// Token is valid, let's reset this sucker.
		var resetResults = securityService.resetUserPassword(
			token 		= rc.token,
			author 		= results.author,
			password 	= rc.password
		);

		if( resetResults.error ){
			// announce event
			announceInterception( "cbadmin_onInvalidPasswordReset", { token = rc.token } );
			messagebox.error( resetResults.messages );
			relocate( "#event.getModuleEntryPoint('cbsec')#.security.lostPassword" );
			return;
		}

		// announce event and relcoate to login with new password
		announceInterception( "cbadmin_onPasswordReset", { author = results.author  } );
		messagebox.info( $r( "messages.password_reset@security" ) );
		relocate( "#event.getModuleEntryPoint('cbsec')#.security.login" );
	}

}