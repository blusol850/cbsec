/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* ContentBox security handler
*/
component{

	// DI
	property name="securityService" 	inject="securityService@cbsec";
	property name="authorService" 		inject="authorService@cbsec";
	// property name="cb"					inject="cbhelper@cb";
	property name="messagebox"			inject="messagebox@cbMessagebox";
	property name="twoFactorService" 	inject="twoFactorService@cbsec";

	/**
	* Pre handler
	*/
	function preHandler( event, currentAction, rc, prc ){
		prc.langs 		= '';
		prc.xehLang 	= event.buildLink( "#event.getModuleEntryPoint('cbsec')#/language" );
	}

}
