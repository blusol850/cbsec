<cfoutput>
<head>
    <!--- charset --->
    <meta charset="utf-8" />
    <!--- IE Stuff --->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!--- Robots --->
    <meta name="robots" content="noindex,nofollow" />
    <!--- SES --->

    <!--- Title --->
    <title>Login</title>
    <!--- Description --->
    <meta name="description" content="ContentBox Modular CMS - Admin">
    <!--- Viewport for scaling --->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <!--- <link rel="stylesheet" href="#prc.cbroot#/includes/css/contentbox.min.css"> --->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <!--- cbadmin Events --->
    <cfif event.getCurrentLayout() EQ 'simple'>
        #announceInterception( "cbadmin_beforeLoginHeadEnd" )#
    <cfelse>
        #announceInterception( "cbadmin_beforeHeadEnd" )#
    </cfif>


</head>
</cfoutput>
