### Logging Portlet - Dynamic Plugin for dotCMS

The Logging Portlet allows a CMS Administrator in dotCMS to dynamically set logging levels of
classes and packages at runtime that are known to the dotCMS JVM. It is also possible to add
dynamic classes/packages to this plugin by, after making sure you are exporting them from your
other dynamic plugins, add them to the Activator's start function (see example already there).

### Install

#### Disclaimer
Everyone has their own way of installing dotCMS plugins. :) I happen to use the old ant build.xml and Eclipse way.

#### Preconditions
1. If you are running from source, make sure you have built and deployed the dotCMS 
 BEFORE trying to build this plugin.  To do this, from the ROOT of dotCMS, execute the 
 "deploy" task of the build.xml ant file to create the standard dotcms_xx.jar file (ant build) 
 This will build the monolithic dotCMS .jar with the libraries needed to build OSGi plugins 
 and place it in the dotCMS/WEB-INF/lib directory.
	
2. If so desired, you can 'import' this folder as an Eclipse project. I prefer to work in
	Eclipse so that's how I've got it setup. After doing this, you will need to update the
	build path of the project to reference the jars in your own dotCMS install directory.

#### Creating the Jar
1. Open the 'build.xml' file and update the 'app.base' value to match the install 
	location of your dotCMS install. This will let the build script know where the appropriate
	dotCMS libraries are.
2. From this directory (ROOT of the plugin), execute the "build" task of the build.xml ant 
	file to create the bundle jar file.

#### To install this bundle:
Copy the bundle jar file inside the Felix OSGI container (dotCMS/felix/load).
	OR
Upload the bundle jar file using the dotCMS UI (CMS Admin->Dynamic Plugins->Upload Plugin).
	
#### To uninstall this bundle:
Remove the bundle jar file from the Felix OSGI container (dotCMS/felix/load).
	OR
Undeploy the bundle using the dotCMS UI (CMS Admin->Dynamic Plugins->Undeploy).
    
#### To add the portlet to a tab:
1. Go to the 'Roles and Tabs' option under CMS Admin
2. Find 'CMS Administrator' under the 'System' tree on the left
3. Choose 'CMS Tabs'
4. Click on the 'System' tab
5. From the drop down, choose 'javax.portlet.title.LOGGING_CONFIG_JSP' and hit 'Add'
6. Order the portlets as necessary and click 'Save'
	
#### To set the name of the Portlet in the dotCMS Menu:
1. Choose languages from the 'System' tab
2. Edit the United States Language Variables
3. Add a new property
4. For the key 'javax.portlet.title.LOGGING_CONFIG_JSP' add 'Log Configuration' as the English

#### Adding Log4j-2.1 Version of JSP
While dotCMS does not yet support log4j 2.1, we have found issues with
thread contention with the 1.2 version that is packaged with dotCMS 2.5
and previous releases. The added log4j-2.1-loggingConfig.jsp along with
the attached jars will allow this new plugin to run (though no promises
about how the jars will cause the overall dotCMS instance to run).