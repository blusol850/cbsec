<!-- dynamic assets -->
<cfoutput>
    <!--- ********************************************************************* --->
    <!---        Fonts - Brought in last to prevent blocking issues             --->
    <!--- ********************************************************************* --->
    <link href='//fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,900,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css'>
    <link href='//fonts.googleapis.com/css?family=Open+Sans:400,700' rel='stylesheet' type='text/css'>
    <!--- ********************************************************************* --->
    <!---                           EVENTS                                      --->
    <!--- ********************************************************************* --->
    <cfif event.getCurrentLayout() EQ "simple">
        #announceInterception( "cbadmin_beforeLoginBodyEnd" )#
    <cfelse>
	    #announceInterception( "cbadmin_beforeBodyEnd" )#
    </cfif>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
</cfoutput>
