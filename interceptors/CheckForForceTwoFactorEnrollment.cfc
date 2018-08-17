/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Checks for two factor enforcement
*/
component extends="coldbox.system.Interceptor"{

	// DI
    property name="twoFactorService" inject="id:TwoFactorService@cbsec";
    property name="securityService"  inject="id:securityService@cbsec";

	// static ecluded event patterns
    variables.EXCLUDED_EVENT_PATTERNS = [
        "contentbox-security:security.changeLang",
        "contentbox-security:security.login",
        "contentbox-security:security.doLogin",
        "contentbox-security:security.doLogout",
        "contentbox-security:security.lostPassword",
        "contentbox-security:security.doLostPassword",
        "contentbox-security:security.verifyReset",
        "contentbox-security:security.doPasswordChange"
    ];


    /**
    * Configure
    */
    function configure(){}

    /**
     * Process the check on each request
     */
    public void function preProcess( required any event, required struct interceptData, buffer, rc, prc ){
		// Do not execute on the security module
        if ( reFindNoCase( "^cbsec\:", event.getCurrentEvent() ) ) {
            return;
		}

		// Param Values
		param prc.oCurrentAuthor	= securityService.getAuthorSession();

		// User not logged in
		if ( ! prc.oCurrentAuthor.getLoggedIn() ) {
			return;
		}

		// Global force is disabled
		if ( ! twoFactorService.isForceTwoFactorAuth() ) {
			return;
		}

		// User already enrolled
		if ( prc.oCurrentAuthor.getIs2FactorAuth() ) {
			return;
		}
		//bypass 2 factor for now TODO:
		// return;

		// Relocate to force the enrolmment for this user.
		relocate(
			event       = "#event.getModuleEntryPoint('cbsec')#.security.twofactorEnrollment.forceEnrollment",
			queryString = "authorID=#prc.oCurrentAuthor.getAuthorID()#"
		);
    }

}
