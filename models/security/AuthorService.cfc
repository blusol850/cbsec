/**
* ContentBox - A Modular Content Platform
* Copyright since 2012 by Ortus Solutions, Corp
* www.ortussolutions.com/products/contentbox
* ---
* Service to handle user operations.
*/
component extends="Author" accessors="true" singleton{

	// DI
	property name="populator" 				inject="wirebox:populator";
	property name="permissionService"		inject="permissionService@cbsec";
	property name="permissionGroupService"	inject="permissionGroupService@cbsec";
	property name="roleService"				inject="roleService@cbsec";
	property name="bCrypt"					inject="BCrypt@BCrypt";
	property name="dateUtil"				inject="DateUtil@cbsec";
	property name="securityService"			inject="securityService@cbsec";
	

	/**
	* Constructor
	*/
	// AuthorService function init(){
	// 	// init it
	// 	// super.init( entityName="cbAuthor" );

	// 	return this;
	// }

	any function new(){
		return wirebox.getInstance('Author@cbsec');
	}

	any function getLoggedIn(){
		return wirebox.getInstance('Author@cbsec');
	}
	any function isLoaded(){
		return true;
	}

	/**
	* Validate that the sent API Token is valid and active
	*/
	boolean function isValidAPIToken( required APIToken ){
		var c = newCriteria()
			.isEq( "APIToken", arguments.APIToken )
			.isTrue( "isActive" );

		return ( c.count() ? true : false );
	}

	/**
	* Get Author for corresponding API Token
	* @returns Populated User object.  If APIToken isn't found, returns new Author.
	*/
	any function getAuthorizedAuthor( required APIToken ){
		var c = newCriteria()
			.isEq( "APIToken", arguments.APIToken )
			.isTrue( "isActive" );

		return ( c.get() ?: new() );
	}

	/**
	 * Delete an author from the system
	 * @author 			The author object
	 * @transactional 	Auto transactions
	 */
	function deleteAuthor( required author, boolean transactional=true ){
		// Clear permissions, just in case
		arguments.author.clearPermissions();
		// send for deletion
		delete( entity=arguments.author, transactional=arguments.transactional );
	}

	/**
	* This function will encrypt an incoming target string using bcrypt and compare it with another bcrypt string
	*/
	boolean function isSameHash( required incoming, required target ){
		return variables.bcrypt.checkPassword( arguments.incoming, arguments.target );
	}

	/**
	* Create a new author in ContentBox and sends them their email confirmations.
	*
	* @author The target author object to create
	*
	* @returns error:boolean,errorArray
	*/
	struct function createNewAuthor( required author ){

		// Save it
		saveAuthor( author=arguments.author );

		// Send Account Creation
		var mailResults = securityService.sendNewAuthorReminder( arguments.author );

		return mailResults;
	}

	/**
	* Save an author with extra pizazz!
	* @author The author object
	* @passwordChange Are we changing the password
	* @transaactional Auto transactions
	*
	* @returns AuthorService
	*/
	function saveAuthor( required author, boolean passwordChange=false, boolean transactional=true ){
		
		// bcrypt password if new author
		if( !arguments.author.isLoaded() OR arguments.passwordChange ){
			// bcrypt the incoming password
			arguments.author.setPassword( variables.bcrypt.hashPassword( arguments.author.getPassword() ) );
		}

		// Verify if the author has already an API Token, else generate one for them.
		if( !len( arguments.author.getAPIToken() ) ){
			arguments.author.generateAPIToken();
		}

		// save the author
		save( entity=arguments.author, transactional=arguments.transactional );
		return this;
	}


	/**
	* Username checks for authors
	*/
	boolean function usernameFound( required username ){
		var args = { "username" = arguments.username };
		return ( countWhere( argumentCollection = args ) GT 0 );
	}

	/**
	* Email checks for authors
	*/
	boolean function emailFound( required email ){
		var args = { "email" = arguments.email };
		return ( countWhere( argumentCollection = args ) GT 0 );
	}

	

}
