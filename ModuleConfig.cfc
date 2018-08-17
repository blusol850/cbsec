/**

*/
component {

	// Module Properties
	this.title 				= "cbsec";
	this.author 			= "";
	this.webURL 			= "";
	this.description 		= "";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cbsec";
	// Inherit Entry Point
	this.inheritEntryPoint 	= false;
	// Model Namespace
	this.modelNamespace		= "cbsec";
	// CF Mapping
	this.cfmapping			= "cbsec";
	// Auto-map models
	this.autoMapModels		= true;
	// Module Dependencies
	this.dependencies 		= ['BCrypt','cbstorages','cbmailservices'];

	function configure(){

		// parent settings
		parentSettings = {

		};

		// module settings - stored in modules.name.settings
		settings = {
			successfulLoginRedirect = "/play1",
			signInText = ""
		};

		i18n = {
			resourceBundles = {
		    	"security" = "#moduleMapping#/includes/i18n/security"
		  	},
		  	defaultLocale = "en_US",
		  	localeStorage = "cookie"
		};

		// Layout Settings
		layoutSettings = {
			defaultLayout = "simple.cfm"
		};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern="/", handler="home", action="index" },
			// Convention Route
			{ pattern="/:handler/:action?" }
		];

		// SES Resources
		resources = [
			// { resource = "" }
		];

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = ""
		};

		// Custom Declared Interceptors
		interceptors = [
			// ContentBox security via cbSecurity Module
			{
				class 		= "cbsec.interceptors.Security",
			  	name 		= "cbSecurity",
			  	properties 	= {
			 		rulesSource 		= "model",
			 		rulesModel			= "securityRuleService@cbsec",
			 		rulesModelMethod 	= "getSecurityRules",
			 		validatorModel 		= "securityService@cbsec"
			 	}
			}
            ,{
                class = "#moduleMapping#.interceptors.CheckForForceTwoFactorEnrollment",
                name = "CheckForForceTwoFactorEnrollment"
			}
		];

		// Binder Mappings
		// binder.map("Alias").to("#moduleMapping#.model.MyService");

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){

	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}
